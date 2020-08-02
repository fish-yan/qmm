//
//  QMMUserContext.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

// 1基础信息不完善; 2:未上传头像, 需要上传头像; 3:注册过,直接登录, 4: 没有芝麻认证,没有支付, 5:没有芝麻认证, 但是有支付, 6有芝麻认证, 但没有支付

typedef NS_ENUM(NSInteger, UserInfoType) {
    UserInfoTypeRegister = 1,           // 用户新注册
    UserInfoTypeNoAvatar,               // 需要上传头像
    UserInfoTypeComplete,               // 信息完整
    UserInfoTypeNoCertifiedNoPay,       // 4: 没有芝麻认证,没有支付
    UserInfoTypeNoCertifiedHadPay,      // 5:没有芝麻认证, 但是有支付
    UserInfoTypeHadCertifiedNoPay,      // 有芝麻认证, 但没有支付
};

@interface PhotoModel : NSObject

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *url;


@end


/*
 "id": 9000002,
 "name": "支付认证费",
 "price": 0.01,
 "price2": "¥0.01"
 */
@interface QMMPayItemInfo : NSObject

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *price2;

@end

@interface HYUserModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *name;
/*年龄*/
@property (nonatomic, copy) NSString *age;
/*身高*/
@property (nonatomic, copy) NSString *height;

/*收入*/
@property (nonatomic, copy) NSString *reciveSalary;
/*学历*/
@property (nonatomic, copy) NSString *schoollevel;


@property (nonatomic, copy) NSString *sex;

/*是否是会员*/
@property (nonatomic, assign) NSNumber *vipstatus;    // 0非会员，1会员
/*会员是否到期*/
@property (nonatomic, copy) NSString *vipdate;

/*是否推荐红娘购买(0:未购买,1:购买)*/
@property (nonatomic, copy) NSNumber *redniangstatus;
@property (nonatomic, copy) NSString *redniangdate;

// 是否开通置顶服务(0:未开通,1:开通)
@property (nonatomic, assign) NSNumber *topstatus;

/*置顶服务到期时间*/
@property (nonatomic, copy) NSString *topdate;    // 0非会员，1会员

/// 是否信息完整  1:基础信息不完善，2:未上传头像,3:完整, 4: 没有芝麻认证, 5:有芝麻认证, 并支付成功, 6有芝麻认证, 但没有支付
@property (nonatomic, assign) UserInfoType iscomplete;


@property (nonatomic, assign) NSInteger utype;

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *token;


@property (nonatomic, copy) NSString *workarea;

@property (nonatomic, copy) NSString *mobile;


/* 期望结婚时间*/
@property (nonatomic, copy) NSString *wantToMarrayTime;


/*星座*/
@property (nonatomic, copy) NSString *constellation;
/*城市*/
// 地址
@property (nonatomic, copy) NSString *homeprovince2;


@property (nonatomic, copy) NSArray *photos;


// 是否身份认证
@property (nonatomic, copy) NSString *identityverifystatus;
@property (nonatomic, copy) NSString *identityverifystatus2;

//基础信息


@property (nonatomic, copy) NSNumber *province;
@property (nonatomic, copy) NSString *provincestr;

@property (nonatomic, copy) NSNumber *city;
@property (nonatomic, copy) NSString *citystr;

@property (nonatomic, copy) NSNumber *district;
@property (nonatomic, copy) NSString *districtstr;
@property (nonatomic, strong) NSNumber *vipverifystatus;


@property (nonatomic, copy) NSNumber *homeprovince;
@property (nonatomic, copy) NSString *homeprovincestr;

@property (nonatomic, copy) NSNumber *homecity;
@property (nonatomic, copy) NSString *homecitystr;

@property (nonatomic, copy) NSNumber *homedistrict;
@property (nonatomic, copy) NSString *homedistrictstr;

@property (nonatomic, copy) NSString *birthyear;
@property (nonatomic, copy) NSString *birthmonth;
@property (nonatomic, copy) NSString *birthday;


