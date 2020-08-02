//
//  YSBaseView.h
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

#import "YSBaseViewIMPL.h"

/// 基础view类, 其他view模块应继承自该类,从而统一遵守 `WDBaseViewIMPL` 协议
@interface YSBaseView : UIView <YSBaseViewIMPL>

@end
