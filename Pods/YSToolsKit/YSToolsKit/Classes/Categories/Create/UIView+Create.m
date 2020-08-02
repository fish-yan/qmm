//
//  UIView+Create.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "UIView+Create.h"
#import <objc/runtime.h>

static const void *kViewPrivateKey = &"kViewPrivateKey";

@interface UIView()

@property (nonatomic, copy) void(^__actionCaller)(UIView *view, UIGestureRecognizer *tap);

@end


@implementation UIView (Create)

- (void)set__actionCaller:(void (^)(UIView *, UIGestureRecognizer *))__actionCaller {
    objc_setAssociatedObject(self, kViewPrivateKey, __actionCaller, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIView *, UIGestureRecognizer *))__actionCaller {
    return objc_getAssociatedObject(self, kViewPrivateKey);
}




+ (instancetype)viewWithBackgroundColor:(UIColor *)bgColor inView:(__kindof UIView *)inView {
    return [self viewWithBackgroundColor:bgColor inView:inView tapAction:NULL];
}

+ (instancetype)viewWithBackgroundColor:(UIColor *)bgColor
                                 inView:(__kindof UIView *)inView
                              tapAction:(void(^)(UIView *view, UIGestureRecognizer *tap))tapAction {
    if (bgColor == nil) bgColor = [UIColor clearColor];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = bgColor;
    
    if (tapAction) {
        v.__actionCaller = tapAction;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(__tapAction:)];
        [v addGestureRecognizer:tap];
    }
    
    if (inView) [inView addSubview:v];
    
    return v;
}

+ (void)__tapAction:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    if (label.__actionCaller) {
        label.__actionCaller(label, tap);
    }
}

@end
