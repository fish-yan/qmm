//
//  HYOnlinePayHelper.h
//  youbaner
//
//  Created by Joseph Koh on 2018/6/27.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface HYOnlinePayInfoModel : YSBaseViewModel

@property (nonatomic, copy) NSString *payid;
// 支付宝支付信息
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *callbackurl;
@property (nonatomic, copy) NSString *payno;
// 微信支付信息
@property (nonatomic, copy) NSString *prepayid;

@end



typedef NS_ENUM(NSInteger, OnlinePayType) {
    OnlinePayTypeAli,
    OnlinePayTypeWeChat,
};

@interface HYOnlinePayHelper : NSObject<WXApiDelegate>

+ (instancetype)shareHelper;

- (void)onlinePay:(OnlinePayType)type
      withPayInfo:(HYOnlinePayInfoModel *)model
           result:(void(^)(id obj, NSError *error))result;

@end
