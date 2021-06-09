//
//  JXSon.m
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import "JXSon.h"
#import <objc/message.h>
#import "JXTeacher.h"

@implementation JXSon

- (void)doInstanceBySon {
    NSLog(@"%s",__func__);
}

+ (void)doClassBySon {
    NSLog(@"%s",__func__);
}

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(doInstanceNoImplementation)) {
//        NSLog(@"———找不到%@-%@方法，崩溃了——————", self, NSStringFromSelector(sel));
//        IMP insteadIMP = class_getMethodImplementation(self, @selector(doInstead));
//        Method insteadMethod = class_getInstanceMethod(self, @selector(doInstead));
//        const char * instead = method_getTypeEncoding(insteadMethod);
//        return class_addMethod(self, sel, insteadIMP, instead);
//    }
//    return NO;
//}
//- (void)doInstead {
//    NSLog(@"————解决崩溃————");
//}

//+ (BOOL)resolveClassMethod:(SEL)sel {
//    if (sel == @selector(doClassNoImplementation)) {
//        NSLog(@"———找不到%@-%@方法，崩溃了——————", self, NSStringFromSelector(sel));
//        IMP classIMP = class_getMethodImplementation(objc_getMetaClass("JXSon"), @selector(doClassNoInstead));
//        Method classMethod = class_getInstanceMethod(objc_getMetaClass("JXSon"), @selector(doClassNoInstead));
//        const char * cls = method_getTypeEncoding(classMethod);
//        return class_addMethod(objc_getMetaClass("JXSon"), sel, classIMP, cls);
//    }
//    return NO;
//}
//+ (void)doClassNoInstead {
//    NSLog(@"—————解决崩溃———————");
//}

//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    NSLog(@"%s -- %@",__func__,NSStringFromSelector(aSelector));
//    if (aSelector == @selector(doInstanceNoImplementation)) {
//        return [JXTeacher alloc];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%s -- %@",__func__,NSStringFromSelector(aSelector));
    if (aSelector == @selector(doInstanceNoImplementation)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%s ",__func__);
    SEL aSelector = [anInvocation selector];
    
    if ([[JXTeacher alloc] respondsToSelector:aSelector]) {
        [anInvocation invokeWithTarget:[JXTeacher alloc]];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end
