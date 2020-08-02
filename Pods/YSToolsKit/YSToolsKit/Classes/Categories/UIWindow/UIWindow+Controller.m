//
//  UIWindow+Controller.m
//  YSKit
//
//  Created by Joseph Koh on 16/4/25.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import "UIWindow+Controller.h"

@implementation UIWindow (Controller)

- (UIViewController *)topMostContoller {
    UIViewController *topMostController = [self rootViewController];
    
    // 遍历拿到最顶部的控制器
    while ([topMostController presentedViewController]) {
        topMostController = [topMostController presentedViewController];
    }
    
    return topMostController;
}

- (UIViewController *)currentViewController {
    UIViewController *currentVC = [self topMostContoller];
    
    // 如果顶部是导航控制器,则找到当前显示的控制器
    while ([currentVC isKindOfClass:[UINavigationController class]] &&
           [(UINavigationController *)currentVC topViewController]) {
        currentVC = [(UINavigationController *)currentVC topViewController];
    }
    
    return currentVC;
}

@end
