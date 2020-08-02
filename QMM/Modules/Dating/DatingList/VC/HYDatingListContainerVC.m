//
//  HYDatingListContainerVC.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "HYDatingListContainerVC.h"
#import "HYDatingListContentVC.h"
#import "QMMMenuModel.h"

@interface HYDatingListContainerVC ()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) HYDatingListContentVC *invateVC;
@property (nonatomic, strong) HYDatingListContentVC *occurrentVC;
@property (nonatomic, strong) HYDatingListContentVC *completeVC;
@property (nonatomic, strong) NSArray *menuList;

@end

@implementation HYDatingListContainerVC

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self bind];
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Bind

- (void)bind {
}


#pragma mark - Initialize

- (void)initialize {
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self.magicController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view setNeedsUpdateConstraints];
    
    [self.magicController.magicView reloadData];
}


#pragma mark - VTMagicViewDataSource

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titleList = [NSMutableArray array];
    for (QMMMenuModel *menu in self.menuList) {
        [titleList addObject:menu.title];
    }
    return titleList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:@"itemIdentifier"];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#7d7d7d"] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    QMMMenuModel *menuInfo = self.menuList[pageIndex];
    HYDatingListContentVC *vc = (HYDatingListContentVC *)menuInfo.contentVC;
    vc.status = [menuInfo.menuId integerValue];
    vc.type = self.type;
    vc.requestHandler = ^(NSInteger totalCnt) {
        if (pageIndex == 2) return;
        
        QMMMenuModel *menu = self.menuList[pageIndex];
        if (pageIndex == 0) {
            menu.title = (totalCnt > 0) ? [NSString stringWithFormat:@"邀请中(%zd)",totalCnt] : @"邀请中";
        }
        else if (pageIndex == 1) {
            menu.title = (totalCnt > 0) ? [NSString stringWithFormat:@"进行中(%zd)",totalCnt] : @"进行中";
        }
        
        [self.magicController.magicView reloadMenuTitles];
    };
    return vc;
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
}


#pragma mark - Lazy Loading

- (NSArray *)menuList {
    if (!_menuList) {
        _menuList = @[
                      [QMMMenuModel modelWithTitle:@"邀请中" contentVC:[HYDatingListContentVC new] andID:@"1"],
                      [QMMMenuModel modelWithTitle:@"进行中" contentVC:[HYDatingListContentVC new] andID:@"2"],
                      [QMMMenuModel modelWithTitle:@"已完成" contentVC:[HYDatingListContentVC new] andID:@"3"]
                      ];
    }
    return _menuList;
}

- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.sliderStyle = VTSliderStyleDefault;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.headerView.backgroundColor = [UIColor whiteColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        _magicController.magicView.navigationHeight = 50;
        _magicController.magicView.sliderHeight = 4;
        _magicController.magicView.sliderWidth = 55;
        _magicController.magicView.bubbleRadius = 2;
        _magicController.magicView.sliderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dating_separator_line"]];
        _magicController.magicView.separatorColor = [UIColor colorWithHexString:@"#E7E7E7"];
        _magicController.magicView.itemSpacing = 60.0 * SCREEN_WIDTH / 375.0;
        _magicController.magicView.againstStatusBar = NO;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.needPreloading = YES;
    }
    return _magicController;
}
@end

