//
//  main.m
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "Person.h"

//typedef uint32_t mask_t;  // x86_64 & arm64 asm are less efficient with 16-bits
//
//struct cj_bucket_t {
//    SEL _sel;
//    IMP _imp;
//};
//
//struct cj_cache_t {
//    struct cj_bucket_t * _buckets;
//    mask_t _mask;
//    uint16_t _flags;
//    uint16_t _occupied;
//};
//
//struct cj_class_data_bits_t {
//    uintptr_t bits;
//};
//
//struct cj_objc_class {
//    Class ISA;
//    Class superclass;
//    struct cj_cache_t cache;             // formerly cache pointer and vtable
//    struct cj_class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
//};

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Person *person = [Person alloc];
        Class pClass = [Person class];
//        Class pClass = object_getClass(person);
        [person sayHello];
        [person sayHello2];
        [person sayHello3];
        [person sayHello4];
        
//        struct cj_objc_class *jx_pClass = (__bridge struct cj_objc_class *)(pClass);
//        NSLog(@"%hu - %u", jx_pClass->cache._occupied, jx_pClass->cache._mask);
//
//        for (mask_t i=0; i<jx_pClass->cache._mask; i++) {
//            struct cj_bucket_t bucket = jx_pClass->cache._buckets[i];
//            NSLog(@"%@ - %p", NSStringFromSelector(bucket._sel), bucket._imp);
//        }
        
        NSLog(@"end!");
    }
    return 0;
}



/*
 (lldb) p/x person
 (Person *) $0 = 0x0000000101004be0
 (lldb) p/x 0x0000000101004be0 + 0x10
 (long) $1 = 0x0000000101004bf0
 (lldb) p/x (cache_t *)$1
 (cache_t *) $2 = 0x0000000101004bf0
 (lldb) p *$2
 (cache_t) $3 = {
   _bucketsAndMaybeMask = {
     std::__1::atomic<unsigned long> = {
       Value = 0
     }
   }
    = {
      = {
       _maybeMask = {
         std::__1::atomic<unsigned int> = {
           Value = 0
         }
       }
       _flags = 0
       _occupied = 0
     }
     _originalPreoptCache = {
       std::__1::atomic<preopt_cache_t *> = {
         Value = 0x0000000000000000
       }
     }
   }
 }
 (lldb) p/x $3.buckets()
 (bucket_t *) $4 = 0x0000000000000000
 */




/* 属性探究
 (lldb) p/x JXPerson.class
 (Class) $0 = 0x0000000100008480 JXPerson
 (lldb) p/x 0x0000000100008480 + 0x20
 (long) $1 = 0x00000001000084a0
 (lldb) p (class_data_bits_t *)0x00000001000084a0
 (class_data_bits_t *) $2 = 0x00000001000084a0
 (lldb) p $2->data()
 (class_rw_t *) $3 = 0x000000010191ad50
 (lldb) p $3->properties()
 (const property_array_t) $4 = {
   list_array_tt<property_t, property_list_t, RawPtr> = {
      = {
       list = {
         ptr = 0x00000001000081b8
       }
       arrayAndFlag = 4295000504
     }
   }
 }
 (lldb) p $4.list
 (const RawPtr<property_list_t>) $5 = {
   ptr = 0x00000001000081b8
 }
 (lldb) p $5.ptr
 (property_list_t *const) $6 = 0x00000001000081b8
 (lldb) p *$6
 (property_list_t) $7 = {
   entsize_list_tt<property_t, property_list_t, 0, PointerModifierNop> = (entsizeAndFlags = 16, count = 2)
 }
 (lldb) p $7.get(0)
 (property_t) $8 = (name = "jxName", attributes = "T@\"NSString\",C,N,V_jxName")
 (lldb) p $7.get(1)
 (property_t) $9 = (name = "age", attributes = "Tq,N,V_age")
 (lldb) p $3->methods()
 (const method_array_t) $10 = {
   list_array_tt<method_t, method_list_t, method_list_t_authed_ptr> = {
      = {
       list = {
         ptr = 0x00000001000080b8
       }
       arrayAndFlag = 4295000248
     }
   }
 }
 (lldb) p $10.list
 (const method_list_t_authed_ptr<method_list_t>) $11 = {
   ptr = 0x00000001000080b8
 }
 (lldb) p $11.ptr
 (method_list_t *const) $12 = 0x00000001000080b8
 (lldb) p *$12
 (method_list_t) $13 = {
   entsize_list_tt<method_t, method_list_t, 4294901763, method_t::pointer_modifier> = (entsizeAndFlags = 27, count = 6)
 }
 (lldb) p $13.get(0)
 (method_t) $14 = {}
 (lldb) p $13.get(0).big()
 (method_t::big) $15 = {
   name = "sayHello"
   types = 0x0000000100003f61 "v16@0:8"
   imp = 0x00000001000037a0 (JXDemo`-[JXPerson sayHello] at main.m:23)
 }
 (lldb) p $13.get(1).big()
 (method_t::big) $16 = {
   name = "jxName"
   types = 0x0000000100003f69 "@16@0:8"
   imp = 0x0000000100003800 (JXDemo`-[JXPerson jxName] at main.m:16)
 }
 (lldb) p $13.get(2).big()
 (method_t::big) $17 = {
   name = "setJxName:"
   types = 0x0000000100003f71 "v24@0:8@16"
   imp = 0x0000000100003830 (JXDemo`-[JXPerson setJxName:] at main.m:16)
 }
 (lldb) p $13.get(3).big()
 (method_t::big) $18 = {
   name = ".cxx_destruct"
   types = 0x0000000100003f61 "v16@0:8"
   imp = 0x00000001000038b0 (JXDemo`-[JXPerson .cxx_destruct] at main.m:22)
 }
 (lldb) p $13.get(4).big()
 (method_t::big) $19 = {
   name = "age"
   types = 0x0000000100003f7c "q16@0:8"
   imp = 0x0000000100003870 (JXDemo`-[JXPerson age] at main.m:17)
 }
 (lldb) p $13.get(5).big()
 (method_t::big) $20 = {
   name = "setAge:"
   types = 0x0000000100003f84 "v24@0:8q16"
   imp = 0x0000000100003890 (JXDemo`-[JXPerson setAge:] at main.m:17)
 }
 */


