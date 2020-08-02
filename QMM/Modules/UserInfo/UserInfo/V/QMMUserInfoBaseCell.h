//
//  QMMUserInfoBaseCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"
#import "QMMUserInfoCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMUserInfoBaseCell : YSBaseTableViewCell

@property (nonatomic, strong) QMMUserInfoCellModel *cellModel;

@end

NS_ASSUME_NONNULL_END
