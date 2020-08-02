//
//  QMMProfileInfoCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"
#import "QMMProfileCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMProfileInfoCell : YSBaseTableViewCell

@property (nonatomic, strong) QMMProfileCellModel *cellModel;

@property (nonatomic, copy) void(^accoundHandler)(void);
@property (nonatomic, copy) void(^identityHandler)(void);
@property (nonatomic, copy) void(^userInfoHandler)(void);
@property (nonatomic, copy) void(^avatarHandler)(void);

@end

NS_ASSUME_NONNULL_END
