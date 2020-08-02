//
//  QMMLaunchDeployer.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMLaunchDeployer.h"
#import "QMMUIAssistant.h"
#import "YSSplashViewManager.h"

static NSString *const kAppVersion = @"appVersion";

@implementation QMMLaunchDeployer


- (UIWindow *)deplyUI {
    QMMUIAssistant *assistant = [QMMUIAssistant shareInstance];
    QMMUserContext *usercCtx = [QMMUserContext shareContext];
    AppContext *appCtx = [AppContext shareContext];
    
//[assistant.setTabBarVCAsRootVCCommand execute:nil];
    if (!usercCtx.login) {
        [assistant.setLoginVCASRootVCComand execute:nil];
    }
    else {
//        if (usercCtx.userModel.pvon) {
//
//            return assistant.window;
//        }
        
        /* 是否信息完整
         1:基础信息不完善;
         2:未上传头像, 需要上传头像;
         3:注册过,直接登录,
         4: 没有芝麻认证,没有支付,
         5:没有芝麻认证, 但是有支付,
         6有芝麻认证, 但没有支付
         */ 
        switch (usercCtx.userModel.iscomplete) {
//            case UserInfoTypeComplete:{
//                [assistant.setTabBarVCAsRootVCCommand execute:nil];
//                break;
//            }
            case UserInfoTypeNoCertifiedHadPay:
                [assistant.setTabBarVCAsRootVCCommand execute:nil];
                break;
            case UserInfoTypeComplete:
            case UserInfoTypeNoCertifiedNoPay:
            case UserInfoTypeHadCertifiedNoPay: {
                UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
                assistant.window.rootViewController = nav;
//                [assistant.setTabBarVCAsRootVCCommand execute:nil];
                break;
            }
//            case UserInfoTypeHadCertifiedNoPay:
//            case UserInfoTypeRegister:
//            case UserInfoTypeNoCertifiedNoPay:
//                [assistant.setLoginVCASRootVCComand execute:nil];
//                break;
            default:
                [assistant.setLoginVCASRootVCComand execute:nil];
                break;
        }
    }

    if (appCtx.isNewUpdate) {
        [[YSSplashViewManager shareManager].showCommand execute:nil];
    }

    
    return assistant.window;
}


@end
