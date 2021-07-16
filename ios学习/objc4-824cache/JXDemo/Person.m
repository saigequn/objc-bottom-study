//
//  Person.m
//  JXDemo
//
//  Created by admin on 2021/7/15.
//

#import "Person.h"

@implementation Person
- (void)sayHello {
    NSLog(@"%s", __func__);
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    for (int i = 0; i < 1000; i++) {
//        dispatch_async(queue, ^{
////            self.name = [NSString stringWithFormat:@"abcdefghij"];
////            self.name = [NSString stringWithFormat:@"abcdefghi"];
//
//            NSString *str = [NSString stringWithFormat:@"%d", i];
//            NSLog(@"%d, %s, %p", i, object_getClassName(str), str);
//            self.name = str;
//        });
//    }
}

- (void)sayHello2 {
    NSLog(@"%s", __func__);
}
- (void)sayHello3 {
    NSLog(@"%s", __func__);
}
- (void)sayHello4 {
    NSLog(@"%s", __func__);
}

+ (void)sayHelloword {
    NSLog(@"%s", __func__);
}

@end
