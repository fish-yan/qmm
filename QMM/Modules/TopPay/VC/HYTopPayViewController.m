//
//  HYTopPayViewController.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYTopPayViewController.h"
#import "HYTopPayAnimator.h"
#import "HYPopDataModel.h"

@interface PopActionView : UIView

@property (nonatomic, strong) UILabel *tlabel;
@property (nonatomic, strong) UILabel *vlabel;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) void (^action)(NSString *value);

+ (instancetype)actionViewWithTitle:(NSString *)title
                              value:(NSString *)value
                             action:(void (^)(NSString *value))action;

@end


@implementation PopActionView

+ (instancetype)actionViewWithTitle:(NSString *)title
                              value:(NSString *)value
                             action:(void (^)(NSString *value))action {
    PopActionView *v = [[PopActionView alloc] init];
    v.title          = title;
    v.value          = value;
    v.action         = action;
    return v;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubvews];
        [self setupSubvewsLayout];
        [self bind];
    }
    
    return self;
}

- (void)setupSubvews {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pop_top_bg"]];
    _tlabel              = [UILabel labelWithText:self.title
                                        textColor:[UIColor colorWithHexString:@"#313131"]
                                         font:[UIFont systemFontOfSize:18]
                                           inView:self
                                        tapAction:NULL];
    _vlabel = [UILabel labelWithText:self.value
                           textColor:[UIColor whiteColor]
                                font:[UIFont systemFontOfSize:18]
                              inView:self
                           tapAction:NULL];
    _vlabel.textAlignment      = NSTextAlignmentCenter;
    _vlabel.layer.cornerRadius = 45 * 0.5;
    _vlabel.clipsToBounds      = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:tap];
    @weakify(self);
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer *_Nullable x) {
        @strongify(self);
        if (self.action) {
            self.action(self.value);
        }
    }];
}

- (void)setupSubvewsLayout {
    [self.tlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(45);
        make.centerY.height.equalTo(self);
    }];
    
    [self.vlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.centerY.equalTo(self);
        make.width.mas_equalTo(95);
    }];
}

- (void)bind {
    RAC(self.tlabel, text) = RACObserve(self, title);
    
    @weakify(self);
    [RACObserve(self, title) subscribeNext:^(NSString *_Nullable x) {
        @strongify(self);
        if (x == nil) {
            self.hidden = YES;
        } else {
            self.hidden = NO;
        }
    }];
    RAC(self.vlabel, text) = RACObserve(self, value);
}

@end

@interface HYTopPayViewController ()

@property (nonatomic, strong) HYTopPayVM *viewModel;
@property (nonatomic, strong) HYTopPayAnimator *animator;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) HYPopDataModel *dataModel;

@property (nonatomic, strong) NSMutableArray *itemsArrM;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HYTopPayViewController


+ (void)load {
    [self mapName:kModuleTopDisplayPay withParams:nil];
}

#pragma mark - Life Circle

- (instancetype)init {
    if (self = [super init]) {
        self.animator               = [HYTopPayAnimator new];
        self.transitioningDelegate  = self.animator;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self setupSubviewsLayout];
    [self bind];
    [self requestProducts];
}

#pragma mark - Action

- (void)requestProducts {
    [YSProgressHUD showInView:self.view];
    [self.viewModel fetchDataWithResult:^(NSArray * _Nonnull dataArray, NSError * _Nonnull error) {
        if (error) {
            [YSProgressHUD showTips:error.localizedDescription];
            return;
        }
        [self.viewModel updateDataArray:dataArray];
        
        [YSProgressHUD hiddenHUD];
        [self resetupListData];
    }];
}

- (void)purchase {
    [YSProgressHUD showInView:self.view];
    [self.viewModel.fetchOrderIDCmd execute:nil];
}

