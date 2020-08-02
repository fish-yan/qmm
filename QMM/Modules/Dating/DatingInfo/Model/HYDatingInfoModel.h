//
//  HYDatingInfoModel.h
//  youbaner
//
//  Created by Joseph Koh on 2018/6/14.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseModel.h"

typedef NS_ENUM(NSInteger, AppointmentStatus) {
    AppointmentStatusStart = 10,
    AppointmentStatusApay = 20,
    AppointmentStatusARevoke = 30,
    AppointmentStatusBunagree = 40,
    AppointmentStatusBPay = 50,
    AppointmentStatusACancel = 60,
    AppointmentStatusBCancel = 70,
    AppointmentStatusABCancel = 80,
    AppointmentStatusAUnagreeCancel = 90,
    AppointmentStatusBUnagreeCancel = 100,
    AppointmentStatusWaitSign = 110,
    AppointmentStatusABreakContract = 120,
    AppointmentStatusBBreakContract = 130,
    AppointmentStatusASign = 140,
    AppointmentStatusBSign = 150,
    AppointmentStatusClose = 160,
};
typedef NS_ENUM(NSInteger, AppointmentAppStatus) {
    AppointmentAppStatusWaitPay = 10,
    AppointmentAppStatusWaitAbout = 20, // 待应约
    AppointmentAppStatusWaitAppointment = 30,
    AppointmentAppStatusAppointmenting = 40,
    AppointmentAppStatusCancel = 50,
    AppointmentAppStatusFinish = 60,
    AppointmentAppStatusClose = 70,
};

@interface HYDatingInfoModel : YSBaseModel
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *appointmentdate;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *addresslng;
@property (nonatomic, copy) NSString *addresslat;
/// 保证金
@property (nonatomic, copy) NSString *appointmentensure;


@property (nonatomic, assign) AppointmentStatus status;
@property (nonatomic, copy) NSString *status2;

@property (nonatomic, assign) AppointmentAppStatus appstatus;
@property (nonatomic, copy) NSString *appstatus2;

/// 发起方签到时间
@property (nonatomic, copy) NSString *initiatorsigndate;
/// 接收方签到时间
@property (nonatomic, copy) NSString *receiversigndate;

@property (nonatomic, strong) NSNumber *tosignstartdistance;
@property (nonatomic, strong) NSNumber *tosignenddistance;
//0:当前用户未签到约会,1:当前用户已签到约会
@property (nonatomic, strong) NSNumber *signstatus;
//1:当前用户是发起方,2:当前用户是接收方
@property (nonatomic, strong) NSNumber *identity;

@end
