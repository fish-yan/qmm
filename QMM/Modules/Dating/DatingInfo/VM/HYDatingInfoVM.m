//
//  HYDatingInfoVM.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "HYDatingInfoVM.h"
#import "HYDatingInfoCellModel.h"
#import "HYDatingInfoModel.h"
#import "LocationHelper.h"

#import <MAMapKit/MAMapKit.h>

@implementation HYDatingInfoVM

- (void)setObj:(id)obj {
    
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self setupInviteData];

    @weakify(self)
    self.requestCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSDictionary *params = @{@"id": self.dateID ?: @""};
        return [[[self requestSignalWithParams:params]
                 map:^id _Nullable(YSResponseModel * _Nullable value) {
                     return value.data;
                 }]
                doNext:^(HYDatingInfoModel * _Nullable x) {
                    @strongify(self);
                    [self recombineDataWithModel:x];
                 }];
    }];
    
    self.inviteDateCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        // "appointmentdate":"2018-6-27 12:30","touid":"882014949324032","address":"苏州羊肉馆(航华店)","addresslat":"31.170041","addresslng":"121.357071"
        NSDictionary *params = @{
                                 @"touid": self.uid ?: @"",
                                 @"appointmentdate": self.inviteTime,
                                 @"address": self.inviteAddress,
                                 @"addresslng": self.longitude ?: @0,
                                 @"addresslat": self.latitude ?: @0
                                 };
        return [[self inviteRequestSignalWithParams:params]
                 doNext:^(YSResponseModel * _Nullable x) {
                      @strongify(self)
                      self.dateID = x.extra;
                 }];
        }];
    
    self.cancleDateCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSDictionary *params = @{@"id": self.dateID ?: @""};
        return [[self cancleRequestSignalWithParams:params]
                map:^id _Nullable(YSResponseModel * _Nullable value) {
                    return value.data;
                }];
    }];
    
    self.changeDateCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSDictionary *params = @{
                                 @"id": self.dateID ?: @"",
                                 @"type": input
                                 };
        return [[self changeDateRequestSignalWithParams:params]
                map:^id _Nullable(YSResponseModel * _Nullable value) {
                    return value.data;
                }];
    }];
    
    self.acceptDateCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSDictionary *params = @{
                                 @"id": self.dateID ?: @"",
                                 @"type": @2
                                 };
        return [[self changeDateRequestSignalWithParams:params]
                map:^id _Nullable(YSResponseModel * _Nullable value) {
                    return value.data;
                }];
    }];
    
    self.signinDateCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.dateID ?: @"" forKey:@"id"];
        
        // 签到请求信号
        RACSignal *s = [[self signinRequestSignalWithParams:params]
                        map:^id _Nullable(YSResponseModel * _Nullable value) {
                            return value.extra;
                        }];
        
        
        
        if (![LocationHelper shareHelper].coordinate) {
            [params setObject:@([LocationHelper shareHelper].coordinate.longitude) forKey:@"lng"];
            [params setObject:@([LocationHelper shareHelper].coordinate.latitude) forKey:@"lat"];
            return s;
        }
        else {
            return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[LocationHelper shareHelper] getLocationWithResult:^(QMMLocation *location, NSError *error) {
                    if (error) {
                        [subscriber sendError:error];
                        [subscriber sendCompleted];
                        return;
                    }
                    
                    [params setObject:@(location.coordinate.longitude) forKey:@"lng"];
                    [params setObject:@(location.coordinate.latitude) forKey:@"lat"];
                    [subscriber sendCompleted];
                    return;
                }];
                
                return nil;
            }] then:^RACSignal * _Nonnull{
                return s;
            }];
            
        }

    }];
}

- (NSString *)fixedSignRangeWithModel:(HYDatingInfoModel *)model {
    NSInteger start = [model.tosignstartdistance integerValue];
    NSInteger end = [model.tosignenddistance integerValue];
    NSString *tips = nil;
    if (start == 0) {
        NSString *date = [self dateOfTime:end];
        tips = [NSString stringWithFormat:@"%@ 后关闭签到赴约",date];
    }
    else {
        NSString *date = [self dateOfTime:start];
        NSInteger d = start / (24 * 60 * 60);
        tips = [NSString stringWithFormat:@"%zd 天 %@ 后开启签到赴约", d, date];
    }
    return tips;
}

- (NSString *)dateOfTime:(NSInteger)t {
    NSInteger d = t / (24 * 60 * 60);
    NSInteger h = (t - d * 24 * 60 * 60) / (60 * 60);
    NSInteger m = (t - d * 24 * 60 * 60 - h * 60 * 60) / 60;
    NSInteger s = (t - d * 24 * 60 * 60 - h * 60 * 60 - m * 60)/60;
    NSString *date = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", h, m, s];
    return date;
}

