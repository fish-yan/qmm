//
//  QMMMeetingVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMMeetingVC.h"
#import "QMMMeetingContentVC.h"
#import "QMMMeetingPopConfig.h"
#import "QMMMenuModel.h"

#define FILTER_BUTTON_WIDHT 58.0

@interface QMMMeetingVC ()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) QMMMeetingContentVC *commendVC;
@property (nonatomic, strong) QMMMeetingContentVC *latestVC;
@property (nonatomic, strong) QMMMeetingContentVC *nearestVC;
@property (nonatomic, strong) NSArray *menuList;
@property (nonatomic, strong) UIButton *subBtn;

@property (nonatomic, strong) QMMFilterRecordModel *filterInfo;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation QMMMeetingVC


#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstLoad = YES;
    [self initialize];
    [self bind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (self.isFirstLoad) {
        [[QMMMeetingPopConfig shareConfig] popWithActionHandle:nil];
        self.isFirstLoad = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


#pragma mark - Action

- (void)go2FilterView {
    
    @weakify(self);
    id callBack = ^(QMMFilterRecordModel *filters){
        @strongify(self);
        self.filterInfo = filters;
        QMMMeetingContentVC *vc = self.magicController.currentViewController;
        [vc updataWithFilterInfos:filters];
    };
    NSDictionary *params = @{
                             @"callBack": callBack,
                             @"filterInfo": self.filterInfo ?: [NSNull null]
                             };
    [YSMediator pushToViewController:kModuleFilter
                          withParams:params
                            animated:YES
                            callBack:NULL];
}


#pragma mark - Bind

- (void)bind {
}


#pragma mark - Initialize

- (void)initialize {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[QMMMeetingPopConfig shareConfig] configPopTime:3];
    
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self.magicController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat topMargin = IS_FULL_SCREEN_IPHONE ? 20 : 0;
        make.top.offset(topMargin);
        make.left.bottom.right.offset(0);
    }];
    
    [self.view setNeedsUpdateConstraints];
    [self setupRightItemButton];
    
    [_magicController.magicView reloadData];
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
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        menuItem.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.f];
        [menuItem.subviews[0] setContentMode:UIViewContentModeScaleAspectFit];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    QMMMenuModel *menuInfo = self.menuList[pageIndex];
    QMMMeetingContentVC *vc = (QMMMeetingContentVC *)menuInfo.contentVC;
    vc.type = [menuInfo.menuId integerValue];
    return vc;
}


#pragma mark - Setup Subviews

- (void)doSubBtnClickAction {
    [[QMMUIAssistant shareInstance].rootTabBarController setSelectedIndex:2];
}


- (void)setupRightItemButton {
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [filterBtn setImage:[[UIImage imageNamed:@"ic_nav_filter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
               forState:UIControlStateNormal];
    [[filterBtn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self go2FilterView];
    }];
    filterBtn.frame = CGRectMake(0, 0, FILTER_BUTTON_WIDHT, 20);
    [self.magicController.magicView setRightNavigatoinItem:filterBtn];
    
}

#pragma mark - Lazy Loading

- (NSArray *)menuList {
    if (!_menuList) {
        _menuList = @[
                      [QMMMenuModel modelWithTitle:@"推荐" contentVC:[QMMMeetingContentVC new] andID:@"1"],
                      [QMMMenuModel modelWithTitle:@"最新" contentVC:[QMMMeetingContentVC new] andID:@"2"],
                      [QMMMenuModel modelWithTitle:@"附近" contentVC:[QMMMeetingContentVC new] andID:@"3"]
                      ];
    }
    return _menuList;
}

- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0, FILTER_BUTTON_WIDHT, 0, 0);
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.sliderStyle = VTSliderStyleBubble;
        
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderHidden = NO;
        _magicController.magicView.sliderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_bg"]];
        _magicController.magicView.bubbleInset = UIEdgeInsetsMake(5, 10, 5, 10);
        _magicController.magicView.bubbleRadius = 15;
        _magicController.magicView.headerHeight = 64;
        _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.separatorHidden = YES;
        _magicController.magicView.needPreloading = NO;
    }
    return _magicController;
}

@end
