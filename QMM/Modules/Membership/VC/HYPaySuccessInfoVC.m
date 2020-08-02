//
//  HYPaySuccessInfoVC.m
//  SeeYou
//
//  Created by Joseph Koh on 2018/7/21.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYPaySuccessInfoVC.h"

@interface HYPaySuccessInfoVC ()

@end

@implementation HYPaySuccessInfoVC

+ (void)load {
    [self mapName:kModulePaySuccess withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.canBack = YES;
    [self initialize];
    [self setupSubviews];
    [self setupSubviewsLayout];
    [self bind];
}


#pragma mark - Action

//- (void)popBack {
//    if ([self.isFromProfile boolValue]) {
//        [YSMediator popToViewControllerName:@"kModuleProfile" animated:YES];
//    }
//    else {
//        [super popBack];
//    }
//}

#pragma mark - Bind

- (void)bind {
}


#pragma mark - Initialize

- (void)initialize {
    self.navigationItem.title = @"购买成功";
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
}

- (void)setupSubviewsLayout {
}


#pragma mark - Lazy Loading

@end
