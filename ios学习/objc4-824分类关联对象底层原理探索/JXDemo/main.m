//
//  main.m
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface JXFather : NSObject
@end

@implementation JXFather
@end


@interface JXFather (Cate)
@property (nonatomic, copy) NSString *cj_name;
@property (nonatomic, assign) int cj_age;
- (void)cj_instanceMethod1;
- (void)cj_instanceMethod2;
- (void)cj_instanceMethod3;
+ (void)cj_classMethod;
@end


@implementation JXFather (Cate)
- (void)cj_instanceMethod1{
    NSLog(@"%s",__func__);
}
- (void)cj_instanceMethod2{
    NSLog(@"%s",__func__);
}
- (void)cj_instanceMethod3{
    NSLog(@"%s",__func__);
}
+ (void)cj_classMethod{
    NSLog(@"%s",__func__);
}

- (void)setCj_name:(NSString *)cj_name {
    objc_setAssociatedObject(self, @"cj_name", cj_name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)cj_name {
    return objc_getAssociatedObject(self, @"cj_name");
}

@end



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        JXFather *person = [[JXFather alloc] init];
        person.cj_name = @"jx";
        [person cj_instanceMethod1];
        NSLog(@"%@", person.cj_name);
        NSLog(@"Hello, World!");
    }
    return 0;
}
