//
//  HYFilterListCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"
#import "HYFilterCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYFilterListCell : YSBaseTableViewCell

@property (nonatomic, strong) HYFilterCellModel *cellModel;

@end

NS_ASSUME_NONNULL_END
