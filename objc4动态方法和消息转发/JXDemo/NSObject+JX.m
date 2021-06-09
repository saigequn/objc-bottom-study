//
//  NSObject+JX.m
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import "NSObject+JX.h"
#import <objc/message.h>

@implementation NSObject (JX)

- (void)doInstanceByMeta {
    NSLog(@"%s",__func__);
}

+ (void)doClassByMeta {
    NSLog(@"%s",__func__);
}

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//
//    if ([NSStringFromSelector(sel) isEqualToString:@"doClassNoImplementation"]) {
//        NSLog(@"——————————找不到%@-%@方法，崩溃了——————————", self, NSStringFromSelector(sel));
//        IMP instanceIMP = class_getMethodImplementation(objc_getMetaClass("NSObject"), @selector(doInstanceNoInstead));
//        Method instanceMethod = class_getInstanceMethod(objc_getMetaClass("NSObject"), @selector(doInstanceNoInstead));
//        const char *instance = method_getTypeEncoding(instanceMethod);
//        return class_addMethod(objc_getMetaClass("NSObject"), sel, instanceIMP, instance);
//    }
//
//    return NO;
//}
//- (void)doInstanceNoInstead {
//    NSLog(@"————解决崩溃————");
//}

@end
