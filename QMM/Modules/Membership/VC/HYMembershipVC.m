//
//  HYMembershipVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/23.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYMembershipVC.h"
#import "SDCycleScrollView.h"
#import "HYMembershipBtnView.h"
#import <StoreKit/StoreKit.h>
#import "HYMembershipVM.h"

#import "IAPHelper.h"

@interface HYMembershipVC () <SKPaymentTransactionObserver, SKProductsRequestDelegate>
@property (nonatomic, strong) UIView *bgView;


@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UIScrollView *productScroview;

@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) NSArray *desArray;

@property (nonatomic, strong) UIScrollView *diyueScroview;
@property (nonatomic, strong) UILabel *diyueDes;
@property (nonatomic, strong) NSArray *dingyuedesArray;

@property (nonatomic, strong) UILabel *tiplabel;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) HYMembershipVM *viewModel;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIScrollView *mScroview;

@property (nonatomic, strong) SKPaymentTransaction *transaction;

@property (nonatomic, strong) IAPHelper *iapHelper;
@property (nonatomic, strong) NSArray *productIdentifiers;

@end

@implementation HYMembershipVC

+ (void)load {
    [self mapName:kModuleMembership withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonArray = [NSMutableArray new];
    self.iapHelper   = [IAPHelper helper];


    self.desArray = @[
        @"免费试用3天(限前10万名)原价¥298.00",
        @"如果3个月不够，那就多加几个月",
        @"这么划算，如果1个月不够，那就再加2个月",
        @"想不想体验一下1个月脱单的感觉？",
    ];
    self.dingyuedesArray = @[@"试用说明：\n如需取消试用，请在试用到期前24小时在iTunes/"
                             @"AppleID设置管理中取消，到期前24小时内取消，将会收取订阅费用。"];
    [self initialize];
    [self setupSubviews];
    [self setupSubviewsLayout];
    [self bind];
    [self requestProducts];
}

- (NSArray *)sortPrice:(NSArray<SKProduct *> *)products {
    NSArray *arr = [products sortedArrayUsingComparator:^NSComparisonResult(SKProduct *_Nonnull obj1, SKProduct *_Nonnull obj2) {
        return [obj2.price compare:obj1.price];
    }];
    return arr;
}

- (void)requestProducts {
    [YSProgressHUD showInView:self.view];

    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    @weakify(self);
    [self.iapHelper fetchIAPProducts:self.productIdentifiers
                          withResult:^(NSArray<SKProduct *> *_Nonnull products, NSError *_Nonnull error) {
                              @strongify(self);
                              NSArray *ar    = [self sortPrice:products];
                              self.listArray = ar;

                              if (error) {
                                  [YSProgressHUD showTips:error.localizedDescription];
                                  [self.navigationController popViewControllerAnimated:YES];
                                  return;
                              }
                              if ([self.listArray count] == 0) {
                                  [YSProgressHUD showTips:@"暂无商品可以销售"];
                                  [self.navigationController popViewControllerAnimated:YES];
                                  return;
                              }

                              [YSProgressHUD hiddenHUD];


                              for (NSInteger i = 0; i < self.listArray.count; i++) {
                                  HYMembershipBtnView *v = [self.buttonArray objectAtIndex:i];
                                  SKProduct *product     = [self.listArray objectAtIndex:i];

                                  NSLog(@"SKProduct id：%@\t产品标题：%@\t描述信息：%@ \t价格：%@",
                                        product.productIdentifier,
                                        product.localizedTitle,
                                        product.localizedDescription,
                                        product.price);

                                  v.title                            = product.localizedTitle;
                                  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                                  [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
                                  [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                                  [numberFormatter setLocale:product.priceLocale];

                                  NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];

                                  if (i == 0 && [formattedPrice containsString:@"¥"]) {
                                      formattedPrice = @"¥0.00";
                                  }

                                  v.subTitle = formattedPrice;
                              }

                          }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cycleScrollView adjustWhenControllerViewWillAppera];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.cycleScrollView makeScrollViewScrollToIndex:self.showIdx];
}

#pragma mark - Bind

- (void)bind {
    @weakify(self);

    [[self.viewModel.getOrderid.executionSignals switchToLatest] subscribeNext:^(id _Nullable x) {
        [YSProgressHUD hiddenHUD];
        @strongify(self);
        [YSProgressHUD showInView:self.view];

        NSString *identifier = self.productIdentifiers[self.selectIndex];
        [self.iapHelper
        purchaseIdentrifier:identifier
                withRestult:^(NSString *_Nonnull receipt, NSError *_Nonnull error) {
                    @strongify(self);
                    if (error) {
                        [YSProgressHUD showTips:error.localizedDescription];
                        return;
                    }

                    [self.viewModel.doRaccommand execute:@{ @"receipt_data": receipt, @"id": self.viewModel.orderid }];

                }];

    }];
    [self.viewModel.getOrderid.errors subscribeNext:^(NSError *_Nullable x) {
        [YSProgressHUD hiddenHUD];
        [YSProgressHUD showTips:x.localizedDescription];
    }];

    [[self.viewModel.getOrderid.executing skip:1] subscribeNext:^(NSNumber *_Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
    }];


    [[self.viewModel.doRaccommand.executionSignals switchToLatest] subscribeNext:^(id _Nullable x) {

        [[QMMUserContext shareContext] fetchLatestUserinfoWithSuccessHandle:^(HYUserCenterModel *infoModel) {
            [YSProgressHUD hiddenHUD];
            [[QMMUserContext shareContext] deployLoginActionWithUserModel:infoModel];
            [YSMediator pushToViewController:@"kModulePaySuccess"
                                  withParams:@{
                                      @"isFromProfile": @1
                                  }
                                    animated:YES
                                    callBack:NULL];
        }
        failureHandle:^(NSError *error) {
            [YSProgressHUD hiddenHUD];
        }];


    }];
    [self.viewModel.doRaccommand.errors subscribeNext:^(NSError *_Nullable x) {
        [YSProgressHUD hiddenHUD];
        [YSProgressHUD showTips:@"购买凭证校验失败"];


    }];
}


#pragma mark - Initialize

- (void)initialize {
    self.navigationItem.title = @"会员中心";
    self.viewModel            = [HYMembershipVM new];
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    self.bgView = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:self.view];
    @weakify(self);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.top.equalTo(self.view.mas_top).offset(49);
        make.bottom.equalTo(self.view.mas_bottom).offset(-94);
    }];


    self.mScroview = [[UIScrollView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:self.mScroview];

    CGFloat bgViewH     = (SCREEN_WIDTH) / 375.0 * 343.0;
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH), bgViewH)];
    bgView.image        = [self gradientImageOfSize:CGRectMake(0, 0, bgView.size.width, bgView.size.height)];
    [self.mScroview addSubview:bgView];
    NSMutableArray *imgs = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < 7; i++) {
        [imgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"vip%d", i + 1]]];
    }
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:bgView.frame imageNamesGroup:imgs];
    self.cycleScrollView.backgroundColor            = [UIColor clearColor];
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeCenter;
    self.cycleScrollView.autoScroll                 = YES;
    self.cycleScrollView.autoScrollTimeInterval     = 5;
    [self.mScroview addSubview:self.cycleScrollView];


    self.productScroview = [[UIScrollView alloc] initWithFrame:CGRectMake(25, bgViewH, SCREEN_WIDTH - 16 - 50, 115)];
    self.productScroview.contentSize = CGSizeMake(500, 115);
    [self.mScroview addSubview:self.productScroview];

    CGFloat x                 = 0;
    CGFloat y                 = 20;
    CGFloat w                 = 100;
    CGFloat h                 = 90;
    HYMembershipBtnView *btn0 = [HYMembershipBtnView viewWithTitle:@"高级会员试用"
                                                          subTitle:@"¥0.00"
                                                            action:^{
                                                                @strongify(self);
                                                                [self buttonClick:0];
                                                            }];
    btn0.frame              = CGRectMake(x, y, w, h);
    btn0.layer.cornerRadius = 5;
    [self.productScroview addSubview:btn0];
    [self.buttonArray addObject:btn0];

    //
    HYMembershipBtnView *btn1 = [HYMembershipBtnView viewWithTitle:@"6个月会员"
                                                          subTitle:@"¥168.00"
                                                            action:^{
                                                                @strongify(self);
                                                                [self buttonClick:1];
                                                            }];

    btn1.frame              = CGRectMake(110, y, w, h);
    btn1.layer.cornerRadius = 5;
    [self.productScroview addSubview:btn1];
    [self.buttonArray addObject:btn1];

    //
    HYMembershipBtnView *btn2 = [HYMembershipBtnView viewWithTitle:@"3个月会员"
                                                          subTitle:@"¥98.00"
                                                            action:^{
                                                                @strongify(self);
                                                                [self buttonClick:2];
                                                            }];

    btn2.frame              = CGRectMake(220, y, w, h);
    btn2.layer.cornerRadius = 5;
    [self.productScroview addSubview:btn2];
    [self.buttonArray addObject:btn2];


    //
    HYMembershipBtnView *btn3 = [HYMembershipBtnView viewWithTitle:@"1个月会员"
                                                          subTitle:@"¥38.00"
                                                            action:^{
                                                                @strongify(self);
                                                                [self buttonClick:3];
                                                            }];

    btn3.frame              = CGRectMake(330, y, w, h);
    btn3.layer.cornerRadius = 5;

    [self.productScroview addSubview:btn3];
    [self.buttonArray addObject:btn3];


    self.diyueScroview                 = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.diyueScroview.backgroundColor = [UIColor colorWithHexString:@"0xF5F5F5"];

    [self.mScroview addSubview:self.diyueScroview];
    [self.diyueScroview mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.top.equalTo(self.productScroview.mas_bottom).offset(10);
        make.height.equalTo(@45);
    }];

    self.diyueDes = [UILabel labelWithText:@"订"
                                           @"阅会员服务说明\n付款：用户确认购买并付款后记入iTunes账户；\n取消续订：如"
                                           @"需取消续订，请在当前订阅周期到期前24小时以前，手动在iTunes/"
                                           @"AppleID设置管理中关闭自动续费功能，到期前24小时内取消，将会收取订阅费用;"
                                           @"\n续费：苹果iTunes账户会在到期前24小时内扣费，扣费成功后订阅周期顺延一个"
                                           @"订阅周期;\n详见《我想见你服务协议》和《我想见你订阅协议》"
                                 textColor:[UIColor tc31Color]
                                  font:[UIFont systemFontOfSize:12]
                                    inView:self.diyueScroview
                                 tapAction:nil];
    CGSize size = [self.diyueDes.text sizeWithFont:[UIFont systemFontOfSize:12.0]
                                 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT)];
    self.diyueDes.numberOfLines = 0;

    self.diyueDes.frame            = CGRectMake(4, 5, SCREEN_WIDTH - 40, size.height + 35);
    self.diyueScroview.contentSize = CGSizeMake(SCREEN_WIDTH - 40, size.height + 10 + 35);


    self.tiplabel = [UILabel labelWithText:self.desArray[0]
                                 textColor:[UIColor colorWithHexString:@"#313131"]
                                  font:[UIFont systemFontOfSize:12]
                                    inView:self.mScroview
                                 tapAction:nil];
    self.tiplabel.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.tiplabel.textAlignment   = NSTextAlignmentCenter;
    [self.tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView.mas_left).offset(19);
        make.right.equalTo(self.bgView.mas_right).offset(-19);
        make.top.equalTo(self.diyueScroview.mas_bottom).offset(10);
        make.height.equalTo(@40);
    }];


    UIButton *commitButton = [UIButton buttonWithTitle:@""
                                            titleColor:[UIColor whiteColor]
                                                  font:[UIFont systemFontOfSize:16]
                                         normalImgName:nil
                                               bgColor:[UIColor whiteColor]
                                                inView:self.mScroview
                                                action:^(UIButton *btn) {
                                                    @strongify(self);
                                                    [self commitSure];
                                                }];
    [commitButton.layer setMasksToBounds:YES];
    [commitButton.layer setCornerRadius:22.5];
    [commitButton setBackgroundImage:[self gradientImageOfSize:CGRectMake(0, 0, SCREEN_WIDTH - 60, 45)]
                            forState:UIControlStateNormal];
    [commitButton setBackgroundImage:[self gradientImageOfSize:CGRectMake(0, 0, SCREEN_WIDTH - 60, 45)]
                            forState:UIControlStateHighlighted];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.top.equalTo(self.tiplabel.mas_bottom).offset(23);
        make.height.equalTo(@45);
    }];

    self.mScroview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 100 + 100);


    UILabel *serverprotcol = [UILabel labelWithText:@"我想见你服务协议"
                                          textColor:[UIColor colorWithHexString:@"#3DA8F5"]
                                               font:[UIFont systemFontOfSize:14]
                                             inView:self.mScroview
                                          tapAction:^(UILabel *label, UIGestureRecognizer *tap) {
                                              
                                              [YSMediator openURL:@"https://www.huayuanvip.com/help/WXNVIPprotcol.html"];
                                          }];
    
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};

    NSMutableAttributedString *attribtStr =
    [[NSMutableAttributedString alloc] initWithString:serverprotcol.text attributes:attribtDic];

    serverprotcol.attributedText = attribtStr;


    serverprotcol.textAlignment = NSTextAlignmentCenter;
    UILabel *dingyueprotcol = [UILabel labelWithText:@"我想见你订阅协议"
                                           textColor:[UIColor colorWithHexString:@"#3DA8F5"]
                                                font:[UIFont systemFontOfSize:14]
                                              inView:self.mScroview
                                           tapAction:^(UILabel *label, UIGestureRecognizer *tap) {
                                               [YSMediator openURL:@"https://www.huayuanvip.com/help/dingyueprotcol.html"];
                                           }];
    
    dingyueprotcol.textAlignment = NSTextAlignmentCenter;
    NSDictionary *attribtDic1 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr1 =
    [[NSMutableAttributedString alloc] initWithString:dingyueprotcol.text attributes:attribtDic1];
    dingyueprotcol.attributedText = attribtStr1;

    [serverprotcol mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.equalTo(@(SCREEN_WIDTH / 2));
        make.height.equalTo(@40);
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(commitButton.mas_bottom).offset(20);
    }];
    [dingyueprotcol mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.equalTo(@(SCREEN_WIDTH / 2));
        make.height.equalTo(@40);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(commitButton.mas_bottom).offset(20);
    }];


    [self setBorderSetting:0];
    //
}


