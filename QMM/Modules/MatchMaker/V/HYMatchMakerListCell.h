//
//  HYMatchMakerListCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"
#import "HYMatchMakerCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYMatchMakerListCell : YSBaseTableViewCell

@property (nonatomic, strong) HYMatchMakerCellModel *cellModel;

@end

NS_ASSUME_NONNULL_END
