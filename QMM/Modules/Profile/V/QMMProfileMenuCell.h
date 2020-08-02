//
//  QMMProfileMenuCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"
#import "QMMProfileCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMProfileMenuCell : YSBaseTableViewCell

@property (nonatomic, strong) QMMProfileCellModel *cellModel;
@property (nonatomic, copy) void(^menuItemClick)(NSInteger idx, NSString *mapStr);

@end

NS_ASSUME_NONNULL_END
