//
//  AppContext.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "AppContext.h"

static NSString *const kAppVersion = @"appVersion";

@implementation AppContext

+ (instancetype)shareContext {
    static dispatch_once_t onceToken;
    static AppContext *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [AppContext new];
        instance->_isNewUpdate = [self __isNewUpdate];
    });
    return instance;
}

+ (BOOL)__isNewUpdate {
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    else{
        return NO;
    }
}


@end


@implementation AppVersionModel

@end
