//
//  HYTopPayViewController.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewController.h"
#import "HYTopPayVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYTopPayViewController : YSBaseViewController

@property (nonatomic, copy) void(^payResult)(BOOL isSuccess);

@end

NS_ASSUME_NONNULL_END
