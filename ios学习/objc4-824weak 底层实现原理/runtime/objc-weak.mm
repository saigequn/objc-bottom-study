/*
 * Copyright (c) 2010-2011 Apple Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_LICENSE_HEADER_END@
 */

#include "objc-private.h"

#include "objc-weak.h"

#include <stdint.h>
#include <stdbool.h>
#include <sys/types.h>
#include <libkern/OSAtomic.h>

#define TABLE_SIZE(entry) (entry->mask ? entry->mask + 1 : 0)

static void append_referrer(weak_entry_t *entry, objc_object **new_referrer);

BREAKPOINT_FUNCTION(
    void objc_weak_error(void)
);

static void bad_weak_table(weak_entry_t *entries)
{
    _objc_fatal("bad weak table at %p. This may be a runtime bug or a "
                "memory error somewhere else.", entries);
}

/** 
 * Unique hash function for object pointers only. 唯一的哈希函数仅适用于对象指针。
 * 
 * @param key The object pointer
 * 
 * @return Size unrestricted hash of pointer.
 */
static inline uintptr_t hash_pointer(objc_object *key) {
    // 把指针强转为 unsigned long，然后调用 ptr_hash 函数
    return ptr_hash((uintptr_t)key);
}

/** 
 * Unique hash function for weak object pointers only.
 * 
 * @param key The weak object pointer. 
 * 
 * @return Size unrestricted hash of pointer.
 */
static inline uintptr_t w_hash_pointer(objc_object **key) {
    return ptr_hash((uintptr_t)key);
}

/** 
 * Grow the entry's hash table of referrers. Rehashes each
 * of the referrers.
 * 
 * @param entry Weak pointer hash set for a particular object.
 */
__attribute__((noinline, used))
static void grow_refs_and_insert(weak_entry_t *entry, 
                                 objc_object **new_referrer)
{
    // DEBUG 下的断言，确保当前 weak_entry_t 使用的是 hash 数组模式
    ASSERT(entry->out_of_line());

    size_t old_size = TABLE_SIZE(entry);
    size_t new_size = old_size ? old_size * 2 : 8; // 每次扩容为上一次容量的2倍

    // 记录当前已使用容量
    size_t num_refs = entry->num_refs;
    // 记录旧哈希数组起始地址，在最后要进行释放
    weak_referrer_t *old_refs = entry->referrers;
    // mask 依然是总容量减 1
    entry->mask = new_size - 1;
    
    // 为新 hash 数组申请空间
    // 长度为：总容量 * sizeof(weak_referrer_t)（8）个字节
    entry->referrers = (weak_referrer_t *)
        calloc(TABLE_SIZE(entry), sizeof(weak_referrer_t));
    entry->num_refs = 0;
    entry->max_hash_displacement = 0;
    
    // 这里可以看到，旧的数据需要依次转移到新的内存中
    for (size_t i = 0; i < old_size && num_refs > 0; i++) {
        if (old_refs[i] != nil) {
            append_referrer(entry, old_refs[i]); // 将旧的数据转移到新的动态数组中
            num_refs--;
        }
    }
    // Insert
    // 然后把入参传入的 new_referrer，插入新哈希数组，前面的铺垫都是在做 "数据转移"
    append_referrer(entry, new_referrer);
    if (old_refs) free(old_refs); // 释放旧的内存
}

/** 
 * Add the given referrer to set of weak pointers in this entry.
 * Does not perform duplicate checking (b/c weak pointers are never
 * added to a set twice). 
 *
 * @param entry The entry holding the set of weak pointers. 
 * @param new_referrer The new weak pointer to be added.
 */
