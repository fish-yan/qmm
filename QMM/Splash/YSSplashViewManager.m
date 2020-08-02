//
//  YSSplashViewManager.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/27.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSSplashViewManager.h"
#import "YSSplashVM.h"
#import "YSSplashView.h"

@interface YSSplashViewManager ()

@property (nonatomic, strong) YSSplashVM *viewModel;
@property (nonatomic, strong) YSSplashView *splashView;
@property (nonatomic, strong) NSObject *pObserver;
@property (nonatomic, assign) SEL pSelector;

@end

@implementation YSSplashViewManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static YSSplashViewManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[YSSplashViewManager alloc] init];
        [instance initialize];
    });
    return instance;
}

- (void)initialize {
    self.splashView = [[YSSplashView alloc] init];
    self.viewModel = [[YSSplashVM alloc] init];
    self.showCommand = self.splashView.showCmd;
    
    [self.splashView bindWithViewModel:self.viewModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postDismissNotif)
                                                 name:@"splash_view_hidden"
                                               object:nil];
}

- (void)postDismissNotif {
    if ([self.pObserver respondsToSelector:self.pSelector]) {
        IMP imp = [self.pObserver methodForSelector:self.pSelector];
        void(*func)(id, SEL) = (void *)imp;
        func(self.pObserver, self.pSelector);
    }
}

- (void)addSplashViewDismissObserver:(NSObject *)observer selector:(SEL)selector {
    self.pObserver = observer;
    self.pSelector = selector;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
