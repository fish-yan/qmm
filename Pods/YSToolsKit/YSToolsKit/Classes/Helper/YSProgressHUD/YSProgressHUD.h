//
//  YSProgressHUD.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/11.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 加载指示器类
@interface YSProgressHUD : NSObject

/**
 在视图中显示指示器, inView设置成 控制器的view, 可以操作导航栏返回按钮
 如果inView为nil则HUD添加在window上面, 导航栏 `不可` 操作
 @param inView 添加到的视图, nil为window层
 */
+ (void)showInView:(UIView *)inView;

/**
 在视图中显示指示器, inView设置成 控制器的view, 可以操作导航栏返回按钮

 @param inView 添加到哪个view中显示
 @param title 显示的标题
 */
+ (void)showInView:(UIView *)inView withTitle:(NSString *)title;

/**
 显示菊花指示器, HUD添加在window上面, 导航栏 `不可` 操作
 */
+ (void)showIndeterminate;

/**
 显示菊花指示器, HUD添加在window上面, 导航栏 `不可` 操作
 @param title 显示的文字
 */
+ (void)showIndeterminateWithTitle:(NSString *)title;

/**
 显示提示信息, 1.5秒后消失
 */
+ (void)showTips:(NSString *)tips;

/**
 隐藏HUD,
 无论是使用 ShowInView: 还是 showIndeterminate的方式都可以用此方法
 */
+ (void)hiddenHUD;

@end
