//
//  HYDatingListContentVC.h
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "YSBaseTableViewController.h"

@interface HYDatingListContentVC : YSBaseTableViewController

/// 1:我发起的,2:ta发起的
@property (nonatomic, assign) NSInteger type;
// 1:邀请中,2:进行中,3:已完成
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) void(^requestHandler)(NSInteger totalCnt);

@end
