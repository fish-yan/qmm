//
//  QMMAuthUploadIDCell.h
//  SeeYou
//
//  Created by Joseph Koh on 2018/7/16.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseTableViewCell.h"
#import "QMMAuthCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMAuthUploadIDCell : YSBaseTableViewCell

@property (nonatomic, strong) QMMAuthCellModel *cellModel;

@property (nonatomic, copy) void(^addBtnClickHandler)(UIButton *btn);

@end

NS_ASSUME_NONNULL_END
