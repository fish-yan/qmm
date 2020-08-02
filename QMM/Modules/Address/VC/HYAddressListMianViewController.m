//
//  HYAddressListMianViewController.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYAddressListMianViewController.h"
#import "HYAddressListSubViewController.h"
#import "VTMagicController.h"
#import "HYAddressListViewModel.h"


static NSString *const ITEM_REUSE_ID = @"ITEM_REUSE_ID";

@interface HYAddressListMianViewController () <VTMagicViewDelegate, VTMagicViewDataSource>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) HYAddressListViewModel *viewModel;

@end

@implementation HYAddressListMianViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewModel = [HYAddressListViewModel new];
    [self prepareMagicController];
    [self bind];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.viewModel.fetTitleCmd execute:nil];
}


- (void)bind {
    @weakify(self);
    [[self.viewModel.fetTitleCmd.executionSignals switchToLatest]
     subscribeNext:^(HYAddressTitleModel *_Nullable x) {
        @strongify(self);
        [self.magicController.magicView reloadMenuTitles];
    }];
}

//*准备控制器*/
- (void)prepareMagicController {
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];

    _magicController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_magicController didMoveToParentViewController:self];
    [self.magicController.magicView reloadData];
}

#pragma mark - Lazy Loading

- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController                           = [[VTMagicController alloc] init];
        _magicController.magicView.layoutStyle     = VTLayoutStyleDivide;
        _magicController.magicView.switchStyle     = VTSwitchStyleDefault;
        _magicController.magicView.sliderHidden    = NO;
        _magicController.magicView.sliderExtension = 0;
        _magicController.magicView.sliderHeight    = 4;

        UIView *v = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:nil];
        [v.layer addSublayer:[self getgradientLayer:v]];
        [_magicController.magicView setSliderView:v];

        _magicController.magicView.sliderWidth = 80;

        _magicController.magicView.navigationHeight  = 50.f;
        _magicController.magicView.dataSource        = self;
        _magicController.magicView.delegate          = self;
        _magicController.magicView.menuScrollEnabled = YES;
        _magicController.magicView.needPreloading    = NO;
        _magicController.magicView.navigationColor   = [UIColor whiteColor];
        _magicController.magicView.separatorColor    = [UIColor colorWithHexString:@"#E7E7E7"];
    }
    return _magicController;
}

//#pragma mark - MagicController DataSource
//
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:self.viewModel.titleData.count];
    for (HYAddressTitleModel *model in self.viewModel.titleData) {
        [arrM addObject:model.title];
    }
    return arrM;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    UIButton *menuItem     = [magicView dequeueReusableItemWithIdentifier:ITEM_REUSE_ID];
    HYAddressTitleModel *m = self.viewModel.titleData[itemIndex];

    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#7D7D7D"] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:15 * (IS_IPHONE_5 ? 1 : (75.0 / 64))];

        UIView *badge            = [UIView viewWithBackgroundColor:[UIColor redColor] inView:menuItem.titleLabel];
        badge.tag                = 1024;
        CGFloat wh               = 8;
        badge.layer.cornerRadius = wh * 0.5;
        [badge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(5);
            make.top.offset(-3);
            make.size.mas_equalTo(CGSizeMake(wh, wh));
        }];
    }

    UIView *badge = [menuItem.titleLabel viewWithTag:1024];
    badge.hidden  = !m.hasUnread;

    return menuItem;
}


- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    NSString *REUSE_ID = [NSString stringWithFormat:@"REUSE_ID_%tu", pageIndex];

    HYAddressListSubViewController *vc = [magicView dequeueReusablePageWithIdentifier:REUSE_ID];
    if (!vc) {
        vc = [[HYAddressListSubViewController alloc] init];
    }

    vc.currentIndex = pageIndex;


    return vc;


    return nil;
}


- (CAGradientLayer *)getgradientLayer:(UIView *)vm {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame            = CGRectMake(0, 0, 80, 4);
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[
        (__bridge id) [UIColor colorWithHexString:@"#FF599E"].CGColor,
        (__bridge id) [UIColor colorWithHexString:@"#FFAB68"].CGColor
    ];

    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1, 0);

    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    return gradientLayer;
}


@end
