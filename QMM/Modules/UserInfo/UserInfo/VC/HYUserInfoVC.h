//
//  HYUserInfoVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewController.h"
#import "HYUserInfoVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYUserInfoVC : YSBaseTableViewController

@property (nonatomic, assign) UserType type;
@property (nonatomic, copy) NSString *uid;

@end

NS_ASSUME_NONNULL_END
