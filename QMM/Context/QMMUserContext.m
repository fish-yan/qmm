//
//  QMMUserContext.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMUserContext.h"

@implementation QMMPayItemInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"mid": @"id"};
}

@end

@implementation PhotoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"mid": @"id" };
}
@end

@implementation HYUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"wantToMarrayTime": @"wantmarry",
        @"reciveSalary": @"msalary",
        @"homeprovince2": @"workcity",
        @"showPicArray": @"photos",
        @"schoollevel": @"degree",
        @"personal": @"jobinfo",


    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"photos": @"PhotoModel" };
}
@end


@implementation QMMUserContext

+ (instancetype)shareContext {
    static dispatch_once_t onceToken;
    static QMMUserContext *instance = nil;

    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance initialize];
    });
    return instance;
}

- (void)initialize {
    self.userModel = [[HYUserModel alloc] init];

    [self bindmodel];
}


- (void)bindmodel {
    [RACObserve(self, uid) subscribeNext:^(NSString *_Nullable x) {
        if (x) {
            [self checkAppUpdate];
        }
    }];
}


- (void)checkAppUpdate {
    // cmd must 强制跟新 no 不更新
    NSDictionary *dic = @{ @"appid": @"1002", @"version": APP_VERSION };

    NSDictionary *params = [dic decodeWithAPI:@"API_CHECKUPDATE"];
    RACSignal *signal = [QMMRequestAdapter requestSignalParams:params
                                                  responseType:YSResponseTypeObject
                                                 responseClass:[AppVersionModel class]];



    @weakify(self);
    [signal subscribeNext:^(YSResponseModel *_Nullable x) {
        @strongify(self);
        AppVersionModel *v = x.data;
        if ([v.updatecmd isEqualToString:@"no"]) {
        }
        else if ([v.updatecmd isEqualToString:@"must"]) {
            NSString *str = [NSString stringWithFormat:@"%@,%@", v.newdate, v.newnote];
            [self showUpdataAlertWithType:@1 title:v.newversion message:str];

        }
        else if ([v.updatecmd isEqualToString:@"suggest"]) {
            [self showUpdataAlertWithType:@2 title:v.newversion message:v.newnote];
        }
    }];
}

- (void)showUpdataAlertWithType:(NSNumber *)type title:(NSString *)title message:(NSString *)message {
    NSDictionary *params = @{
                             @"alertTitle": title,
                             @"message": message,
                             @"type": type,
                             @"leftButtonTitle": @"取消",
                             @"rightButtonTitle": @"更新",
                             @"rightTitleColor": [UIColor tc2Color],
                             };
    [YSMediator presentToViewController:@"HYAlertViewController"
                             withParams:params
                               animated:YES
                               callBack:nil];
}

@end


@implementation QMMUserContext (DataAciton)

- (void)loadUserInfoLocalDBData {
    HYUserModel *obj =
    [[YSDBDaoManager shareManager] searchSingle:[HYUserModel class] where:nil orderBy:nil];
    if (obj && [obj isKindOfClass:[HYUserModel class]]) {
        self.userModel = obj;
        [self readUserInfo:obj];
        self.login = [self getLoginStatus];
    }
}

/// 获取登录状态
- (BOOL)getLoginStatus {
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_LOGIN_KEY];
    return (obj == nil || ![obj boolValue]) ? NO : YES;
}


/// 读取本地用户数据
- (void)readUserInfo:(HYUserModel *)userInfoModel {
    if (self.uid != userInfoModel.uid && userInfoModel.uid != nil) {
        self.uid = userInfoModel.uid;
    }
    if (self.token != userInfoModel.token && userInfoModel.token != nil) {
        self.token = userInfoModel.token;
    }

    self.vipverifystatus      = userInfoModel.vipstatus;
    self.identityverifystatus = userInfoModel.identityverifystatus;
}
/// 更新用户数据
- (void)updateUserInfo:(HYUserModel *)userInfoModel {
    self.userModel = userInfoModel;

    if (self.uid != userInfoModel.uid && userInfoModel.uid != nil) {
        self.uid = userInfoModel.uid;
    }
    if (self.token != userInfoModel.token && userInfoModel.token != nil) {
        self.token = userInfoModel.token;
    }
    if (userInfoModel.vipstatus != nil) {
        self.vipverifystatus = userInfoModel.vipstatus;
    }


    self.identityverifystatus = userInfoModel.identityverifystatus;

    self.userModel.token = self.token;

    [self saveLastestUserDateToDB];
}

