//
//  UIButton+Create.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "UIButton+Create.h"
#import <Objc/Runtime.h>

static const void *kButtonPrivateKey = &"kButtonPrivateKey";

@interface UIButton()

@property (nonatomic, copy) void(^__actionCaller)(UIButton *btn);

@end

@implementation UIButton (Create)

- (void)set__actionCaller:(void (^)(UIButton *))__actionCaller {
    objc_setAssociatedObject(self, kButtonPrivateKey, __actionCaller, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIButton *))__actionCaller {
    return objc_getAssociatedObject(self, kButtonPrivateKey);
}

+ (instancetype)buttonWithNormalImgName:(NSString *)nImgName
                                bgColor:(UIColor *)bgColor
                                 inView:(__kindof UIView *)inView
                                 action:(void(^)(UIButton *btn))action {
    return [self buttonWithTitle:nil
                      titleColor:nil
                            font:nil
                   normalImgName:nImgName
            highlightedImageName:nil
                         bgColor:bgColor
               normalBgImageName:nil
          highlightedBgImageName:nil
                          inView:inView
                          action:action];
}

+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                       font:(UIFont *)font
                        bgColor:(UIColor *)bgColor
                         inView:(__kindof UIView *)inView
                         action:(void(^)(UIButton *btn))action {
    return [self buttonWithTitle:title
                      titleColor:titleColor
                        font:font
                   normalImgName:nil
            highlightedImageName:nil
                         bgColor:bgColor
               normalBgImageName:nil
          highlightedBgImageName:nil
                          inView:inView
                          action:action];
}

+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                       font:(UIFont *)font
                  normalImgName:(NSString *)nImgName
                        bgColor:(UIColor *)bgColor
                         inView:(__kindof UIView *)inView
                         action:(void(^)(UIButton *btn))action {
    return [self buttonWithTitle:title
                      titleColor:titleColor
                        font:font
                   normalImgName:nImgName
            highlightedImageName:nil
                         bgColor:bgColor
               normalBgImageName:nil
          highlightedBgImageName:nil
                          inView:inView
                          action:action];
}

+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                       font:(UIFont *)font
                  normalImgName:(NSString *)nImgName
           highlightedImageName:(NSString *)hImgName
                        bgColor:(UIColor *)bgColor
              normalBgImageName:(NSString *)nBgImageName
         highlightedBgImageName:(NSString *)hBgImageName
                         inView:(__kindof UIView *)inView
                         action:(void(^)(UIButton *btn))action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(title && ![title isEqualToString:@""]) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (font) {
        [btn.titleLabel setFont:font];
    }
    if(nImgName && ![nImgName isEqualToString:@""]) {
        [btn setImage:[UIImage imageNamed:nImgName] forState:UIControlStateNormal];
    }
    if(hImgName && ![hImgName isEqualToString:@""]) {
        [btn setImage:[UIImage imageNamed:hImgName] forState:UIControlStateHighlighted];
    }
    if (bgColor) {
        [btn setBackgroundColor:bgColor];
    }
    if(nBgImageName && ![nBgImageName isEqualToString:@""]) {
        [btn setBackgroundImage:[UIImage imageNamed:nBgImageName] forState:UIControlStateNormal];
    }
    if(hBgImageName && ![hBgImageName isEqualToString:@""]) {
        [btn setBackgroundImage:[UIImage imageNamed:hBgImageName] forState:UIControlStateHighlighted];
    }
    if (action) {
        btn.__actionCaller = action;
        [btn addTarget:self action:@selector(__prefermAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (inView && [inView isKindOfClass:[UIView class]]) {
        [inView addSubview:btn];
    }
    
    return btn;
}

+ (void)__prefermAction:(UIButton *)btn {
    btn.__actionCaller(btn);
}

@end