static void append_referrer(weak_entry_t *entry, objc_object **new_referrer)
{
    if (! entry->out_of_line()) { // 如果weak_entry 尚未使用动态数组，走这里
        // Try to insert inline.
        for (size_t i = 0; i < WEAK_INLINE_COUNT; i++) {
            // 找到空位把 new_referrer 放进去
            if (entry->inline_referrers[i] == nil) {
                entry->inline_referrers[i] = new_referrer;
                return;
            }
        }

        // 如果inline_referrers的位置已经存满了，则要转型为referrers，做动态数组。
        // Couldn't insert inline. Allocate out of line.
        weak_referrer_t *new_referrers = (weak_referrer_t *)
            calloc(WEAK_INLINE_COUNT, sizeof(weak_referrer_t));
        // This constructed table is invalid, but grow_refs_and_insert
        // will fix it and rehash it.
        // 把 inline_referrers 内部的数据放进 hash 数组
        // 这里看似是直接循环按下标放的，其实后面会进行扩容和哈希化
        for (size_t i = 0; i < WEAK_INLINE_COUNT; i++) {
            new_referrers[i] = entry->inline_referrers[i];
        }
        // 给 referrers 赋值
        entry->referrers = new_referrers;
        // 表示目前弱引用是 4
        entry->num_refs = WEAK_INLINE_COUNT;
        // 标记 weak_entry_t 开始使用哈希数组保存弱引用的指针
        entry->out_of_line_ness = REFERRERS_OUT_OF_LINE;
        // mask 赋值，总容量减 1
        entry->mask = WEAK_INLINE_COUNT-1;
        // 此时哈希冲突偏移为 0
        entry->max_hash_displacement = 0;
    }

    // 对于动态数组的附加处理：
    ASSERT(entry->out_of_line()); // 断言： 此时一定使用的动态数组

    // 如果动态数组中元素个数大于或等于数组位置总空间的3/4，则扩展数组空间为当前长度的一倍
    if (entry->num_refs >= TABLE_SIZE(entry) * 3/4) {
        return grow_refs_and_insert(entry, new_referrer); // 扩容，并插入
    }
    
    // 如果不需要扩容，直接插入到weak_entry中
    // 注意，weak_entry是一个哈希表，key：w_hash_pointer(new_referrer) value: new_referrer
        
    // 细心的人可能注意到了，这里weak_entry_t 的hash算法和 weak_table_t的hash算法是一样的，同时扩容/减容的算法也是一样的
    size_t begin = w_hash_pointer(new_referrer) & (entry->mask); // '& (entry->mask)' 确保了 begin的位置只能大于或等于 数组的长度
    size_t index = begin; // 初始的hash index
    size_t hash_displacement = 0; // 用于记录hash冲突的次数，也就是hash再位移的次数
    while (entry->referrers[index] != nil) {
        hash_displacement++;
        // index + 1, 移到下一个位置，再试一次能否插入。（这里要考虑到entry->mask取值，一定是：0x111, 0x1111, 0x11111, ... ，因为数组每次都是*2增长，即8， 16， 32，对应动态数组空间长度-1的mask，也就是前面的取值。）
        index = (index+1) & entry->mask;
        // index == begin 意味着数组绕了一圈都没有找到合适位置，这时候一定是出了什么问题。
        if (index == begin) bad_weak_table(entry);
    }
    // 记录最大的hash冲突次数, max_hash_displacement意味着: 我们尝试至多max_hash_displacement次，肯定能够找到object对应的hash位置
    if (hash_displacement > entry->max_hash_displacement) {
        entry->max_hash_displacement = hash_displacement;
    }
    // 将ref存入hash数组，同时，更新元素个数num_refs
    weak_referrer_t &ref = entry->referrers[index];
    ref = new_referrer;
    entry->num_refs++;
}

/** 
 * Remove old_referrer from set of referrers, if it's present.
 * Does not remove duplicates, because duplicates should not exist. 
 * 
 * @todo this is slow if old_referrer is not present. Is this ever the case? 
 *
 * @param entry The entry holding the referrers.
 * @param old_referrer The referrer to remove. 
 */
static void remove_referrer(weak_entry_t *entry, objc_object **old_referrer)
{
    // 如果目前使用的是定长为 4 的内部数组
    if (! entry->out_of_line()) {
        // 循环找到 old_referrer 的位置，把它的原位置放置 nil，表示把 old_referrer 从数组中移除了
        for (size_t i = 0; i < WEAK_INLINE_COUNT; i++) {
            if (entry->inline_referrers[i] == old_referrer) {
                entry->inline_referrers[i] = nil;
                return;
            }
        }
        // 如果当前 weak_entry_t 不包含传入的 old_referrer
        // 则明显发生了错误，执行 objc_weak_error 函数
        _objc_inform("Attempted to unregister unknown __weak variable "
                     "at %p. This is probably incorrect use of "
                     "objc_storeWeak() and objc_loadWeak(). "
                     "Break on objc_weak_error to debug.\n", 
                     old_referrer);
        objc_weak_error();
        return;
    }

    // 从 hash 数组中找到 old_referrer 并置为 nil（移除 old_referrer）
    size_t begin = w_hash_pointer(old_referrer) & (entry->mask);
    size_t index = begin;
    size_t hash_displacement = 0;
    while (entry->referrers[index] != old_referrer) {
        index = (index+1) & entry->mask;
        if (index == begin) bad_weak_table(entry);
        hash_displacement++;
        if (hash_displacement > entry->max_hash_displacement) {
            _objc_inform("Attempted to unregister unknown __weak variable "
                         "at %p. This is probably incorrect use of "
                         "objc_storeWeak() and objc_loadWeak(). "
                         "Break on objc_weak_error to debug.\n", 
                         old_referrer);
            objc_weak_error();
            return;
        }
    }
    // 把 old_referrer 所在的位置置为 nil，num_refs 自减
    entry->referrers[index] = nil;
    entry->num_refs--;
}

