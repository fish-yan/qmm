//
//  CountDownHelper.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "CountDownHelper.h"
#define COUNTDOWN_TIMER(countDownTimer, countDown, limitedTime)  \
if (countDown > 0) return; \
__block NSInteger timeOut = limitedTime;    \
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); \
countDownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);    \
dispatch_source_set_timer(countDownTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);\
dispatch_source_set_event_handler(countDownTimer, ^{    \
if(timeOut <= 0){ \
dispatch_source_cancel(countDownTimer); \
dispatch_async(dispatch_get_main_queue(), ^{    \
countDown = 0;  \
}); \
}   \
else{   \
int seconds = timeOut % 60; \
dispatch_async(dispatch_get_main_queue(), ^{ \
countDown = seconds; \
}); \
timeOut--; \
} \
}); \
dispatch_resume(countDownTimer); \

@interface CountDownHelper ()
@property (nonatomic, strong) dispatch_source_t registerTimer;
@property (nonatomic, strong) dispatch_source_t loginTimer;
@property (nonatomic, strong) dispatch_source_t resetPwdTimer;

@end

@implementation CountDownHelper
+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    static CountDownHelper *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

-(id)init
{
    self =[super init];
    if(self)
    {
        self.registerTime=-1;
        self.LoginTime=-1;
        self.resetPwdTime =-1;
    }
    return self;
}
- (void)startWithCountDownType:(CountDownType)countDownType limitedTime:(NSInteger)limitedTime {
    switch (countDownType) {
        case CountDownTypeRegister: {
            if(self.registerTimer)
                COUNTDOWN_TIMER(self.registerTimer, self.registerTime, limitedTime);
            break;
        }
        case CountDownTypeLogin: {
            COUNTDOWN_TIMER(self.loginTimer, self.LoginTime, limitedTime);
            break;
        }
        case CountDownTypeResetPwd: {
            COUNTDOWN_TIMER(self.resetPwdTimer, self.resetPwdTime, limitedTime);
            break;
        }
        default:
            break;
    }
}

- (void)stopCountDownWitType:(CountDownType)countDownType {
    switch (countDownType) {
        case CountDownTypeRegister: {
            dispatch_source_cancel(_registerTimer);
            self.registerTime = 0;
            break;
        }
        case CountDownTypeLogin: {
            dispatch_source_cancel(_loginTimer);
            self.LoginTime = 0;
            break;
        }
        case CountDownTypeResetPwd: {
            dispatch_source_cancel(_resetPwdTimer);
            self.resetPwdTime = 0;
            break;
        }
        default:
            break;
    }
}

@end
