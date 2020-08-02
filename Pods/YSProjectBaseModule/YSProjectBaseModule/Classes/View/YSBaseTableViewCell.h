//
//  YSBaseTableViewCell.h
//
//  Created by luzhongchang on 17/5/16.
//  Copyright © 2017年 Jam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <YSToolsKit/YSToolsKit.h>
//#import <ProjectConfig/ProjectConfig.h>
#import <YSMediator/YSMediator.h>

#import "YSBaseViewIMPL.h"

@interface YSBaseTableViewCell : UITableViewCell<YSBaseViewIMPL>

@property (nonatomic, strong) NSLayoutConstraint *topLineLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *topLineRightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomLineLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomLineRightConstraint;

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL showBottomLine;

@end