/** 
 * Add new_entry to the object's table of weak references.
 * 添加 new_entry 到保存对象的 weak 变量地址的哈希表中。
 * Does not check whether the referent is already in the table.
 * 不用检查引用对象是否已在表中。
 */
static void weak_entry_insert(weak_table_t *weak_table, weak_entry_t *new_entry)
{
    // 哈希数组的起始地址
    weak_entry_t *weak_entries = weak_table->weak_entries;
    ASSERT(weak_entries != nil);

    // 调用 hash 函数找到 new_entry 在 weak_table_t 的哈希数组中的位置，可能会发生 hash 冲突，& mask 的原理同上。
    size_t begin = hash_pointer(new_entry->referent) & (weak_table->mask);
    size_t index = begin;
    size_t hash_displacement = 0;
    while (weak_entries[index].referent != nil) {
        // 如果发生哈希冲突，+1 继续向下探测
        index = (index+1) & weak_table->mask;
        // 如果 index 每次加 1 加到值等于 begin 还是没有找到空位置，则触发 bad_weak_table 致命错误。
        if (index == begin) bad_weak_table(weak_entries);
        
        // 记录偏移值，用于更新 max_hash_displacement
        hash_displacement++;
    }

    // new_entry 放入哈希数组
    weak_entries[index] = *new_entry;
    // 更新 num_entries
    weak_table->num_entries++;

    // 此步操作正记录了 weak_table_t 哈希数组发生哈希冲突时的最大偏移值
    if (hash_displacement > weak_table->max_hash_displacement) {
        weak_table->max_hash_displacement = hash_displacement;
    }
}


/*
 该函数对哈希数组长度进行的扩大或缩小，首先根据 new_size 申请相应大小的内存，new_entries 指针指向这块新申请的内存。设置 weak_table 的 mask 为 new_size - 1。此处 mask 的作用是记录 weak_table 总容量的内存边界，此外 mask 还用在哈希函数中保证 index 不会哈希数组越界
 */
//扩大和缩小空间都会调用这个 weak_resize 公共函数。入参是 weak_table_t 和一个指定的长度值。
static void weak_resize(weak_table_t *weak_table, size_t new_size)
{
    // 取得当前哈希数组的总长度。
    // old_size = mask + 1;
    size_t old_size = TABLE_SIZE(weak_table);

    // 取得旧的 weak_entries 哈希数组的起始地址。
    weak_entry_t *old_entries = weak_table->weak_entries;
    
    // 为新的 weak_entries 哈希数组申请指定长度的空间，并把起始地址返回。
    // 内存空间总容量为: new_size * sizeof(weak_entry_t)
    weak_entry_t *new_entries = (weak_entry_t *)
        calloc(new_size, sizeof(weak_entry_t));

    // 更新 mask ，仍是总长度减 1
    weak_table->mask = new_size - 1;
    // 更新 hash 数组起始地址
    weak_table->weak_entries = new_entries;
    // 最大哈希冲突偏移值，默认为 0
    weak_table->max_hash_displacement = 0;
    // 当前哈希数组的占用数量，默认为 0
    weak_table->num_entries = 0;  // restored by weak_entry_insert below
    
    // 下面是把旧哈希数组中的数据重新哈希化放进新空间中，
    // 然后上面的默认为 0 的 weak_table_t 的两个成员变量会在下面的 weak_entry_insert 函数中得到更新。
       
    // 如果有旧的 weak_entry_t 需要放到新空间内
    if (old_entries) {
        weak_entry_t *entry;
        weak_entry_t *end = old_entries + old_size;
        
        // 循环调用 weak_entry_insert 把旧哈希数组中的 weak_entry_t 插入到新的哈希数组中
        for (entry = old_entries; entry < end; entry++) {
            if (entry->referent) {
                weak_entry_insert(weak_table, entry);
            }
        }
        // 最后释放旧的哈希数组的内存空间。
        free(old_entries);
    }
}

