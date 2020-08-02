//
//  HYDatingListVM.h
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "YSBaseViewModel.h"

@interface HYDatingListVM : YSBaseViewModel

/// 1:我发起的,2:ta发起的
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) RACCommand *requestCmd;
@property (nonatomic, strong) RACCommand *requestMoreCmd;

@end
