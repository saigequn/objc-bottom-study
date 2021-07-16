//
//  main.m
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "JXFather.h"
#import "NSObject+Cate.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        [JXFather jx_instanceMethod];
        [NSObject printClassChain:[JXFather class]];
        NSLog(@"end");
        
    }
    return 0;
}


/*
 2021-07-15 17:04:08.538783+0800 JXDemo[31437:709179] jx_instanceMethods
 2021-07-15 17:04:08.539606+0800 JXDemo[31437:709179] Class:JXFather Address:0x1000083a8    //类
 2021-07-15 17:04:18.908129+0800 JXDemo[31437:709179] Class:JXFather Address:0x100008380    //元类
 2021-07-15 17:04:26.460458+0800 JXDemo[31437:709179] Class:NSObject Address:0x1003570f0    //根元类
 2021-07-15 17:04:31.316370+0800 JXDemo[31437:709179] Class:NSObject Address:0x100357140    //根元类的SuperClass，也就是NSObject
 (lldb) po [0x1000083a8 printMethods]
 <__NSArrayM 0x1006ba1a0>(
 name:cj_instanceMethod1 type encode:v16@0:8 IMP:0x1000038f0,
 name:cj_instanceMethod2 type encode:v16@0:8 IMP:0x100003980,
 name:cj_instanceMethod3 type encode:v16@0:8 IMP:0x100003a10,
 name:cj_name type encode:@16@0:8 IMP:0x100003b30,
 name:setCj_name: type encode:v24@0:8@16 IMP:0x100003b60,
 name:cj_age type encode:i16@0:8 IMP:0x100003ba0,
 name:setCj_age: type encode:v20@0:8i16 IMP:0x100003bc0,
 name:.cxx_destruct type encode:v16@0:8 IMP:0x100003be0
 )

 (lldb) po [0x100008380 printMethods]
 <__NSArrayM 0x101a04a90>(
 name:cj_classMethod type encode:v16@0:8 IMP:0x100003aa0
 )
 
 实例方法cj_instanceMethod存储在元类的方法列表中,同时我们也可以发现@property也是相当于存储了一个set 以及一个get 的实例方法
 类方法cj_classMethod,存储在类元类方法列表中
 未实现的方法没有被存储
 

 根元类中只打印了类方法,此时根元类的class 为NSObject
 (lldb) po [0x1003570f0 printMethods]
 <__NSArrayM 0x101a04450>(
 name:printClassChain: type encode:v24@0:8#16 IMP:0x100003860,
 name:printMethods type encode:@16@0:8 IMP:0x1000036b0,
 name:fromPBCodable: type encode:@24@0:8@16 IMP:0x7fff4989f620,
 ......
 )

 根元类superClass的方法列表打印如下
 在这里我们发现了,NSObject 的实例方法jx_instanceMethod,
 (lldb) po [0x100357140 printMethods]
 <__NSArrayM 0x10074a8f0>(
 name:jx_instanceMethod type encode:v16@0:8 IMP:0x100003680,
 name:__im_onMainThread type encode:@16@0:8 IMP:0x7fff566c2865,
 ......
 name:release type encode:Vv16@0:8 IMP:0x10033d800,
 name:autorelease type encode:@16@0:8 IMP:0x10033d850,
 name:retainCount type encode:Q16@0:8 IMP:0x10033d8a0,
 name:init type encode:@16@0:8 IMP:0x10033d940,
 name:dealloc type encode:v16@0:8 IMP:0x10033d980,
 name:finalize type encode:v16@0:8 IMP:0x10033d9b0,
 name:zone type encode:^{_NSZone=}16@0:8 IMP:0x10033d9e0,
 name:copy type encode:@16@0:8 IMP:0x10033da50,
 name:mutableCopy type encode:@16@0:8 IMP:0x10033dac0
 )
 
 当我们在元类中查找方法直到根云类中也没有找到方法的时候会去NSObject 的类方法中查找一下,这也是为什么,继承NSObject 的子类可以执行通过类方法执行实例方法的原因
 */
