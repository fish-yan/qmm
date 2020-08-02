//
//  UIView+Create.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Create)

+ (instancetype)viewWithBackgroundColor:(UIColor *)bgColor inView:(__kindof UIView *)inView;

+ (instancetype)viewWithBackgroundColor:(UIColor *)bgColor
                                 inView:(__kindof UIView *)inView
                              tapAction:(void(^)(UIView *view, UIGestureRecognizer *tap))tapAction;

@end
