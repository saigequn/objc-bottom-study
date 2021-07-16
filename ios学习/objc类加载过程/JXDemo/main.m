//
//  main.m
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "JXFather.h"

#ifdef DEBUG
#define JXNSLog(format, ...) printf("%s\n", [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define JXNSLog(format, ...);
#endif

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        JXFather *person = [[JXFather alloc] init];
        [person jx_instanceMethod];

        JXNSLog(@"%p",person);

    }
    return 0;
}
