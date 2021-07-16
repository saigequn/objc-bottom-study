//
//  main.m
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "Person.h"
#import <mach-o/dyld.h>
#include <stdio.h>

void listImages() {
    uint32_t i;
    uint32_t ic = _dyld_image_count();
    printf("Got %d images\n", ic);
    for (i=0; i<ic; ++i) {
        printf("%d: %p\t%s\t(slide: %p)\n", i, _dyld_get_image_header(i), _dyld_get_image_name(i), _dyld_get_image_vmaddr_slide(i));
    }
}

void run() {
    printf("Hello World\n");
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        Person *person = [Person alloc];
        
//        listImages();
        
//        // 我们通过一个 void (*fptr)() 类型的函数指针，将 run 函数获取出，并运行函数
//        void (*dy_run)() = run;
//        // 实际上其中的工作是抓取 run 函数的地址并存储在指针变量中。我们通过指针运行对应的地址部分，其效果为执行了 run 函数。
//        (*dy_run)();
        
        NSLog(@"end");

    }
    return 0;
}


