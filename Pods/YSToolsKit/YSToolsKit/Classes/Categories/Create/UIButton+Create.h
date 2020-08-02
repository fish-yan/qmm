//
//  UIButton+Create.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Create)

/**
 创建按钮类方法: 图片/背景颜色
 
 @param nImgName normal状态图片
 @param bgColor 背景颜色
 @param inView 要加入到的视图
 @param action 点击操作回调
 @return UIButton实例
 */
+ (instancetype)buttonWithNormalImgName:(NSString *)nImgName
                                bgColor:(UIColor *)bgColor
                                 inView:(__kindof UIView *)inView
                                 action:(void(^)(UIButton *btn))action;

/**
 创建按钮类方法: 标题/标题颜色/字号/背景颜色
 
 @param title 标题
 @param titleColor 标题颜色
 @param font 标题字体
 @param bgColor 背景颜色
 @param inView 要加入到的视图
 @param action 点击操作回调
 @return UIButton实例
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                        bgColor:(UIColor *)bgColor
                         inView:(__kindof UIView *)inView
                         action:(void(^)(UIButton *btn))action;

/**
 创建按钮类方法: 标题/标题颜色/字号/图片/背景颜色
 
 @param title 标题
 @param titleColor 标题颜色
 @param font 标题字体
 @param nImgName normal状态图片
 @param bgColor 背景颜色
 @param inView 要加入到的视图
 @param action 点击操作回调
 @return UIButton实例
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                  normalImgName:(NSString *)nImgName
                        bgColor:(UIColor *)bgColor
                         inView:(__kindof UIView *)inView
                         action:(void(^)(UIButton *btn))action;


/**
 创建按钮类方法, 最全的方法. 标题/标题颜色/字号/图片/背景颜色/背景图片

 @param title 标题
 @param titleColor 标题颜色
 @param font 标题字体
 @param nImgName normal状态图片
 @param hImgName hightlighted状态图片
 @param bgColor 背景颜色
 @param nBgImageName normal状态背景图片
 @param hBgImageName hightlighted状态背景图片
 @param inView 要加入到的视图
 @param action 点击操作回调
 @return UIButton实例
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                  normalImgName:(NSString *)nImgName
           highlightedImageName:(NSString *)hImgName
                        bgColor:(UIColor *)bgColor
              normalBgImageName:(NSString *)nBgImageName
         highlightedBgImageName:(NSString *)hBgImageName
                         inView:(__kindof UIView *)inView
                         action:(void(^)(UIButton *btn))action;

@end
