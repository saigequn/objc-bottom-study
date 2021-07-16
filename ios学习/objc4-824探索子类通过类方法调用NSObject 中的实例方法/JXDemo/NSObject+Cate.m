//
//  NSObject+Cate.m
//  JXDemo
//
//  Created by admin on 2021/7/15.
//

#import "NSObject+Cate.h"
#import <objc/runtime.h>

@implementation NSObject (Cate)

- (void)jx_instanceMethod {
    NSLog(@"jx_instanceMethods");
}

+ (NSArray *)printMethods {
    NSMutableArray *array = [NSMutableArray array];
    unsigned int count = 0;
    Method * methodList = class_copyMethodList([self class], &count);
    for (int i=0; i < count; i++) {
        [array addObject:[NSString stringWithFormat:@"name:%@ type encode:%@ IMP:%p", NSStringFromSelector(method_getName(methodList[i])), [NSString stringWithUTF8String:method_getTypeEncoding(methodList[i])], method_getImplementation(methodList[i])]];
    }
    free(methodList);
    return array;
}

+ (void)printClassChain:(Class)aClass {
    NSLog(@"Class:%@ Address:%p", aClass, aClass);
    Class getClass = object_getClass(aClass);
    if (getClass != aClass) {
        [self printClassChain:getClass];
    } else {
        aClass = class_getSuperclass(aClass);
        NSLog(@"Class:%@ Address:%p", aClass, aClass);
    }
}

@end
