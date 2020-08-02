//
//  QMMFilterVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewController.h"
#import "HYFilterVM.h"
#import "QMMFilterRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMFilterVC : YSBaseTableViewController

@property (nonatomic, copy) void(^callBack)(QMMFilterRecordModel *filters);
@property (nonatomic, strong) QMMFilterRecordModel *filterInfo;

@end

NS_ASSUME_NONNULL_END
