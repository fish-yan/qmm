//
//  UILabel+Create.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Create)

/// 快速创建UILabel对象: text / textColor/ font / inView / tapAction
+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)textColor
                      font:(UIFont *)font
                    inView:(__kindof UIView *)inView
                 tapAction:(void(^)(UILabel *label, UIGestureRecognizer *tap))tapAction;

/// 快速创建UILabel对象: text / textColor / alignment/ font / inView / tapAction
+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)textColor
             textAlignment:(NSTextAlignment)alignment
                      font:(UIFont *)font
                    inView:(__kindof UIView *)inView
                 tapAction:(void(^)(UILabel *label, UIGestureRecognizer *tap))tapAction;

/// 快速创建UILabel对象: text / textColor / font/ bgColor / inView / tapAction
+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)textColor
                      font:(UIFont *)font
           backgroundColor:(UIColor *)bgColor
                    inView:(__kindof UIView *)inView
                 tapAction:(void(^)(UILabel *label, UIGestureRecognizer *tap))tapAction;

/// 快速创建UILabel对象: text / textColor / alignment/ font / bgColor / inView / tapAction
+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)textColor
             textAlignment:(NSTextAlignment)alignment
                      font:(UIFont *)font
           backgroundColor:(UIColor *)bgColor
                    inView:(__kindof UIView *)inView
                 tapAction:(void(^)(UILabel *label, UIGestureRecognizer *tap))tapAction;


@end
