//
//  HYDatingLineModel.h
//  youbaner
//
//  Created by Joseph Koh on 2018/6/28.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseModel.h"

@interface HYDatingRouteItem : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *content;
/// 状态归属：1：发起方，2：接收方
@property (nonatomic, strong) NSNumber *type;

@end

@interface HYDatingLineModel : YSBaseModel

/// 发起方uid
@property (nonatomic, copy) NSString *initiatoruid;
// 发起方头像
@property (nonatomic, copy) NSString *initiatoravatar;
// 发起方昵称
@property (nonatomic, copy) NSString *initiatorname;

// 接收方uid
@property (nonatomic, copy) NSString *receiveruid;
@property (nonatomic, copy) NSString *receiveravatar;
@property (nonatomic, copy) NSString *receivername;
// 约会轨迹
@property (nonatomic, strong) NSArray<HYDatingRouteItem *> *routeitems;

@end