// Grow the given zone's table of weak references if it is full.
// 如果给定区域的弱引用表已满，则对其进行扩展。
static void weak_grow_maybe(weak_table_t *weak_table)
{
    // 这里是取得当前哈希数组的总长度。
    // #define TABLE_SIZE(entry) (entry->mask ? entry->mask + 1 : 0)
    // mask + 1 表示当前 weak_table 哈希数组的总长度。
    size_t old_size = TABLE_SIZE(weak_table);

    // Grow if at least 3/4 full.
    // 如果目前哈希数组中存储的 weak_entry_t 的数量超过了总长度的 3/4，则进行扩容。
    if (weak_table->num_entries >= old_size * 3 / 4) {
        // 如果是 weak_table 的哈希数组长度是 0，则初始其哈希数组长度为 64，如果不是，则扩容为之前长度的两倍（old_size*2）。
        weak_resize(weak_table, old_size ? old_size*2 : 64);
    }
}

// Shrink the table if it is mostly empty.
// 即当 weak_table_t 的 weak_entry_t *weak_entries 数组大部分空间为空的情况下，缩小 weak_entries 的长度。
static void weak_compact_maybe(weak_table_t *weak_table)
{
    // 这里是统计当前哈希数组的总长度。
    // #define TABLE_SIZE(entry) (entry->mask ? entry->mask + 1 : 0)
    size_t old_size = TABLE_SIZE(weak_table);

    // Shrink if larger than 1024 buckets and at most 1/16 full.
    // old_size 超过了 1024 并且低于 1/16 的空间占用比率则进行缩小。
    if (old_size >= 1024  && old_size / 16 >= weak_table->num_entries) {
        // 缩小容量为 ols_size 的 1/8
        weak_resize(weak_table, old_size / 8);
        // leaves new table no more than 1/2 full
        // 缩小为 1/8 和上面的空间占用少于 1/16，两个条件合并在一起，保证缩小后的容量占用比少于 1/2。
    }
}


/**
 * Remove entry from the zone's table of weak references.
 */
static void weak_entry_remove(weak_table_t *weak_table, weak_entry_t *entry)
{
    // remove entry
    // 如果 entry 的 referrers 已经被标记为 ness，则释放条目的内容
    if (entry->out_of_line()) free(entry->referrers);
    // 二进制位置零
    bzero(entry, sizeof(*entry));

    weak_table->num_entries--;
    // 压缩表
    weak_compact_maybe(weak_table);
}


/** 
 * Return the weak reference table entry for the given referent. 
 * If there is no entry for referent, return NULL. 
 * Performs a lookup.
 * 通过 &SideTables()[referent] 可从全局的 SideTables 中找到 referent 所处的 SideTable->weak_table_t。
 * 返回值是 weak_entry_t 指针，weak_entry_t 中保存了 referent 的所有弱引用变量的地址。
 *
 * @param weak_table 
 * @param referent The object. Must not be nil.
 * 
 * @return The table of weak referrers to this object. 
 */
static weak_entry_t *
weak_entry_for_referent(weak_table_t *weak_table, objc_object *referent)
{
    ASSERT(referent);

    // weak_table_t 中哈希数组的入口
    weak_entry_t *weak_entries = weak_table->weak_entries;

    if (!weak_entries) return nil;

    // hash_pointer 哈希函数返回值与 mask 做与操作，防止 index 越界，这里的 & mask 操作很巧妙，后面会进行详细讲解。
    size_t begin = hash_pointer(referent) & weak_table->mask;
    size_t index = begin;
    size_t hash_displacement = 0;
    while (weak_table->weak_entries[index].referent != referent) {
        // 如果发生了哈希冲突，+1 继续往下探测（开放寻址法）
        index = (index+1) & weak_table->mask;
        // 如果 index 每次加 1 加到值等于 begin 还没有找到 weak_entry_t，则触发 bad_weak_table 致命错误
        if (index == begin) bad_weak_table(weak_table->weak_entries);
        
        // 记录探测偏移了多远
        hash_displacement++;
        // 如果探测偏移超过了 weak_table_t 的 max_hash_displacement，
        // 说明在 weak_table 中没有 referent 的 weak_entry_t，则直接返回 nil。
        if (hash_displacement > weak_table->max_hash_displacement) {
            return nil;
        }
    }
    
    // 到这里遍找到了 weak_entry_t，然后取它的地址并返回。
    return &weak_table->weak_entries[index];
}

