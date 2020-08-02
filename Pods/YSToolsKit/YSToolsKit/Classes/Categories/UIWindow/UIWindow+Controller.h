//
//  UIWindow+Controller.h
//  YSKit
//
//  Created by Joseph Koh on 16/4/25.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Controller)

/*!
 @brief 当前顶部控制器
 */
- (UIViewController *)topMostContoller;

/*!
 @brief 当前显示的控制器
 */
- (UIViewController *)currentViewController;

@end
