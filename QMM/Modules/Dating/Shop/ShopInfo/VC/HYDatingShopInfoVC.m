//
//  HYDatingShopInfoVC.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/23.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYDatingShopInfoVC.h"
#import "HYDatingShopImageCell.h"

#import "HYDatingShopInfoVM.h"

static NSString *const kDatingShopCellReuseID = @"kDatingShopCellReuseID";

@interface HYDatingShopInfoVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *addressContent;

@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *localIcon;
@property (nonatomic, strong) UILabel *addressLabel;;
@property (nonatomic, strong) UIButton *telBtn;

@property (nonatomic, strong) UIView *transportationContent;
@property (nonatomic, strong) UILabel *transportationTitleLabel;
@property (nonatomic, strong) UILabel *transportationLabel;

@property (nonatomic, strong) UIView *actionContentView;
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) HYDatingShopInfoVM *viewModel;

@end

@implementation HYDatingShopInfoVC

+ (void)load {
    [self mapName:kModuleDatingShop withParams:nil];
}


#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self setupSubviewsLayout];
    [self bind];
    if (self.isSearch) {
        [self fetchShopInfo];
    }
    else {
        [self requestData];
    }
}


#pragma mark - Action

- (void)fetchShopInfo {
    @weakify(self);
    [YSProgressHUD showInView:self.view];
    
    [self.viewModel fetchShopInfo:self.shopName withResult:^(HYShopInfoModel *infoModel, NSError *error) {
        [YSProgressHUD hiddenHUD];
        
        @strongify(self);
        if (error) {
            [self.view showFailureViewOfType:WDFailureViewTypeError
                             withClickAction:^{
                                 @strongify(self);
                                 [self fetchShopInfo];
                             }];
            return;
        }
    
        [self.view hiddenFailureView];
        self.shopNameLabel.text = infoModel.name;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2lf元/人", infoModel.price];
        self.addressLabel.text = infoModel.address;
        [self.collectionView reloadData];
        
        [self requestData];
        
    }];
}

- (void)requestData {
    [self.viewModel fetchTrainsitionInfo];
}

- (void)doCallAction {
    if (self.infoModel.tel.length == 0) {
        [YSProgressHUD showTips:@"暂无商家号码"];
        return;
    }
    
    NSURL *telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.infoModel.tel]];
    if ([[UIApplication sharedApplication] canOpenURL:telUrl]) {
        [[UIApplication sharedApplication] openURL:telUrl];
    }
    else {
        NSLog(@"不能拨打号码");
    }
}

- (void)submitAction {
    if (self.selected) {
        NSString *address = [NSString stringWithFormat:@"%@ %@", self.infoModel.name, self.infoModel.address];
        QMMLocation *location = self.viewModel.infoModel.location;
        NSDictionary *callDict = @{
                                   @"address": address,
                                   @"latitude": @(location.coordinate.latitude),
                                   @"longitude": @(location.coordinate.longitude)
                                   };
        self.selected(callDict);
    }
    [YSMediator popToViewControllerName:kModuleDatingInfo animated:YES];
}

- (void)go2MapView {
    NSDictionary *params = @{
                             @"endLocation": self.viewModel.infoModel.location.coordinate ?: [NSNull null],
                             @"name": self.viewModel.infoModel.name ?: @"",
                             @"address": self.viewModel.infoModel.address ?: @"",
                             @"range": [NSString stringWithFormat:@"%.2lf", self.viewModel.infoModel.range]
                             };
    [YSMediator pushToViewController:kModuleMap
                          withParams:params
                            animated:YES
                            callBack:NULL];
}

#pragma mark - Bind

- (void)bind {
    RAC(self.transportationLabel, text) = RACObserve(self, viewModel.trainsitInfo);
}


#pragma mark - Initialize

- (void)initialize {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    self.viewModel = [HYDatingShopInfoVM new];
    self.viewModel.infoModel = self.infoModel;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.infoModel.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYDatingShopImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDatingShopCellReuseID forIndexPath:indexPath];
    NSString *imgUrl = self.infoModel.images[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                      placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    return cell;
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.width.equalTo(self.view);
        make.bottom.offset(-75);
    }];
    
    
    _contentView = [UIView viewWithBackgroundColor:nil inView:_scrollView];
    
    [self addAddressContentView];
    [self addTransportation];
}


