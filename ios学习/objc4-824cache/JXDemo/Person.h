//
//  Person.h
//  JXDemo
//
//  Created by admin on 2021/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject 
@property (nonatomic, copy) NSString *jxName;
@property (nonatomic, assign) NSInteger age;
- (void)sayHello;
- (void)sayHello2;
- (void)sayHello3;
- (void)sayHello4;

+ (void)sayHelloword;

@end

NS_ASSUME_NONNULL_END