/** 
 * Unregister an already-registered weak reference.
 * This is used when referrer's storage is about to go away, but referent
 * isn't dead yet. (Otherwise, zeroing referrer later would be a
 * bad memory access.)
 * Does nothing if referent/referrer is not a currently active weak reference.
 * Does not zero referrer.
 * 从弱引用表里移除一对（object, weak pointer）。（从对象的 weak_entry_t 哈希表中移除一个 weak 变量的地址）
 * 
 * FIXME currently requires old referent value to be passed in (lame)
 * FIXME unregistration should be automatic if referrer is collected
 * 
 * @param weak_table The global weak table.
 * @param referent The object.
 * @param referrer The weak reference.
 */
void
weak_unregister_no_lock(weak_table_t *weak_table, id referent_id, 
                        id *referrer_id)
{
    // id 转化为 objc_object * 对象的指针
    objc_object *referent = (objc_object *)referent_id;
    // referrer_id 是指向 weak 变量的地址，所以这里是 **
    objc_object **referrer = (objc_object **)referrer_id;

    weak_entry_t *entry;

    if (!referent) return;

    // 从 weak_table 中找到 referent 的 weak_entry_t
    if ((entry = weak_entry_for_referent(weak_table, referent))) {
        // 找到了这个 entry，就删除 weak_entry_t 的哈希数组（或定长为 4 的内部数组）中的 referrer
        remove_referrer(entry, referrer);
        bool empty = true;
        // 注销 referrer 以后判断是否需要删除对应的 weak_entry_t，
        // 如果 weak_entry_t 目前使用哈希数组，且 num_refs 不为 0，
        // 表示此时哈希数组还不为空，不需要删除
        if (entry->out_of_line()  &&  entry->num_refs != 0) {
            empty = false;
        }
        else {
            // 循环判断 weak_entry_t 内部定长为 4 的数组内是否还有 weak_referrer_t
            for (size_t i = 0; i < WEAK_INLINE_COUNT; i++) {
                if (entry->inline_referrers[i]) {
                    empty = false; 
                    break;
                }
            }
        }
        // 如果 entry 中的弱引用的地址都已经清空了，则连带也删除这个 entry，类似数组已经空了，则把数组也删了
        if (empty) {
            weak_entry_remove(weak_table, entry);
        }
    }

    // Do not set *referrer = nil. objc_storeWeak() requires that the 
    // value not change.
}

/** 
 * Registers a new (object, weak pointer) pair. Creates a new weak
 * object entry if it does not exist.
 * 添加一对（object, weak pointer）到弱引用表里。（即当一个对象存在第一个指向它的 weak 变量时，此时会把对象注册进 weak_table_t 的哈希表中，同时也会把这第一个 weak 变量的地址保存进对象的 weak_entry_t 哈希表中，如果这个 weak 变量不是第一个的话，表明这个对象此时已经存在于 weak_table_t 哈希表中了，此时只需要把这个指向它的 weak 变量的地址保存进该对象的 weak_entry_t 哈希表中）
 * 
 * @param weak_table The global weak table.
 * @param referent The object pointed to by the weak reference.
 * @param referrer The weak pointer address.
 */