- (void)setupSubviewsLayout {
    [self layoutAddressContent];
    [self layoutTransportationContent];

    
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);    // 一定要写
        make.width.equalTo(_scrollView);
        make.bottom.equalTo(_transportationContent).offset(20);
    }];
    
    
    // 搜索不现实操作按钮
    if ([self.isSearch boolValue]) {
        return;
    }
    
    self.actionContentView = ({
        UIView *v = [UIView viewWithBackgroundColor:[UIColor whiteColor]
                                             inView:self.view];
        v.layer.shadowOpacity = 0.1;
        v.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        v.layer.shadowOffset = CGSizeMake(0, -5);
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo(75);
        }];
        
        v;
    });
    
    
    
    self.submitBtn = ({
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(30, 15, SCREEN_WIDTH - 60, 45);
        [submitBtn setTitle:@"约Ta在这里见面" forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        submitBtn.layer.cornerRadius = 22.5;
        submitBtn.clipsToBounds = YES;
        [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionContentView addSubview:submitBtn];
        submitBtn;
    });
}


- (void)addAddressContentView {
    _addressContent = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:_contentView];
    
    _shopNameLabel = [UILabel labelWithText:self.viewModel.infoModel.name
                                  textColor:[UIColor colorWithHexString:@"#313131"]
                                   font:[UIFont systemFontOfSize:20]
                                     inView:_addressContent
                                  tapAction:^(UILabel *label, UIGestureRecognizer *tap) {
                                      
                                  }];
    _shopNameLabel.numberOfLines = 0;
    
    
    _priceLabel = [UILabel labelWithText:[NSString stringWithFormat:@"¥%.2lf元/人", self.viewModel.infoModel.price]
                               textColor:[UIColor colorWithHexString:@"#7D7D7D"]
                                font:[UIFont systemFontOfSize:15]
                                  inView:_addressContent
                               tapAction:NULL];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(135, 100);
    layout.minimumInteritemSpacing = 15;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"HYDatingShopImageCell" bundle:nil] forCellWithReuseIdentifier:kDatingShopCellReuseID];
    [_addressContent addSubview:_collectionView];
    
    
    @weakify(self);
    _localIcon = [UIImageView imageViewWithImageName:@"icon_location" inView:self.view];
    _addressLabel = [UILabel labelWithText:self.viewModel.infoModel.address
                                 textColor:[UIColor colorWithHexString:@"#43484D"]
                                  font:[UIFont systemFontOfSize:14]
                                    inView:_addressContent
                                 tapAction:^(UILabel *label, UIGestureRecognizer *tap) {
                                     @strongify(self);
                                     [self go2MapView];
                                 }];
    _addressLabel.userInteractionEnabled = YES;
    _addressLabel.numberOfLines = 0;
    
    _telBtn = [UIButton buttonWithNormalImgName:@"dating_call"
                                        bgColor:nil
                                         inView:_addressContent
                                         action:^(UIButton *btn) {
                                             @strongify(self);
                                             [self doCallAction];
                                         }];
}

- (void)addTransportation {
    _transportationContent = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:_contentView];
    
    _transportationTitleLabel = [UILabel labelWithText:@"交通引导"
                                             textColor:[UIColor colorWithHexString:@"#313131"]
                                              font:[UIFont systemFontOfSize:20]
                                                inView:_transportationContent
                                             tapAction:NULL];
    
    _transportationLabel = [UILabel labelWithText:@""
                                        textColor:[UIColor colorWithHexString:@"#43484D"]
                                         font:[UIFont systemFontOfSize:14]
                                           inView:_transportationContent
                                        tapAction:^(UILabel *label, UIGestureRecognizer *tap) {
                                            
                                        }];
    _transportationLabel.numberOfLines = 0;
}


- (void)layoutAddressContent {
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(20);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shopNameLabel.mas_bottom).offset(5);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_bottom).offset(15);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.mas_equalTo(100);
    }];
    
    [_localIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(_collectionView.mas_bottom).offset(20);
        make.size.mas_equalTo(_localIcon.image.size);
    }];
    
    
    [_telBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.equalTo(_collectionView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];
    
    UIView *v = [UIView viewWithBackgroundColor:[UIColor colorWithHexString:@"#E7E7E7"] inView:_addressContent];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_localIcon);
        make.size.mas_equalTo(CGSizeMake(2, 25));
        make.right.offset(-70);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_localIcon.mas_right).offset(10);
        make.top.equalTo(_localIcon);
        make.right.equalTo(v.mas_left).offset(-10);
    }];
    
    [_addressContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.equalTo(_addressLabel.mas_bottom).offset(20);
    }];
}

- (void)layoutTransportationContent {
    [_transportationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.left.offset(15);
    }];
    
    [_transportationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(_transportationTitleLabel.mas_bottom).offset(15);
    }];
    
    [_transportationContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressContent.mas_bottom).offset(10);
        make.left.right.offset(0);
        make.bottom.equalTo(_transportationLabel.mas_bottom).offset(20);
    }];
}


#pragma mark - Lazy Loading

@end
