//
//  main.m
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface FXPerson : NSObject {
    NSString *nickname;
}
@property (nonatomic, copy) NSString *nationality;
+ (void)walk;
- (void)fly;
@end

@implementation FXPerson
+ (void)walk {}
- (void)fly {}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        FXPerson *p = [FXPerson alloc];
        Class cls = object_getClass(p);
        
    }
    return 0;
}
