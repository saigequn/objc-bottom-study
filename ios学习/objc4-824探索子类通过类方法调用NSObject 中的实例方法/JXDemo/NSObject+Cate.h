//
//  NSObject+Cate.h
//  JXDemo
//
//  Created by admin on 2021/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Cate)

- (void)jx_instanceMethod;
+ (NSArray *)printMethods;
+ (void)printClassChain:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
