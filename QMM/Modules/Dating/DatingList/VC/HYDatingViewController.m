//
//  HYDatingViewController.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "HYDatingViewController.h"
#import "HYDatingListContainerVC.h"
#import "QMMMenuModel.h"

@interface HYDatingViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSArray *menuList;

@end

@implementation HYDatingViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Initialize

- (void)initialize {
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self.magicController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view setNeedsUpdateConstraints];
    
    [_magicController.magicView reloadData];
}


#pragma mark - VTMagicViewDataSource

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return @[@"我发起的", [NSString stringWithFormat:@"%@发起的", OBJECT_CALL]];
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        //[menuItem setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [menuItem setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    QMMMenuModel *menuInfo = self.menuList[pageIndex];
    HYDatingListContainerVC *vc = (HYDatingListContainerVC *)menuInfo.contentVC;
    vc.type = [menuInfo.menuId integerValue];
    return vc;
    
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
  
}

#pragma mark - Lazy Loading

- (NSArray *)menuList {
    if (!_menuList) {
        _menuList = @[
                      [QMMMenuModel modelWithTitle:@"我发起的"
                                        contentVC:[HYDatingListContainerVC new]
                                            andID:@"1"],
                      [QMMMenuModel modelWithTitle:[NSString stringWithFormat:@"%@发起的", OBJECT_CALL]
                                        contentVC:[HYDatingListContainerVC new]
                                            andID:@"2"]
                      ];
    }
    return _menuList;
}


- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.sliderStyle = VTSliderStyleBubble;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderHidden = NO;
        _magicController.magicView.sliderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_tab_bg"]];
        _magicController.magicView.bubbleInset = UIEdgeInsetsMake(4, 12, 4, 12);
        _magicController.magicView.bubbleRadius = 13;
        _magicController.magicView.headerHeight = 64;
        _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.separatorColor = [UIColor colorWithHexString:@"#E7E7E7"];
        _magicController.magicView.needPreloading = NO;
    }
    return _magicController;
}
@end
