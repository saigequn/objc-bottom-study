//
//  main.m
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        id obj = [NSObject new];
//        id obj2 = [NSObject new];
//        printf("Start tag\n");
//        {
//            __weak id weakPtr = obj; // 调用objc_initWeak进行weak变量初始化
//            weakPtr = obj2; //修改 weak变量指向
////            __strong id strongPtr = obj; // 调用objc_initWeak进行strong变量初始化
////            strongPtr = obj2;
//        }
//        printf("End tag\n"); // ⬅️ 断点打在这里
        
        
//        id obj = [NSObject new];
//        __weak id weakPtr = obj;
//        printf("Start tag");
//        {
//            NSLog(@"%@", weakPtr);
//        }
//        printf("End tag"); // ⬅️ 在这里打断点
        
        
//        // objc_loadWeakRetained 和 objc_release 一一对应。
//        id obj = [NSObject new];
//        printf("Start tag");
//        {
//            __weak id weakPtr = obj;
//            NSLog(@"%@", weakPtr);
//            NSLog(@"%@", weakPtr);
//            NSLog(@"%@", weakPtr);
//        }
//        printf("End tag"); // ⬅️ 这里打断点
        
        // objc_copyWeak 把一个 weak 变量赋值给另一个 weak 变量时会调用该函数
        id obj = [NSObject new];
        printf("Start tag");
        {
            __weak id weakPtr = obj;
            __weak id weakPtr2 = weakPtr;
        }
        printf("End tag"); // ⬅️ 这里打断点

    }
    return 0;
}

//打开汇编模式：debug->debug workflow->alway show disassembly。
//看到与 weak 变量相关函数是: objc_initWeak、objc_storeWeak、objc_destroyWeak，
//看到与 strong 变量相关函数是:_objc_retain、objc_storeStrong


/*
 objc_loadWeakRetained函数里location处打上断点
 
 (lldb) p location
 (id *) $0 = 0x00007ffeefbff4c0
 (lldb) p *location
 (NSObject *) $1 = 0x000000010073ca20
 (lldb) register read
 General Purpose Registers:
        rax = 0x0000000000000009
        rbx = 0x0000000000000000
        rcx = 0x3fabbff853050037
        rdx = 0x0000000000000000
        rdi = 0x00007ffeefbff4c0   // rdi 放的 location 参数
        rsi = 0x0000000000000000
        rbp = 0x00007ffeefbff480
        rsp = 0x00007ffeefbff340
         r8 = 0x00000000000130a8
         r9 = 0x00007fff93ccdbf8  __sFX + 248
        r10 = 0x00007ffeefbff670
        r11 = 0x0000000100336ec0  libobjc.A.dylib`objc_loadWeakRetained at NSObject.mm:566
        r12 = 0x0000000000000000
        r13 = 0x0000000000000000
        r14 = 0x0000000000000000
        r15 = 0x0000000000000000
        rip = 0x0000000100336ed2  libobjc.A.dylib`objc_loadWeakRetained + 18 at NSObject.mm:575:12
     rflags = 0x0000000000000202
         cs = 0x000000000000002b
         fs = 0x0000000000000000
         gs = 0x0000000000000000

 (lldb) memory read 0x00007ffeefbff4c0
 0x7ffeefbff4c0: 20 ca 73 00 01 00 00 00 20 ca 73 00 01 00 00 00   .s..... .s.....
 0x7ffeefbff4d0: 08 f5 bf ef fe 7f 00 00 01 00 00 00 00 00 00 00  ................
 (lldb) 0x10073ca20
 
 (lldb) p weakPtr
 (NSObject *) $2 = 0x000000010073ca20
 */
