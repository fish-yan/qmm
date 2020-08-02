//
//  HYProfileViewModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYProfileViewModel : YSBaseViewModel

@property (nonatomic, strong) RACCommand *requestCmd;
@property (nonatomic, strong) RACCommand *logoutCmd;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) HYUserCenterModel *detailModel;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) BOOL hasBuyMatchMaker;

// 是否已经认证
@property (nonatomic, assign) BOOL hasIdentify;

@end

NS_ASSUME_NONNULL_END
