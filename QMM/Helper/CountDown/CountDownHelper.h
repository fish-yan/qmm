//
//  CountDownHelper.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CountDownType) {
    CountDownTypeRegister,
    CountDownTypeLogin,
    CountDownTypeResetPwd,
};

@interface CountDownHelper : NSObject

+ (instancetype)shareHelper;

/// 注册号倒计时剩下的时间
@property (nonatomic, assign) NSInteger registerTime;
/// 登陆倒计时剩下的时间
@property (nonatomic, assign) NSInteger LoginTime;
/// 重置密码验证手机倒计时剩下的时间
@property (nonatomic, assign) NSInteger resetPwdTime;

- (void)startWithCountDownType:(CountDownType)countDownType limitedTime:(NSInteger)limitedTime;
- (void)stopCountDownWitType:(CountDownType)countDownType;

@end

NS_ASSUME_NONNULL_END
