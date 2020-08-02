//
//  YSNavigationController.h
//  MyProject
//
//  Created by Joseph Gao on 2017/4/30.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <YSToolsKit/YSToolsKit.h>
//#import <ProjectConfig/ProjectConfig.h>
#import <YSMediator/YSMediator.h>

@interface YSNavigationController : UINavigationController

- (void)setBackButtonWithImage;
- (void)setNavigationBarDefaultAppearance;
- (UIImage *)barBackgroundImage;

@end
