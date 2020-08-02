//
//  HYFilterViewController.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewController.h"
#import "HYFilterVM.h"
#import "HYFilterRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYFilterViewController : YSBaseTableViewController

@property (nonatomic, copy) void(^callBack)(HYFilterRecordModel *filters);
@property (nonatomic, strong) HYFilterRecordModel *filterInfo;

@end

NS_ASSUME_NONNULL_END
