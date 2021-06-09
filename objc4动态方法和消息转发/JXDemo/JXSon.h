//
//  JXSon.h
//  JXDemo
//
//  Created by admin on 2021/6/9.
//

#import "JXFather.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXSon : JXFather

- (void)doInstanceBySon;
+ (void)doClassBySon;

- (void)doInstanceNoImplementation;
+ (void)doClassNoImplementation;

@end

NS_ASSUME_NONNULL_END
