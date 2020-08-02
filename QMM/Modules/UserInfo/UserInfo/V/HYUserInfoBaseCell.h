//
//  HYUserInfoBaseCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"
#import "HYUserInfoCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYUserInfoBaseCell : YSBaseTableViewCell

@property (nonatomic, strong) HYUserInfoCellModel *cellModel;

@end

NS_ASSUME_NONNULL_END
