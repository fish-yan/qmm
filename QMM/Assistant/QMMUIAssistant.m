//
//  QMMUIAssistant.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMUIAssistant.h"
#import "YSProjectBaseModule.h"
#import "QMMRootTabBarVC.h"

#define LOGIN_VC @"QMMLoginMainVC"

#define SPLASH_VC @"QMMSplashViewController"
//#define LOGIN_VC @"QMMSupplementaryAvatarVC"

@implementation QMMUIAssistant


+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static QMMUIAssistant *instance =nil;
  
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance initialize];
        [instance observerLoginStatus];
    });
    
    return instance;
}


-(void)initialize {
    @weakify(self);
    
    self->_window = [self keyWindow];
    self->_setLoginVCASRootVCComand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        UIViewController *loginVC = [[NSClassFromString(LOGIN_VC) alloc] init];
        if (self.rootNavigationController.presentedViewController) {
            [self.rootNavigationController dismissViewControllerAnimated:NO completion:^{
                
            }];
            @strongify(self);
            self->_rootNavigationController = [self navControllerWithRootViewController:loginVC];
            self.window.rootViewController = self.rootNavigationController;
            [self->_rootNavigationController setNavigationBarHidden:NO];
        }
        else {
            self->_rootNavigationController = [self navControllerWithRootViewController:loginVC];
            self.window.rootViewController = self.rootNavigationController;
            [self->_rootNavigationController setNavigationBarHidden:NO];
        }
        return [RACSignal empty];
    }];
    
    self->_setTabBarVCAsRootVCCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        self->_rootTabBarController = [self tabBarController];
        self.rootTabBarController.delegate = self;
        self->_rootNavigationController = [self navControllerWithRootViewController:self.rootTabBarController];
        self.window.rootViewController = self.rootNavigationController;
        
        [self->_rootNavigationController setNavigationBarHidden:YES];
        return [RACSignal empty];
    }];
    
    self->_setSplashAsRootVCCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        self.window.rootViewController = [NSClassFromString(SPLASH_VC) new];
        return [RACSignal empty];
    }];
    
    
    
    self->_setVerfifyVCCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        ZhiMaCreditVertifyVC *vc = [ZhiMaCreditVertifyVC new];
        vc.isFromLoginView = NO;
        self->_rootNavigationController = [self navControllerWithRootViewController:vc];
        
        self.window.rootViewController = self.rootNavigationController;
        [self->_rootNavigationController setNavigationBarHidden:NO];
        return [RACSignal empty];
    }];
}


- (void)setupLoadNavRootVC:(NSString *)vcName {
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    self->_rootNavigationController = [self navControllerWithRootViewController:vc];
    self.window.rootViewController = self.rootNavigationController;
    [self->_rootNavigationController setNavigationBarHidden:NO];
}

///// 监听用户不同登陆操作通知: 登陆成功 / 退出登陆 / 被踢
- (void)observerLoginStatus {
    @weakify(self);
    
    // 监听用户登陆成功的通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LOGIN_NOTIF_KEY object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification * _Nullable x) {
         @strongify(self);
         
         [self.setTabBarVCAsRootVCCommand execute:@1];
     }];
    
    // 监听用户退出的通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:LOGOUT_NOTIF_KEY object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification * _Nullable x) {
         @strongify(self);
         [[QMMUserContext shareContext] deployKickOutAction];
         [self.setLoginVCASRootVCComand execute:@1];
     }];
    
    
    // 监听用户被踢,Token过期的通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"LOG_KICK_OUT_NOTIF_KEY" object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification * _Nullable x) {
         @strongify(self);
         // 用户被踢后:
         // 1. 更新用户登录状态为 NO(清楚token信息)
         // 2. 展示 登陆界面
         //[[HYUserContext shareContext] deployKickOutAction];
         [self.setLoginVCASRootVCComand execute:@1];
     }];
}


- (UIWindow *)keyWindow {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    UIViewController *loginVC = [[NSClassFromString(LOGIN_VC) alloc] init];
    self->_rootNavigationController = [self navControllerWithRootViewController:loginVC];
    window.rootViewController = self.rootNavigationController;
    [window makeKeyAndVisible];
    return window;
}

- (__kindof YSNavigationController *)navControllerWithRootViewController:(__kindof UIViewController *)vc {
    if (vc == nil) {
        vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
    }
    return [[YSNavigationController alloc] initWithRootViewController:vc];;
}

- (__kindof UITabBarController *)tabBarController {
    return [[QMMRootTabBarVC alloc] init];
}


@end