@property (nonatomic, copy) NSString *personal;
@property (nonatomic, copy) NSString *salary;

//
//@property(nonatomic ,copy) NSString * workplace;
//@property(nonatomic ,copy) NSString * homePlace;
// 期望结婚时间
@property (nonatomic, copy) NSString *wantMarry;
// 目前婚姻状况
@property (nonatomic, copy) NSString *marry;

//自我介绍
@property (nonatomic, copy) NSString *intro;

//交友条件
@property (nonatomic, copy) NSNumber *wantprovince;
@property (nonatomic, copy) NSString *wantprovincestr;

@property (nonatomic, copy) NSNumber *wantcity;
@property (nonatomic, copy) NSString *wantcitystr;

@property (nonatomic, copy) NSNumber *wantdistrict;
@property (nonatomic, copy) NSString *wantdistrictstr;


@property (nonatomic, copy) NSNumber *wanthomeprovince;
@property (nonatomic, copy) NSString *wanthomeprovincestr;

@property (nonatomic, copy) NSNumber *wanthomecity;
@property (nonatomic, copy) NSString *wanthomecitystr;

@property (nonatomic, copy) NSNumber *wanthomedistrict;
@property (nonatomic, copy) NSString *wanthomedistrictstr;
@property (nonatomic, copy) NSString *wantagestart;
@property (nonatomic, copy) NSString *wantageend;

@property (nonatomic, copy) NSString *wantheightstart;

@property (nonatomic, copy) NSString *wantheightend;
@property (nonatomic, copy) NSString *wantdegree;
@property (nonatomic, copy) NSString *wantsalary;

/// 芝麻认证url
@property (nonatomic, copy) NSString *zhimaurl;
@property (nonatomic, copy) NSString *zhimabizno;
@property (nonatomic, strong) QMMPayItemInfo *zhimaverify;
@property (nonatomic, strong) QMMPayItemInfo *payverify;
// 是否不需要认证
@property (nonatomic, assign) BOOL pvon;
@property (nonatomic, copy) NSString *pvtitle;
@property (nonatomic, copy) NSString *pvdesc;
@property (nonatomic, copy) NSString *pvcontent;
/// 支付认证支付提示
@property (nonatomic, copy) NSString *pvtips;

@end


@interface QMMUserContext : NSObject


@property (nonatomic, assign) BOOL login;    //是否登录

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSNumber *vipverifystatus;       // 0未交钱，1已近交钱
@property (nonatomic, copy) NSString *identityverifystatus;    //判断是否认证过
@property (nonatomic, strong) HYUserModel *userModel;

@property (nonatomic, assign) int maxpicture;

@property (nonatomic, assign) BOOL autoSendCode;

// 对方称呼
@property (nonatomic, copy) NSString *objectCall;
@property (nonatomic, copy) NSString *avatarPlaceholder;

/// 用户数据环境单例
+ (instancetype)shareContext;

@end


@interface QMMUserContext (DataAciton)


/// 读取本地用户数据
- (void)readUserInfo:(HYUserModel *)userInfoModel;
///加载本地数据
- (void)loadUserInfoLocalDBData;


///跟新用户数据
- (void)updateUserInfo:(HYUserModel *)model;

/// 获取最新的用户数据

- (void)fetchLatestUserinfoWithSuccessHandle:(void (^)(HYUserModel *infoModel))successHandler
                               failureHandle:(void (^)(NSError *error))failureHandler;

@end


@interface QMMUserContext (Deploy)

/// 部署退出登录后的操作: 更新状态/清除数据
- (void)deployLogoutAction;
/// 配置登陆成功后数据操作: 更新本地数据库信息
- (void)deployLoginActionWithUserModel:(HYUserModel *)userModel;
- (void)deployLoginActionWithUserModelByRegister:(HYUserModel *)userModel ;
- (void)deployLoginActionWithUserModel:(HYUserModel *)userModel action:(void(^)(void))action;
/// 部署用户被踢操作: 更换登陆状态
- (void)deployKickOutAction;

@end
