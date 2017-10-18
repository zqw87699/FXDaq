//
//  UIViewController+FXPointDaq.m
//  Test
//
//  Created by 张大宗 on 2017/10/17.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import "UIViewController+FXPointDaq.h"
#import "FXUtils.h"
#import <objc/runtime.h>
#import "FXPointDaq.h"

static const void *FXPointName = &FXPointName;

@implementation UIViewController (FXPointDaq)
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
        __swizzle(self, @selector(viewWillAppear:));
        __swizzle(self, @selector(viewWillDisappear:));
    });
}

- (void)swizzled_viewWillAppear:(BOOL)animated{
    [self swizzled_viewWillAppear:animated];

    NSString *pointName = self.pointName;
    if (FX_STRING_IS_EMPTY(pointName)) {
        pointName = self.title ? self.title : NSStringFromClass([self class]);
    }
    [FXPointDaq saveDaq:pointName Action:@"WillAppear"];
}

- (void)swizzled_viewWillDisappear:(BOOL)animated{
    [self swizzled_viewWillDisappear:animated];
    
    NSString *pointName = self.pointName;
    if (FX_STRING_IS_EMPTY(pointName)) {
        pointName = self.title ? self.title : NSStringFromClass([self class]);
    }
    [FXPointDaq saveDaq:pointName Action:@"WillDisappear"];
}


@end
