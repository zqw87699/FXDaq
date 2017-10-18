//
//  UIControl+FXPointDaq.m
//  Test
//
//  Created by 张大宗 on 2017/10/17.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import "UIControl+FXPointDaq.h"
#import "FXUtils.h"
#import "FXPointDaq.h"
#import <objc/runtime.h>

static const void *FXPointName = &FXPointName;
@implementation UIControl (FXPointDaq)
@dynamic pointName;

- (NSString*)pointName{
    return objc_getAssociatedObject(self, FXPointName);
}

- (void)setPointName:(NSString *)pointName{
    objc_setAssociatedObject(self, FXPointName, pointName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __swizzle(self, @selector(sendAction:to:forEvent:));
    });
}

- (void)swizzled_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    [self swizzled_sendAction:action to:target forEvent:event];
    [FXPointDaq saveDaq:self.pointName ? self.pointName : NSStringFromClass([self class]) Action:@"UIControlEvents"];
    NSLog(@"inininin");
}

@end
