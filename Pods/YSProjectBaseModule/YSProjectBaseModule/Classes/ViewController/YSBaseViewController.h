//
//  YSBaseViewController.h
//  MyProject
//
//  Created by Joseph Gao on 2017/4/30.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <YSToolsKit/YSToolsKit.h>
//#import <ProjectConfig/ProjectConfig.h>
#import <YSMediator/YSMediator.h>

#import "YSBaseViewControllerIMPL.h"

@interface YSBaseViewController : UIViewController <YSBaseViewControllerIMPL>

/// YES: 有返回    NO:不能返回
@property (nonatomic, assign)  BOOL canBack;

///  返回按钮点击操作
- (void)popBack;

@end