/// 保存最新的用户信息
- (void)saveLastestUserDateToDB {
    // 删除数据库中已有的用户信息, 保存最新的
    [self deleteUserDBData];
    [[YSDBDaoManager shareManager] insertToDB:self.userModel];
}

/// 删除本地数据库用户数据
- (void)deleteUserDBData {
    YSDBDaoManager *mgr = [YSDBDaoManager shareManager];
    BOOL b              = [mgr deleteWithClass:[HYUserModel class] where:nil];
    if (b) {
        NSLog(@"ok");
    }
}


/// 清除Token信息
- (void)clearUserModelInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_REGISTER_MOBILE_KEY];
    self.token = nil;
}


//从服务端获取最新的用户基本信息
- (void)fetchLatestUserinfoWithSuccessHandle:(void (^)(HYUserModel *))successHandler
                               failureHandle:(void (^)(NSError *))failureHandler {
    NSDictionary *params = @{};
    RACSignal *signal    = [QMMRequestAdapter requestSignalParams:[params decodeWithAPI:API_PROFILE]
                                                  responseType:YSResponseTypeObject
                                                 responseClass:[HYUserModel class]];
    @weakify(self);
    [signal subscribeNext:^(YSResponseModel *_Nullable x) {
        @strongify(self);
        HYUserModel *infoModel = x.data;
        [self updateUserInfo:infoModel];

        if (successHandler) {
            successHandler(infoModel);
        }
    }
    error:^(NSError *_Nullable error) {
        if (failureHandler) {
            failureHandler(error);
        }
    }];
}


@end


@implementation QMMUserContext (Deploy)

- (void)deployLogoutAction {
    [self updateLoginStatus:NO];
    [self deleteUserDBData];
    [self clearUserModelInfo];
    
    // 发送退出通知, AppDelegateUIAssistant 接受通知更换控制器为LoginViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT_NOTIF_KEY object:nil];
}

- (void)deployLoginActionWithUserModel:(HYUserModel *)userModel action:(void (^)(void))action {
    self->_userModel = userModel;
    [self updateUserInfo:userModel];
    [self updateLoginStatus:YES];
}

- (void)deployLoginActionWithUserModel:(HYUserModel *)userModel {
    [self
    deployLoginActionWithUserModel:userModel
                            action:^{
                                // 登陆成功后发送通知, AppDelegateUIAssistant 接受通知更换控制器为TabBarViewController
                                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIF_KEY object:nil];
                            }];
}

- (void)deployLoginActionWithUserModelByRegister:(HYUserModel *)userModel {
    self->_userModel = userModel;
    [self readUserInfo:userModel];
    [self updateUserInfo:userModel];
    [self updateLoginStatus:YES];
    [self saveLastestUserDateToDB];
}


- (void)deployKickOutAction {
    [self updateLoginStatus:NO];
    [self deleteUserDBData];
    [self clearUserModelInfo];
}
- (void)updateLoginStatus:(BOOL)isLogin {
    self.login = isLogin;
    // 更新登录状态
    [[NSUserDefaults standardUserDefaults] setObject:isLogin ? @1 : @0 forKey:USER_DEFAULTS_LOGIN_KEY];
    // 保存上一次登录的用户的手机号码
    [[NSUserDefaults standardUserDefaults] setObject:self.userModel.mobile ?: @"" forKey:USER_REGISTER_MOBILE_KEY];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)objectCall {
    if ([self.userModel.sex isEqualToString:@"男"]) {
        return @"她";
    }
    return @"他";
}

- (NSString *)avatarPlaceholder {
    if ([self.userModel.sex isEqualToString:@"男"]) {
        return @"woman";
    }
    return @"man";
}

@end

