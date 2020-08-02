//
//  QMMUserBasicInfoCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"
#import "QMMUserBasicInfoCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMUserBasicInfoCell : YSBaseTableViewCell

@property (nonatomic, strong) QMMUserBasicInfoCellModel *cellModel;

@end

NS_ASSUME_NONNULL_END
