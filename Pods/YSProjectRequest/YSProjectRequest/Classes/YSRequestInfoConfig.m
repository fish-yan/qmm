//
//  YSRequestInfoConfig.m
//  MyProject
//
//  Created by Joseph Gao on 2017/5/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSRequestInfoConfig.h"

static NSString *const kServicesInfoKey = @"servicesInfo";
static NSString *const kSaveIPKey = @"eip";
static NSString *const kSaveEnviromentKey = @"type";

@interface YSRequestInfoConfig()

@property (nonatomic, assign) YSEnvironmentType enviromentType;

@end

@implementation YSRequestInfoConfig

+ (void)configServices:(void(^)(YSRequestInfoConfig *config))services {
    YSRequestInfoConfig *config = [YSRequestInfoConfig shareConfig];
    if (services) {
        services(config);
    }
}

+ (instancetype)shareConfig {
    static dispatch_once_t onceToken;
    static YSRequestInfoConfig *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[YSRequestInfoConfig alloc] init];
        instance.headerMgr = [YSRequestHeaderManager new];
    });
    return instance;
}

- (void)updateEnvironment:(YSEnvironmentType)enviromentType {
    self.enviromentType = enviromentType;
    [self updateEnvironmentConfig];
}

- (void)updateEnvironmentConfig {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:@(self.enviromentType) forKey:kSaveEnviromentKey];

    if (self.enviromentType == YSEnvironmentTypeOther && self.customIP) {
        [dictM setObject:self.customIP forKey:kSaveIPKey];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dictM forKey:kServicesInfoKey];
    BOOL b = [[NSUserDefaults standardUserDefaults] synchronize];
    [self alertTermalAppMessageByResult:b];
}

- (void)resetToEnvironment {
    [self updateEnvironment:self.defaultEnviroment];
    [self alertTermalAppMessageByResult:YES];
}

- (void)alertTermalAppMessageByResult:(BOOL)b {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:b ? @"Success" : @"Failure"
                                                                        message:b ? @"App Need Restart" : @"Try Again"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        if (b) {
            [alertC addAction:[UIAlertAction actionWithTitle:@"Bye"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [[UIApplication sharedApplication] performSelector:@selector(suspend)];
                                                         [NSThread sleepForTimeInterval:2.0];
                                                         exit(0);
                                                     }]];
        }
        else {
            [alertC addAction:[UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {

                                                     }]];
        }

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC
                                                                                     animated:YES
                                                                                   completion:NULL];
    });

}


#pragma mark - Setter && Getter

- (NSString *)baseURL {
    if (!_baseURL) {
        _baseURL = [NSString stringWithFormat:@"%@%@", self.serverIP, self.urlPath];
    }
    return _baseURL;
}

- (void)setDefaultEnviroment:(YSEnvironmentType)defaultEnviroment {
    _defaultEnviroment = defaultEnviroment;
    self.enviromentType = defaultEnviroment;
}

- (NSString *)serverIP {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kServicesInfoKey];
    YSEnvironmentType type = _defaultEnviroment;
    if (dict != nil) {
        type = [[dict objectForKey:kSaveEnviromentKey] integerValue];
    }
    NSString *ip = [self ipOfEnvironment:type];
    return ip;
}

- (NSString *)ipOfEnvironment:(YSEnvironmentType)type {
    NSString *ip = nil;
    switch (type) {
        case YSEnvironmentTypeProduction:
            ip = self.productionIP;
            break;
        case YSEnvironmentTypePreRelease:
            ip = self.preReleaseIP;
            break;
        case YSEnvironmentTypeTest:
            ip = self.testIP;
            break;
        case YSEnvironmentTypeDevelopment:
            ip = self.developmentIP;
            break;
        case YSEnvironmentTypeOther: {
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kServicesInfoKey];
            ip = [dict objectForKey:kSaveIPKey];
            break;
        }
        default:
            break;
    }
    
    return ip;
}

@end
