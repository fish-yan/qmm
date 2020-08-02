//
//  HYOnlinePayVC.h
//  youbaner
//
//  Created by Joseph Koh on 2018/6/27.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseViewController.h"


typedef NS_ENUM(NSInteger, OnlinePayActionType) {
    OnlinePayActionTypeOutput = 0,
    OnlinePayActionTypeInput,
};

@interface HYOnlinePayVC : YSBaseViewController

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *payCount;
@property (nonatomic, copy) void(^rst)(BOOL isSuccess);

@property (nonatomic, assign) OnlinePayActionType actionType;
@end