- (void)setupInviteData {
    self.dataArray = [self inviteDataArray];
    self.title = @"发起约会";
    self.type = DatingStatusTypeInvite;
    self.tips = @"1.为保证您和对方的人身安全，请选择咖啡馆/餐厅/商场等公开场所见面；\n2.发起约会前，可先与对方协商好约会时间、地点，提高约会成功率；\n3.见面前，请和对方线上多多交流，多了解对方的性格爱好；\n4.约会前，请给自己准备一套得体的服装，第一印象很重要；\n5.约会时，多问问对方的意见，让对方感受到你是一个很体贴的人；\n6. 申请取消约会的：约会达成后，一方发起【取消约会】申请，只有另一方同意后，约会才算取消成功；否则，双方都应按约定时间进行线下赴约；每方最多可申请取消3次；\n7.祝您有一个难忘的约会。";
}

- (void)recombineDataWithModel:(HYDatingInfoModel *)m {
    self.title = @"约会详情";
    self.type = [self fixStatusWithModel:m];
    self.signTips = [self fixedSignRangeWithModel:m];
    self.inviteAddress = m.address;
    
    // 没有待支付状态, 待支付改成邀请状态
    // 邀请状态清空数据
//    if (self.type == DatingStatusTypeInvite) {
//        [self setupInviteData];
//        return;
//    }
    
    
    UIColor *infoColor = [self statusInfoColorWithType:self.type];
    
    NSMutableArray *arrM = [NSMutableArray array];
    [arrM addObjectsFromArray:@[
                                [HYDatingInfoCellModel modelWithTitle:@"约会状态" info:m.appstatus2 infoColor:infoColor],
                                [HYDatingInfoCellModel modelWithTitle:@"约会时间" info:m.appointmentdate hasArrow:YES],
                                [HYDatingInfoCellModel modelWithTitle:@"约会地点" info:m.address hasArrow:YES],
                                ]];
    
    if (self.type == DatingStatusTypeHadSignin || self.type == DatingStatusTypeCanSignin) {
        [arrM addObjectsFromArray:@[
                                    [HYDatingInfoCellModel modelWithTitle:@"我的签到时间" info:m.initiatorsigndate hasArrow:NO],
                                    [HYDatingInfoCellModel modelWithTitle:[NSString stringWithFormat:@"%@的签到时间", OBJECT_CALL]
                                                                     info:m.receiversigndate
                                                                 hasArrow:NO],
                                    ]];
    }
    
    self.dataArray = arrM;
}

- (UIColor *)statusInfoColorWithType:(DatingStatusType)type {
    if (type == DatingStatusTypeWaitAccept
        || type == DatingStatusTypeWaitAcceptCancel
        || type == DatingStatusTypeGetInvite) {
        return [UIColor colorWithHexString:@"#FF5D9C"]; // 粉色
    }
    else if (type == DatingStatusTypeDatingWaiting
             || type == DatingStatusTypeCanSignin
             || type == DatingStatusTypeHadSignin
             || type == DatingStatusTypeWaitAccept) {
        return [UIColor colorWithHexString:@"#3DA8F5"]; // 蓝色
    }
    else {
        return [UIColor colorWithHexString:@"#7D7D7D"]; // 黑色
    }
}
/*
 // 约会状态
 public interface APPOINTMENTSTATUS {
 // 约会方发起约会
 public static final int START = 10;
 // 约会方支付保证金
 public static final int APAY = 20;
 // 约会方撤销约会
 public static final int AREVOKE = 30;
 
 // 接收方拒绝发起的约会
 public static final int BUNAGREE = 40;
 
 // 接收方同意发起的约会并支付保证金
 public static final int BPAY = 50;
 
 // 约会方取消发起的约会
 public static final int ACANCEL = 60;
 // 接收方取消发起的约会
 public static final int BCANCEL = 70;
 // 双方同意取消发起的约会
 public static final int ABCANCEL = 80;
 
 // 发起方拒绝取消约会
 public static final int AUNAGREECANCEL = 90;
 // 接收方拒绝取消约会
 public static final int BUNAGREECANCEL = 100;
 
 // 等待双方签到
 public static final int WAITSIGN = 110;
 
 // 发起方爽约
 public static final int ABREAKCONTRACT = 120;
 // 接收方爽约
 public static final int BBREAKCONTRACT = 130;
 
 // 发起方签到
 public static final int ASIGN = 140;
 // 接收方签到
 public static final int BSIGN = 150;
 
 // 关闭
 public static final int CLOSE = 160;
 }
 
 // 约会状态(APP)
 public interface APPOINTMENTAPPSTATUS {
 // 待付保证金
 public static final int WAITPAY = 10;
 // 待应约
 public static final int WAITABOUT = 20;
 // 等待约会中
 public static final int WAITAPPOINTMENT = 30;
 // 约会中
 public static final int APPOINTMENTING = 40;
 // 取消约会中
 public static final int CANCEL = 50;
 // 已完成
 public static final int FINISH = 60;
 // 已关闭
 public static final int CLOSE = 70;
 
 }
 */

