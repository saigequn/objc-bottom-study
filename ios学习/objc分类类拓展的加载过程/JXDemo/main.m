//
//  main.m
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "JXFather.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        JXFather *person = [[JXFather alloc] init];
        [person jx_instanceMethod];
        NSLog(@"%p", person);

//        FXPerson *p = [FXPerson alloc];
//        Class cls = object_getClass(p);
        
    }
    return 0;
}