- (UIImage *)gradientImageOfSize:(CGRect)bounds {
    CAGradientLayer *layer = [CAGradientLayer layer];
    UIColor *color0        = [UIColor colorWithHexString:@"#FF599E"];
    UIColor *color1        = [UIColor colorWithHexString:@"#FFAB68"];
    layer.colors           = @[(id) color0.CGColor, (id) color1.CGColor];
    layer.startPoint       = CGPointMake(0, 0.5);
    layer.endPoint         = CGPointMake(1, 0.5);
    layer.frame            = bounds;
    // layer.locations = @[@(0.0f), @(1)];

    UIGraphicsBeginImageContext(layer.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setupSubviewsLayout {
}

- (void)buttonClick:(NSInteger)Selectindex {
    self.selectIndex = Selectindex;
    [self setBorderSetting:Selectindex];
    self.tiplabel.text = self.desArray[Selectindex];
}

- (void)commitSure {
    [self.iapHelper finishUncomplatePurchase];

    SKProduct *product = [self.listArray objectAtIndex:self.selectIndex];
    if (product == nil) return;

    [self.viewModel.getOrderid execute:@{ @"no": product.productIdentifier }];
}

- (void)setBorderSetting:(NSInteger)index {
    for (int i=0; i<self.buttonArray.count; i++)
    {
        HYMembershipBtnView *view =[self.buttonArray objectAtIndex:i];
        [view.layer setMasksToBounds:YES];
        [view.layer setBorderColor:[UIColor colorWithHexString:@"#f5f5f5"].CGColor];
        if(index ==i)
        {
            [view.layer setBorderColor:[UIColor colorWithHexString:@"#FF5D9C"].CGColor];
        }
    }
    
}


#pragma mark - Lazy Loading

- (NSArray *)productIdentifiers {
    if (!_productIdentifiers) {
        _productIdentifiers = @[@"imissyou000", @"imissyou003", @"imissyou002", @"imissyou001"];
    }
    return _productIdentifiers;
}
@end
