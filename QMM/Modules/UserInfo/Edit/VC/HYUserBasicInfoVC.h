//
//  HYUserBasicInfoVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewController.h"
#import "HYUserBasicInfoVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYUserBasicInfoVC : YSBaseTableViewController

@property (nonatomic, strong) HYUserCenterModel *infoModel;

@property (nonatomic, assign) UserInfoEditType type;

@end

NS_ASSUME_NONNULL_END
