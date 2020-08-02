//
//  HYProfileInfoCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"
#import "HYProfileCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYProfileInfoCell : YSBaseTableViewCell

@property (nonatomic, strong) HYProfileCellModel *cellModel;

@property (nonatomic, copy) void(^friendRequireHandler)(void);
@property (nonatomic, copy) void(^identityHandler)(void);
@property (nonatomic, copy) void(^userInfoHandler)(void);
@property (nonatomic, copy) void(^avatarHandler)(void);

@end

NS_ASSUME_NONNULL_END
