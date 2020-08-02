//
//  UILabel+Create.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "UILabel+Create.h"
#import <objc/runtime.h>

static const void *kLabelPrivateKey = &"kLabelPrivateKey";

@interface UILabel()

@property (nonatomic, copy) void(^__actionCaller)(UILabel *label, UIGestureRecognizer *tap);

@end

@implementation UILabel (Create)

- (void)set__actionCaller:(void (^)(UILabel *, UIGestureRecognizer *))__actionCaller {
    objc_setAssociatedObject(self, kLabelPrivateKey, __actionCaller, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UILabel *, UIGestureRecognizer *))__actionCaller {
    return objc_getAssociatedObject(self, kLabelPrivateKey);
}

+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)textColor
                  font:(UIFont *)font
                    inView:(__kindof UIView *)inView
                 tapAction:(void(^)(UILabel *label, UIGestureRecognizer *tap))tapAction {
    return [self labelWithText:text
                     textColor:textColor
                          font:font
               backgroundColor:nil
                        inView:inView
                     tapAction:tapAction];
}

+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)textColor
             textAlignment:(NSTextAlignment)alignment
                  font:(UIFont *)font
                    inView:(__kindof UIView *)inView
                 tapAction:(void(^)(UILabel *label, UIGestureRecognizer *tap))tapAction {
    return [self labelWithText:text
                     textColor:textColor
                 textAlignment:alignment
                          font:font
               backgroundColor:nil
                        inView:inView
                     tapAction:tapAction];
}

+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)textColor
                      font:(UIFont *)font
           backgroundColor:(UIColor *)bgColor
                    inView:(__kindof UIView *)inView
                 tapAction:(void(^)(UILabel *label, UIGestureRecognizer *tap))tapAction {
    return [self labelWithText:text
                     textColor:textColor
                 textAlignment:NSTextAlignmentNatural
                          font:font
               backgroundColor:bgColor
                        inView:inView
                     tapAction:tapAction];
}

+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)textColor
             textAlignment:(NSTextAlignment)alignment
                      font:(UIFont *)font
           backgroundColor:(UIColor *)bgColor
                    inView:(__kindof UIView *)inView
                 tapAction:(void(^)(UILabel *label, UIGestureRecognizer *tap))tapAction {
    UILabel *label = [[UILabel alloc] init];

    if (textColor) label.textColor = textColor;
    if (font) label.font = font;
    if (bgColor) label.textColor = textColor;
    
    label.text = text;
    label.textAlignment = alignment;
    [label sizeToFit];
    
    if (tapAction) {
        label.userInteractionEnabled = YES;
        label.__actionCaller = tapAction;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(__tapAction:)];
        [label addGestureRecognizer:tap];
    }
    
    if (inView && [inView isKindOfClass:[UIView class]]) {
        [inView addSubview:label];
    }
    return label;
}

+ (void)__tapAction:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    if (label.__actionCaller) {
        label.__actionCaller(label, tap);
    }
}
@end
