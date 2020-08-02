//
//  QMMUIAssistant.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMMUIAssistant : NSObject<UITabBarControllerDelegate>

@property(nonatomic ,strong ,readonly) UIWindow *window;
@property(nonatomic ,strong ,readonly) UINavigationController * rootNavigationController;
@property(nonatomic,strong ,readonly) UITabBarController * rootTabBarController;


/// 设置登录页面为根控制器, 执行时显示登陆页面
@property(nonatomic ,strong, readonly) RACCommand *setLoginVCASRootVCComand;

/// 设置tabbar控制器为根控制器, 执行后进入首页
@property (nonatomic, strong, readonly) RACCommand *setTabBarVCAsRootVCCommand;


@property (nonatomic, strong, readonly) RACCommand *setSplashAsRootVCCommand;

///判断用户是否交过钱去交钱
@property(nonatomic,strong ,readonly) RACCommand * setUploadMonayVCCommand;
@property(nonatomic ,strong,readonly) RACCommand * setVerfifyVCCommand;

/// 启动UI助手单例对象
+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