- (DatingStatusType)fixStatusWithModel:(HYDatingInfoModel *)m {
    switch (m.appstatus) {
            // 没有待支付状态, 待支付改成邀请状态
        case AppointmentAppStatusWaitPay:
//            return DatingStatusTypeInvite;
            return DatingStatusTypeDidNotPay;
            break;
           
        case AppointmentAppStatusWaitAbout: {   // 待应约
            if ([m.identity integerValue] == 1) { // 我是发起方
                return DatingStatusTypeWaitAccept;
            }
            else if ([m.identity integerValue] == 2) { // 我是接收方
                return DatingStatusTypeGetInvite;
            }
            break;
        }
            
        case AppointmentAppStatusWaitAppointment: { // 等待约会中
            return DatingStatusTypeDatingWaiting;
            break;
        }
        case AppointmentAppStatusAppointmenting: { // 约会中
            if ([m.signstatus boolValue]) { // 当前用户已经签到了
                return DatingStatusTypeHadSignin;
            }
            // 约会中, 约定时间前后一小时,可签到状态
            if ([m.tosignstartdistance integerValue] / 3600.0 <= 1
                && [m.appointmentdate integerValue] / 3600.0 <= 1) {
                return DatingStatusTypeCanSignin;
            }
            
            return DatingStatusTypeDatingWaiting;
            break;
        }
            
        case AppointmentAppStatusCancel: {  // 取消约会中
            if (([m.identity integerValue] == 1 && m.status == AppointmentStatusACancel) // 我是发起方, 并且是发起方取消约会的
                || ([m.identity integerValue] == 2 && m.status == AppointmentStatusBCancel)) {   // 我是接收方, 并且是接收方取消约会的
                return DatingStatusTypeWaitAcceptCancel;
                break;
            }
            return DatingStatusTypeGetCancelRequest;
            break;
        }
        case AppointmentAppStatusFinish: {  // 已完成
            return DatingStatusTypeComplete;
            break;
        }
        case AppointmentAppStatusClose: {
            return DatingStatusTypeClosed;
            break;
        }
        default:
            break;
    }
    
    return 99;
}

- (BOOL)inSignRange {
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(39.989612,116.480972);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.990347,116.480441);
    BOOL isContains = MACircleContainsCoordinate(location, center, 200);
    return isContains;
}


/// 发起约会数据
- (NSArray *)inviteDataArray {
    return @[
             [HYDatingInfoCellModel modelWithTitle:@"约会时间" info:@"" hasArrow:YES canEdited:YES],
             [HYDatingInfoCellModel modelWithTitle:@"约会地点" info:@"" hasArrow:YES canEdited:YES],
             ];
}

- (RACSignal *)requestSignalWithParams:(NSDictionary *)params {
    return [YSRequestAdapter requestSignalWithURL:@""
                                           params:[params decodeWithAPI:API_DATING_INFO]
                                      requestType:YSRequestTypePOST
                                     responseType:YSResponseTypeObject
                                    responseClass:[HYDatingInfoModel class]];
}

- (RACSignal *)inviteRequestSignalWithParams:(NSDictionary *)params {
    NSLog(@"%@", params);
    NSLog(@"%@", API_DATING_ACTION_INVITE);
    return [YSRequestAdapter requestSignalWithURL:@""
                                           params:[params decodeWithAPI:API_DATING_ACTION_INVITE]
                                      requestType:YSRequestTypePOST
                                     responseType:YSResponseTypeMessage
                                    responseClass:nil];
}

- (RACSignal *)cancleRequestSignalWithParams:(NSDictionary *)params {
    return [YSRequestAdapter requestSignalWithURL:@""
                                           params:[params decodeWithAPI:API_DATING_ACTION_CANCEL]
                                      requestType:YSRequestTypePOST
                                     responseType:YSResponseTypeMessage
                                    responseClass:nil];
}
- (RACSignal *)changeDateRequestSignalWithParams:(NSDictionary *)params {
    return [YSRequestAdapter requestSignalWithURL:@""
                                           params:[params decodeWithAPI:API_DATING_ACTION_CHANGE]
                                      requestType:YSRequestTypePOST
                                     responseType:YSResponseTypeMessage
                                    responseClass:nil];
}

- (RACSignal *)signinRequestSignalWithParams:(NSDictionary *)params {
    return [YSRequestAdapter requestSignalWithURL:@""
                                           params:[params decodeWithAPI:API_DATING_ACTION_SIGNIN]
                                      requestType:YSRequestTypePOST
                                     responseType:YSResponseTypeMessage
                                    responseClass:nil];
}

@end