id 
weak_register_no_lock(weak_table_t *weak_table, id referent_id, 
                      id *referrer_id, WeakRegisterDeallocatingOptions deallocatingOptions)
{
    // 对象指针
    objc_object *referent = (objc_object *)referent_id;
    // weak 变量的地址
    objc_object **referrer = (objc_object **)referrer_id;

    // 如果对象不存在或者是一个 Tagged Pointer 的话，直接返回对象。
    if (referent->isTaggedPointerOrNil()) return referent_id;

    // ensure that the referenced object is viable
    if (deallocatingOptions == ReturnNilIfDeallocating ||
        deallocatingOptions == CrashIfDeallocating) {
        // 判断对象是否正在进行释放操作
        bool deallocating;
        if (!referent->ISA()->hasCustomRR()) {
            deallocating = referent->rootIsDeallocating();
        }
        else {
            // Use lookUpImpOrForward so we can avoid the assert in
            // class_getInstanceMethod, since we intentionally make this
            // callout with the lock held.
            // 判断入参对象是否能进行 weak 引用 allowsWeakReference
            auto allowsWeakReference = (BOOL(*)(objc_object *, SEL))
            lookUpImpOrForwardTryCache((id)referent, @selector(allowsWeakReference),
                                       referent->getIsa());
            if ((IMP)allowsWeakReference == _objc_msgForward) {
                return nil;
            }
            // 通过函数指针执行函数
            deallocating =
            ! (*allowsWeakReference)(referent, @selector(allowsWeakReference));
        }

        // 如果对象正在进行释放或者该对象不能进行 weak 引用，且 crashIfDeallocating 为 true，则抛出 crash
        if (deallocating) {
            if (deallocatingOptions == CrashIfDeallocating) {
                _objc_fatal("Cannot form weak reference to instance (%p) of "
                            "class %s. It is possible that this object was "
                            "over-released, or is in the process of deallocation.",
                            (void*)referent, object_getClassName((id)referent));
            } else {
                return nil;
            }
        }
    }

    // now remember it and where it is being stored
    weak_entry_t *entry;
    // 在 weak_table 中找 referent 对应的 weak_entry_t
    if ((entry = weak_entry_for_referent(weak_table, referent))) {
        // 如果找到了，调用 append_referrer，把 __weak 变量的地址放进哈希数组
        append_referrer(entry, referrer);
    } 
    else {
        // 如果没有找到 entry，创建一个新的 entry
        weak_entry_t new_entry(referent, referrer);
        // 判断 weak_table_t 是否需要扩容
        weak_grow_maybe(weak_table);
        // 把 weak_entry_t 插入到 weak_table_t 的哈希数组中
        weak_entry_insert(weak_table, &new_entry);
    }

    // Do not set *referrer. objc_storeWeak() requires that the 
    // value not change.

    return referent_id;
}


#if DEBUG
// 如果一个对象在弱引用表的某处，即该对象被保存在弱引用表里（该对象存在弱引用），则返回 true。
bool
weak_is_registered_no_lock(weak_table_t *weak_table, id referent_id) 
{
    // 调用 weak_entry_for_referent 判断对象是否存在对应的 entry
    return weak_entry_for_referent(weak_table, (objc_object *)referent_id);
}
#endif


/** 
 * Called by dealloc; nils out all weak pointers that point to the 
 * provided object so that they can no longer be used.
 * 当对象销毁的时候该函数被调用。设置所有剩余的 __weak 变量指向 nil，此处正对应了我们日常挂在嘴上的：__weak 变量在它指向的对象被销毁后它便会被置为 nil 的机制。
 * 
 * @param weak_table 
 * @param referent The object being deallocated. 
 */
void 
weak_clear_no_lock(weak_table_t *weak_table, id referent_id) 
{
    // referent 待销毁的对象
    objc_object *referent = (objc_object *)referent_id;
    
    // 从 weak_table_t 的哈希数组中找到 referent 对应的 weak_entry_t
    weak_entry_t *entry = weak_entry_for_referent(weak_table, referent);
    // 如果 entry 不存在，则返回
    if (entry == nil) {
        /// XXX shouldn't happen, but does with mismatched CF/objc
        //printf("XXX no entry for clear deallocating %p\n", referent);
        return;
    }

    // zero out references
    // 用于记录 weak_referrer_t
    // typedef DisguisedPtr<objc_object *> weak_referrer_t;
    weak_referrer_t *referrers;
    size_t count;
    
    // 如果目前 weak_entry_t 使用哈希数组
    if (entry->out_of_line()) {
        referrers = entry->referrers; // 记录哈希数组入口 哈希数组起始地址
        count = TABLE_SIZE(entry); // 记录长度 长度是 mask + 1
    } 
    else {
        referrers = entry->inline_referrers; // 记录 inline_referrers 的入口
        count = WEAK_INLINE_COUNT; // count 是 4
    }
    
    // 循环把 inline_referrers 数组或者 hash 数组中的 weak 变量指向置为 nil
    for (size_t i = 0; i < count; ++i) {
        objc_object **referrer = referrers[i]; // weak 变量的指针的指针
        if (referrer) {
            if (*referrer == referent) { // 如果 weak 变量指向 referent，则把其指向置为 nil
                *referrer = nil;
            }
            else if (*referrer) {
                _objc_inform("__weak variable at %p holds %p instead of %p. "
                             "This is probably incorrect use of "
                             "objc_storeWeak() and objc_loadWeak(). "
                             "Break on objc_weak_error to debug.\n", 
                             referrer, (void*)*referrer, (void*)referent);
                objc_weak_error();
            }
        }
    }
    // 最后把 entry 从 weak_table_t 中移除
    weak_entry_remove(weak_table, entry);
}