/* 方法探究
 (lldb) p/x JXPerson.class
 (Class) $0 = 0x0000000100008480 JXPerson
 (lldb) p/x 0x0000000100008480 + 0x20
 (long) $1 = 0x00000001000084a0
 (lldb) p (class_data_bits_t *)0x00000001000084a0
 (class_data_bits_t *) $2 = 0x00000001000084a0
 (lldb) p $2->data()
 (class_rw_t *) $3 = 0x0000000100762650
 (lldb) p $3->ro()
 (const class_ro_t *) $4 = 0x00000001000081e0
 (lldb) p *$4
 (const class_ro_t) $5 = {
   flags = 388
   instanceStart = 8
   instanceSize = 32
   reserved = 0
    = {
     ivarLayout = 0x0000000100003e62 "\x02"
     nonMetaclass = 0x0000000100003e62
   }
   name = {
     std::__1::atomic<const char *> = "JXPerson" {
       Value = 0x0000000100003e59 "JXPerson"
     }
   }
   baseMethodList = 0x00000001000080b8
   baseProtocols = 0x0000000000000000
   ivars = 0x0000000100008150
   weakIvarLayout = 0x0000000000000000
   baseProperties = 0x00000001000081b8
   _swiftMetadataInitializer_NEVER_USE = {}
 }
 (lldb) p $5.ivars
 (const ivar_list_t *const) $6 = 0x0000000100008150
 (lldb) p *$6
 (const ivar_list_t) $7 = {
   entsize_list_tt<ivar_t, ivar_list_t, 0, PointerModifierNop> = (entsizeAndFlags = 32, count = 3)
 }
 (lldb) p $7.get(0)
 (ivar_t) $8 = {
   offset = 0x0000000100008430
   name = 0x0000000100003eb1 "height"
   type = 0x0000000100003f8f "@\"NSString\""
   alignment_raw = 3
   size = 8
 }
 (lldb) p $7.get(1)
 (ivar_t) $9 = {
   offset = 0x0000000100008438
   name = 0x0000000100003eb8 "_jxName"
   type = 0x0000000100003f8f "@\"NSString\""
   alignment_raw = 3
   size = 8
 }
 (lldb) p $7.get(2)
 (ivar_t) $10 = {
   offset = 0x0000000100008440
   name = 0x0000000100003ec0 "_age"
   type = 0x0000000100003f9b "q"
   alignment_raw = 3
   size = 8
 }
 */


/* 类方法研究
 (lldb) p/x object_getClass(JXPerson.class)
 (Class) $0 = 0x0000000100008458
 (lldb) p/x 0x0000000100008458 + 0x20
 (long) $1 = 0x0000000100008478
 (lldb) p (class_data_bits_t*)0x0000000100008478
 (class_data_bits_t *) $2 = 0x0000000100008478
 (lldb) p $2->data()
 (class_rw_t *) $3 = 0x0000000100760380
 (lldb) p $3->methods()
 (const method_array_t) $4 = {
   list_array_tt<method_t, method_list_t, method_list_t_authed_ptr> = {
      = {
       list = {
         ptr = 0x0000000100008050
       }
       arrayAndFlag = 4295000144
     }
   }
 }
 (lldb) p $4.list
 (const method_list_t_authed_ptr<method_list_t>) $5 = {
   ptr = 0x0000000100008050
 }
 (lldb) p $5.ptr
 (method_list_t *const) $6 = 0x0000000100008050
 (lldb) p *$6
 (method_list_t) $7 = {
   entsize_list_tt<method_t, method_list_t, 4294901763, method_t::pointer_modifier> = (entsizeAndFlags = 27, count = 1)
 }
 (lldb) p $7.get(0).big()
 (method_t::big) $8 = {
   name = "sayHelloword"
   types = 0x0000000100003f61 "v16@0:8"
   imp = 0x00000001000037d0 (JXDemo`+[JXPerson sayHelloword] at main.m:26)
 }
 */
