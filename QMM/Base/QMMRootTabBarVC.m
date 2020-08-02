//
//  QMMRootTabBarVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMRootTabBarVC.h"
#import "QMMRootTabBarVM.h"
#import "QMMUnreadMsgFetcher.h"

@interface QMMRootTabBarVC ()

@property(nonatomic ,strong) QMMRootTabBarVM *viewModel;
@property(nonatomic ,strong) UIImageView *backImageView;

@end

@implementation QMMRootTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self bind];
    
    [[QMMUnreadMsgFetcher shareInstance].unreadMsgCmd execute:nil];
    
}

-(void)bind{
    self.viewModel =[[QMMRootTabBarVM alloc] init];
    @weakify(self);
    [self.viewModel.configVCSignal subscribeNext:^(NSArray *  _Nullable x) {
        @strongify(self);
        self.viewControllers = x;
    }];
    
}

-(void) initialize {
    //去掉系统的线
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor: [UIColor whiteColor]];  // 修改tabBar颜色
    
    // 设置背景图片
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49.)];
    self.backImageView.backgroundColor=[UIColor whiteColor];
    self.backImageView.clipsToBounds = YES;
    [self.tabBar insertSubview:self.backImageView atIndex:0];
    
    // 顶部添加线条
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, 0, self.tabBar.frame.size.width, 0.5);
    line.backgroundColor = [UIColor bg0Color];
    [self.tabBar addSubview:line];
    [self.tabBar bringSubviewToFront:line];
}


/// 每次点击底部tabBar都请求消息数据
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //    NSUInteger indexOfTap = [tabBar.items indexOfObject:item];
    //    if (indexOfTap == TABBAR_ITEM_INDEX_MESSAGE) return;    // 数据在消息控制器 viewWillAppear中请求, 避免重复请求
    
    [[QMMUnreadMsgFetcher shareInstance].unreadMsgCmd execute:nil];
}

@end
