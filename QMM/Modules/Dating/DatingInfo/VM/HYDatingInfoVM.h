//
//  HYDatingInfoVM.h
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "YSBaseViewModel.h"

@interface HYDatingInfoVM : YSBaseViewModel

@property (nonatomic, copy) NSString *dateID;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *tips;

@property (nonatomic, copy) NSString *signinAlertMsg;

@property (nonatomic, assign) DatingStatusType type;
@property (nonatomic, assign) BOOL inSignRange;

@property (nonatomic, copy) NSString *signTips;

@property (nonatomic, copy) NSString *inviteTime;
@property (nonatomic, copy) NSString *inviteAddress;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) RACCommand *requestCmd;
@property (nonatomic, strong) RACCommand *inviteDateCmd;
@property (nonatomic, strong) RACCommand *cancleDateCmd;
@property (nonatomic, strong) RACCommand *acceptDateCmd;
@property (nonatomic, strong) RACCommand *changeDateCmd;
@property (nonatomic, strong) RACCommand *signinDateCmd;

@end