#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [[self.viewModel.fetchOrderIDCmd.executionSignals switchToLatest] subscribeNext:^(id _Nullable x) {
        @strongify(self);
        [self.viewModel purchaseWithResult:^(NSString * _Nonnull receipt, NSError * _Nonnull error) {
            if (error) {
                [YSProgressHUD showTips:error.localizedDescription];
                return;
            }
            
            [self.viewModel.checkReceiptCmd execute:receipt];
        }];
    }];
    
    [self.viewModel.fetchOrderIDCmd.errors subscribeNext:^(NSError *_Nullable x) {
        [YSProgressHUD hiddenHUD];
        [YSProgressHUD showTips:x.localizedDescription];
    }];
    
    [[self.viewModel.fetchOrderIDCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
    }];
    
    //
    [[self.viewModel.checkReceiptCmd.executionSignals switchToLatest] subscribeNext:^(id _Nullable x) {
        [[QMMUserContext shareContext] fetchLatestUserinfoWithSuccessHandle:^(HYUserCenterModel *infoModel) {
            @strongify(self);
            [YSProgressHUD hiddenHUD];
            [[QMMUserContext shareContext] deployLoginActionWithUserModel:infoModel];
            if (self.payResult) {
                self.payResult(YES);
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
            
        }
                                                             failureHandle:^(NSError *error) {
                                                                 [YSProgressHUD hiddenHUD];
                                                             }];
        
        
    }];
    [self.viewModel.checkReceiptCmd.errors subscribeNext:^(NSError *_Nullable x) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        [YSProgressHUD showTips:@"购买凭证校验失败"];
        if (self.payResult) {
            self.payResult(NO);
        }
    }];
}

- (void)resetupListData {
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (idx >= self.itemsArrM.count) return;
        
        PopActionView *v = self.itemsArrM[idx];
        v.title          = obj[@"title"];
        v.value          = obj[@"price"];
    }];
}


#pragma mark - Initialize

- (void)initialize {
    self.view.backgroundColor = [UIColor clearColor];
    self.viewModel            = [HYTopPayVM new];
    
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    self.maskView       = [UIView viewWithBackgroundColor:[UIColor blackColor] inView:self.view];
    self.maskView.tag   = 1024;
    self.maskView.alpha = 0.4;
    self.maskView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.contentView                    = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:self.view];
    self.contentView.clipsToBounds      = YES;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.tag                = 1025;
    
    @weakify(self);
    self.closeBtn = [UIButton buttonWithNormalImgName:@"white_close"
                                              bgColor:nil
                                               inView:self.view
                                               action:^(UIButton *btn) {
                                                   @strongify(self);
                                                   [self dismissViewControllerAnimated:YES completion:NULL];
                                               }];
    self.closeBtn.tag = 1026;
    
    //
    _titleLabel = [UILabel labelWithText:self.viewModel.tips
                               textColor:[UIColor colorWithHexString:@"#313131"]
                           textAlignment:NSTextAlignmentCenter
                                    font:[UIFont systemFontOfSize:16]
                                  inView:_contentView
                               tapAction:NULL];
    _titleLabel.numberOfLines = 0;
}

- (void)setupSubviewsLayout {
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.mas_equalTo(320);
        make.width.mas_equalTo(315);
    }];
    
    //
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.offset(30);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    
    
    __block CGFloat offset_y = 30;
    @weakify(self);
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        
        PopActionView *v = [self cacheActionViewAtIndex:idx
                                              withTitle:obj[@"title"]
                                                  value:obj[@"price"]
                                                 action:^(NSString *value) {
                                                     @strongify(self);
                                                     self.viewModel.itemSelectedIdx = idx;
                                                     [self.viewModel.fetchOrderIDCmd execute:nil];
                                                 }];
        [self.contentView addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(offset_y);
            make.left.offset(25);
            make.right.offset(-25);
            make.height.mas_equalTo(45);
        }];
        
        offset_y += (45 + 10);
    }];
    
    //
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.contentView.mas_bottom).offset(10);
        make.width.height.mas_equalTo(24);
    }];
}


- (PopActionView *)cacheActionViewAtIndex:(NSInteger)idx
                                withTitle:(NSString *)title
                                    value:(NSString *)value
                                   action:(void (^)(NSString *value))action {
    if (self.itemsArrM.count == 0 || (self.itemsArrM.count && self.itemsArrM.count <= idx)) {
        PopActionView *v = [PopActionView actionViewWithTitle:title value:value action:action];
        [self.itemsArrM addObject:v];
        return v;
    }
    
    return self.itemsArrM[idx];
}

- (NSMutableArray *)itemsArrM {
    if (!_itemsArrM) {
        _itemsArrM = [NSMutableArray array];
    }
    return _itemsArrM;
}

@end
