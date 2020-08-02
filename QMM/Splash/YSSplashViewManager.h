//
//  YSSplashViewManager.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/27.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSSplashViewManager : NSObject


/// 显示启动引导页命令
@property (nonatomic, strong) RACCommand *showCommand;

/// 类方法,快速创建引导页对象
+ (instancetype)shareManager;

- (void)addSplashViewDismissObserver:(NSObject *)observer selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
