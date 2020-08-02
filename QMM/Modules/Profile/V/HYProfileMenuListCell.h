//
//  HYProfileMenuListCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"
#import "HYProfileCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYProfileMenuListCell : YSBaseTableViewCell

@property (nonatomic, strong) HYProfileCellModel *cellModel;

@end

NS_ASSUME_NONNULL_END
