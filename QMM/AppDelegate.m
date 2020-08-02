//
//  AppDelegate.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "AppDelegate.h"
#import "QMMLaunchDeployer.h"
#import "LocationHelper.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HYOnlinePayHelper.h"

@interface AppDelegate ()

@property (nonatomic, strong) QMMLaunchDeployer *launchDeployer;
@property (nonatomic, strong) QMMPrivacyDeclare *declare;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [YSMediator shareMediator].baseWebClassName = @"YSBaseWebViewController";
    
    [YSRequestInfoConfig configServices:^(YSRequestInfoConfig *config) {
        config.productionIP = @"https://www.huayuanvip.com";
        config.preReleaseIP = @"";
        config.testIP = @"";
        config.developmentIP = @"http://47.105.192.40:8077";
        config.customIP = @"";
        config.urlPath = @"/app/call";
//        config.defaultEnviroment = YSEnvironmentTypeDevelopment;
        config.defaultEnviroment = YSEnvironmentTypeProduction;
        
        config.headerMgr.headerDict = nil;
    }];
    
    //[[YSQiniuUploadHelper shareInstance] registerWithFetchAPI:nil andToken:@""];
    
    [[QMMUserContext shareContext] loadUserInfoLocalDBData];
    [[LocationHelper shareHelper] getLocationWithResult:^(QMMLocation *location, NSError *error) {
        if (error) {
            NSLog(@"========> 定位失败");
        }
    }];
    
    
    [RegisterAssistant registerVanders];
    
    self.launchDeployer = [[QMMLaunchDeployer alloc] init];
    self.window = [self.launchDeployer deplyUI];
    
    
//    // 隐私弹窗
//    if ([QMMPrivacyDeclare isFirstInstall]) {
//        self.declare = [QMMPrivacyDeclare new];
//        [self.declare showPrivacyDeclare];
//    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    } else if ([url.host isEqualToString:@"pay"]) { // 微信支付
        return [WXApi handleOpenURL:url delegate:[HYOnlinePayHelper shareHelper]];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    } else if ([url.host isEqualToString:@"pay"]) { // 微信支付
        return [WXApi handleOpenURL:url delegate:[HYOnlinePayHelper shareHelper]];
    } else {
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
        return result;
    }
    return YES;
}

- (void)dealZhiMaVertifyRst:(NSURL *)url {
    /*
     com.58cailu.qmm://register:8888/identification?biz_content={"biz_no":"ZM201812053000000333300548128268","passed":"true"}&sign=Di0aSwv8E9ZQR/hjos47tvbkWLe2sCad3pufFvW6QJ8InGVPVBXojH3X/zinDcpFtJzawRFf6/8ZaaEdTMyCFULyh9Ifky0DEmTW8naVo0UoaAOKuGPqm6TS1ixecDAARvlUtEXAziYFBh2NIPgJ0PlWnrgXuRjlqFfQbJj/HWPfAojrif8JwgMnfR9y66Oubb36rAx4S1g0is8lxHo0EAXQCpZ82Kp1HodtL9FRiNpVENv7+pDWYz6S5MA2Onl/LYX9TkzbWkrCvxhSjdMm4l//j0NSNZuOlQ3fj4WVpTrbtegzmLCoUtcqqLnA9AhmtNzZ+ZGOZwn0ONIJcEMsNQ==
     */
    // 芝麻认证结果回调, url截取参数后发送给服务端记录下来
    // 发送给服务端
    // 接口: zhimanotify
    // 入参: bizno, passed
    NSDictionary *resultDic = [self paramsOfUrl:url];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZHIMA_CER_RST_NOTIF_KEY object:resultDic];
}

- (NSDictionary *)paramsOfUrl:(NSURL *)url {
    NSArray *queries = [url.query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *rst = [NSMutableDictionary dictionaryWithCapacity:queries.count];
    for (NSString *s in queries) {
        NSArray *arr = [s componentsSeparatedByString:@"="];
        
        NSString *key = arr.firstObject;
        id value = [arr.lastObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (value) {
            NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];
            if (dict) {
                value = dict;
            }
            
        }
        
        [rst setObject:value ?: [NSNull null] forKey:key];
    }
    
    return rst.copy;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
