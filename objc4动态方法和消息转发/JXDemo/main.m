//
//  main.m
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import "JXFather.h"
#import "JXSon.h"
#import "NSObject+JX.h"

extern void instrumentObjcMessageSends(BOOL flag);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        JXSon *son = [[JXSon alloc] init];
//        [son doInstanceBySon];
//        [son doInstanceByFather];
//        [son doInstanceByMeta];
////        [son performSelector:@selector(doInstanceByNobody)];
////        [son doInstanceNoImplementation];
//
//        [JXSon doClassBySon];
//        [JXSon doClassByFather];
//        [JXSon doClassByMeta];
////        [JXSon performSelector:@selector(doClassByNobody)];
////        [JXSon doClassNoImplementation];
//        NSLog(@"Hello, World!");
        
        JXSon *son = [[JXSon alloc] init];
        
        instrumentObjcMessageSends(true);
        [son doInstanceNoImplementation];
        instrumentObjcMessageSends(false);
    }
    return 0;
}
