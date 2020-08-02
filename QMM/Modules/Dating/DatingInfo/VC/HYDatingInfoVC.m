//
//  HYDatingInfoVC.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "HYDatingInfoVC.h"
#import "HYDatingInfoCell.h"
#import "HYDatingInfoVM.h"
#import "YSPickerView.h"
#import "YSPickerViewData.h"
#import "HYDatingMarginHelper.h"

// 申请操作: 同意, 拒绝1
// 申请取消操作: 同意3, 拒绝4
typedef NS_ENUM(NSInteger, ActionType) {
    ActionTypeApplication,
    ActionTypeCancel
};

@interface HYDatingInfoVC ()

@property (nonatomic, strong) HYDatingInfoVM *viewModel;
@property (nonatomic, strong) UIView *actionContentView;
@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *signinBtn;
@property (nonatomic, strong) UIButton *inviteBtn;
@property (nonatomic, strong) UIButton *acceptBtn;
@property (nonatomic, strong) UIButton *rejectBtn;

@property (nonatomic, assign) ActionType actonType;

@property (nonatomic, assign) BOOL isAcceptCancleAction;

@end

@implementation HYDatingInfoVC

+ (void)load {
    [self mapName:kModuleDatingInfo withParams:nil];
}


#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([self.appointmentstatus boolValue]) {
        [self requestData];
    }
}


#pragma mark - Action

- (void)requestData {
    [self.viewModel.requestCmd execute:nil];
}

- (void)go2RuleView {
    [YSMediator pushToViewController:kModuleDatingRule
                          withParams:nil
                            animated:YES
                            callBack:NULL];
}

- (void)inviteDate {
    if (self.viewModel.inviteAddress.length == 0
        || self.viewModel.inviteTime.length == 0) {
        [YSProgressHUD showTips:@"请填写约会信息"];
        return;
    }
    [self.viewModel.inviteDateCmd execute:nil];
}

- (void)cancelDate {
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"确定要撤销当前的约会申请吗?"
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self.viewModel.cancleDateCmd execute:nil];
                                                      }]];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)acceptDate {
    if (self.actonType == ActionTypeApplication) {
        self.isAcceptCancleAction = NO; // 标记是否是同意取消操作
        //[self.viewModel.acceptDateCmd execute:nil];
        [self go2datingSubmitVC];
    } else {
        self.isAcceptCancleAction = YES;
        [self.viewModel.changeDateCmd execute:@3];
    }
}
 // 1:接收方拒绝发起的约会,2:取消发起的约会,3:同意取消发起的约会,4:拒绝取消约会
- (void)rejectData {
    self.isAcceptCancleAction = NO; // 标记是否是同意取消操作
    
    if (self.actonType == ActionTypeApplication) {
        [self.viewModel.changeDateCmd execute:@1];
    } else {
        [self.viewModel.changeDateCmd execute:@4];
    }
}

- (void)signinAction {
    if (self.viewModel.inSignRange == NO) {
        [self showActionWithTitle:nil
                          message:@"检测到你的当前位置与【约会地点】相距距离超过 1 公里，请到达【约会地点】地点后再【签到赴约】"
                      actionTitle:nil
                           action:NULL];
        return;
    }
    [self.viewModel.signinDateCmd execute:nil];
}

// 去保证金确认页面
- (void)go2datingSubmitVC {
    NSDictionary *params = @{@"dateId": self.viewModel.dateID ?: @""};
    [YSMediator pushToViewController:@"kModuleDatingSubmit"
                          withParams:params
                            animated:YES
                            callBack:NULL];
}


- (void)go2userInfoView {
    NSDictionary *params = @{@"uid": self.uid ?: @""};
    [YSMediator pushToViewController:kModuleUserInfo
                          withParams:params
                            animated:YES
                            callBack:NULL];
}

// 设置状态是有约会的
- (void)changeStatusIsHasDating {
    self.appointmentstatus = @1;
}

- (void)showActionWithTitle:(NSString *)title
                    message:(NSString *)msg
                actionTitle:(NSString *)actionTitle
                     action:(void(^)(void))doAction {
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:title
                                        message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:actionTitle ?: @"我知道了"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          if (doAction) {
                                                              doAction();
                                                          }
                                                      }]];
    [self presentViewController:alertController animated:YES completion:NULL];
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    // -----------
    [[self.viewModel.requestCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
    }];

    [[self.viewModel.requestCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        
        [self.view hiddenFailureView];
        [self.tableView reloadData];
    }];

    [self.viewModel.requestCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
        
        @strongify(self);
        [self.view showFailureViewOfType:WDFailureViewTypeError
                         withClickAction:^{
                             @strongify(self);
                             [self requestData];
                         }];
    }];
    
    // ----------
    [[self.viewModel.inviteDateCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        [self changeStatusIsHasDating];
        [self go2datingSubmitVC];
    }];
    
    // ---------
    [[[[[[self.viewModel.inviteDateCmd.executing skip:1]
        merge:[self.viewModel.cancleDateCmd.executing skip:1]]
       merge:[self.viewModel.changeDateCmd.executing skip:1]]
      merge:[self.viewModel.acceptDateCmd.executing skip:1]]
      merge:[self.viewModel.signinDateCmd.executing skip:1]]
     subscribeNext:^(id  _Nullable x) {
         @strongify(self);
         if ([x boolValue]) {
             [YSProgressHUD showInView:self.view];
         }
     }];
    
    [[self.viewModel.signinDateCmd.executionSignals switchToLatest]
     subscribeNext:^(NSString * _Nullable x) {
         @strongify(self);
         [YSProgressHUD showTips:x];
         // 重新拉状态数据
         [self requestData];
     }];
    
    

    [[[[self.viewModel.cancleDateCmd.executionSignals switchToLatest]
       merge:[self.viewModel.changeDateCmd.executionSignals switchToLatest]]
      merge:[self.viewModel.signinDateCmd.executionSignals switchToLatest]]
     subscribeNext:^(id  _Nullable x) {
         @strongify(self);
         [YSProgressHUD hiddenHUD];
         if (self.isAcceptCancleAction) {
             [self showActionWithTitle:@"约会取消成功"
                               message:@"您的约会保证金 199 元已经退回至您的钱包-收益账户，请查收"
                           actionTitle:nil
                                action:NULL];
             self.isAcceptCancleAction = NO;    // 标记不再是同意取消操作
         }
         // 重新拉状态数据
         [self requestData];
     }];
    
    [[self.viewModel.acceptDateCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self changeStatusIsHasDating];
        [self go2datingSubmitVC];
    }];
    
    [[[[[self.viewModel.inviteDateCmd.errors
        merge:self.viewModel.cancleDateCmd.errors]
       merge:self.viewModel.changeDateCmd.errors]
      merge:self.viewModel.acceptDateCmd.errors]
      merge:self.viewModel.signinDateCmd.errors]
     subscribeNext:^(NSError * _Nullable x) {
         [YSProgressHUD showTips:x.localizedDescription];
     }];
    

    [RACObserve(self.viewModel, type) subscribeNext:^(NSNumber * _Nullable x) {
        [self resetupNeedDisplayCancleBtn:NO];

        DatingStatusType type = [x integerValue];
        self.actionContentView.hidden = NO;
        switch (type) {
            case DatingStatusTypeDidNotPay:  {// 未交保证金
                [self addGo2PayBtnInView:self.actionContentView];
                break;
            }
            case DatingStatusTypeRejected:  // 被拒绝,什么都不显示
            case DatingStatusTypeWaitAcceptCancel: // 自己取消,等待同意请求
            case DatingStatusTypeHadSignin: // 已经签到
            case DatingStatusTypeClosed:    // 关闭状态, 什么都不显示
            case DatingStatusTypeComplete: { // 完成状态
                self.actionContentView.hidden = YES;
                break;
            }
            case DatingStatusTypeWaitAccept: {// 等待对方确认
                [self addCancleBtnInView:self.actionContentView];
                break;
            }
            case DatingStatusTypeGetInvite: {// 收到邀请
                self.actonType = ActionTypeApplication;
                [self addActionBtnInView:self.actionContentView isCancelRequest:NO];
                break;
            }
            case DatingStatusTypeDatingWaiting: {// 约会中 24小时前,等待约会, 可取消
                // right item  取消约会
                [self addTipsInButtonView:self.actionContentView];
                [self resetupNeedDisplayCancleBtn:YES];
                break;
            }
            case DatingStatusTypeGetCancelRequest: {// 接收到取消请求
                self.actonType = ActionTypeCancel;
                [self addActionBtnInView:self.actionContentView isCancelRequest:YES];
                break;
            }
            case DatingStatusTypeCanSignin: {// 约会中, 约定时间前后一小时,可签到状态
                [self addSignInBottomView:self.actionContentView];
                break;
            }
            case DatingStatusTypeInvite: {// 发起约会
                [self addInvateBtnInView:self.actionContentView];
                break;
            }
                
            default:
                break;
        }
    }];
    
    
    [RACObserve(self.viewModel, signTips) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.tipsLabel.text = x;
    }];
}


#pragma mark - Initialize

- (void)initialize {
    self.viewModel = [HYDatingInfoVM new];
    
    self.viewModel.uid = self.uid;
    self.viewModel.dateID = self.dateID;
    
    self.navigationItem.title = self.viewModel.title;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
}


#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYDatingInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID"];
    if (!cell) {
        cell = [[HYDatingInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseID"];
    }
    cell.cellModel = self.viewModel.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    HYDatingInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID"];
    if (!cell) return 50;
    
    return [tableView fd_heightForCellWithIdentifier:@"reuseID" configuration:^(HYDatingInfoCell *cell) {
        @strongify(self);
        cell.cellModel = self.viewModel.dataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYDatingInfoCellModel *m = self.viewModel.dataArray[indexPath.row];
    if ([m.title isEqualToString:@"约会状态"]) {
        [YSMediator pushToViewController:kModuleDatingLine
                              withParams:@{@"dateId": self.viewModel.dateID}
                                animated:YES
                                callBack:NULL];
    }
    
    @weakify(self);
    @weakify(m);
    if (self.viewModel.type != DatingStatusTypeInvite){
        if ([m.title isEqualToString:@"约会地点"]) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:@1 forKey:@"isSearch"];
            [params setObject:self.viewModel.inviteAddress ?: @"" forKey:@"shopName"];
            [YSMediator pushToViewController:kModuleDatingShop
                                  withParams:params
                                    animated:YES
                                    callBack:NULL];
        }
        return;
    }
    
    

    if ([m.title isEqualToString:@"约会时间"]) {
        YSPickerView *pickerView = [YSPickerView pickerViewWithType:YSPickerViewTypeDate];
        pickerView.showTime = YES;
        pickerView.sureHander = ^(NSArray *x) {
            @strongify(self);
            @strongify(m);
            NSString *time = [x.lastObject name];
            m.info = time;
            self.viewModel.inviteTime = time;
        };
        [pickerView showPickerView];
    }
    else if ([m.title isEqualToString:@"约会地点"]) {
        if (![self checkLocationAuthority]) return;
        
        id selected = ^(NSDictionary *callDict){
            @strongify(self);
            @strongify(m);
            m.info = callDict[@"address"];
            
            self.viewModel.longitude = callDict[@"longitude"];
            self.viewModel.latitude = callDict[@"latitude"];
            self.viewModel.inviteAddress = callDict[@"address"];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        [YSMediator pushToViewController:kModuleShopList
                              withParams:@{@"selected": selected}
                                animated:YES
                                callBack:NULL];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableHeaderView = [self tableHeaderView];
        tableView.tableFooterView = [self tableViewFooterView];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tableView.mj_header = [YSRefresher headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        [self.view addSubview:tableView];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [tableView registerClass:[HYDatingInfoCell class] forCellReuseIdentifier:@"reuseID"];
        
        tableView;
    });
    
    
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
}

- (BOOL)checkLocationAuthority {
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"定位服务未开启"
                                            message:@"定位功能未开启,现在去设置授权,否则将无法使用对应功能"
                                     preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"现在去打开"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                              [[UIApplication sharedApplication] openURL:appSettings];
                                                          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }]];
        [self presentViewController:alertController animated:YES completion:NULL];
        return NO;
    }
    return YES;
}

- (void)resetupNeedDisplayCancleBtn:(BOOL)need {
    if (need) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithTitle:@"取消预约"
                                                  style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(cancelDate)];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithTitle:@"规则"
                                                  style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(go2RuleView)];
    }
}

- (void)resetContentView:(UIView *)inView {
    for (UIView *v in inView.subviews) {
        [v removeFromSuperview];
    }
}


#pragma mark 底部操作按钮

- (void)addActionBtnInView:(UIView *)inView isCancelRequest:(BOOL)isCancelRst{
    [self resetContentView:inView];
    
    CGFloat scale = SCREEN_WIDTH/375.0;
    _rejectBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(20 * scale, 15, 120 * scale, 45);
        [btn setTitle:@"残忍拒绝" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FF5D9C"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.layer.cornerRadius = 22.5;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#FF5D9C"].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(rejectData) forControlEvents:UIControlEventTouchUpInside];
        [inView addSubview:btn];
        btn;
    });
    
    
    
    _acceptBtn = ({
        NSString *title = isCancelRst ? @"同意取消约会" : @"同意Ta的申请";
        UIButton *btn = [self btnInView:inView withTitle:title action:@selector(acceptDate)];
       
        CGFloat x =  CGRectGetMaxX(self.rejectBtn.frame) + 15 * scale;
        btn.frame = CGRectMake(x, 15, 200 * scale, 45);
        [btn setBackgroundImage:[self gradientImageOfSize:btn.bounds] forState:UIControlStateNormal];
        btn;
    });

}


- (void)addInvateBtnInView:(UIView *)inView {
    [self resetContentView:inView];
    
    _inviteBtn = ({
        NSString *title = [NSString stringWithFormat:@"向%@发起约会申请", [QMMUserContext shareContext].objectCall];
        UIButton *btn = [self btnInView:inView withTitle:title action:@selector(inviteDate)];
        btn.frame = CGRectMake(30, 15, SCREEN_WIDTH - 60, 45);
        [btn setBackgroundImage:[self gradientImageOfSize:btn.bounds] forState:UIControlStateNormal];
        btn;
    });
}

- (void)addCancleBtnInView:(UIView *)inView {
    [self resetContentView:inView];
    
    _cancleBtn = ({
        UIButton *btn = [self btnInView:inView withTitle:@"撤销约会申请" action:@selector(cancelDate)];
        btn.frame = CGRectMake(30, 15, SCREEN_WIDTH - 60, 45);
        [btn setBackgroundImage:[self gradientImageOfSize:btn.bounds] forState:UIControlStateNormal];
        btn;
    });
}

- (void)addGo2PayBtnInView:(UIView *)inView {
    [self resetContentView:inView];
    
    UIButton *btn = [self btnInView:inView withTitle:@"现在去支付保证金" action:@selector(go2datingSubmitVC)];
    btn.frame = CGRectMake(30, 15, SCREEN_WIDTH - 60, 45);
    [btn setBackgroundImage:[self gradientImageOfSize:btn.bounds] forState:UIControlStateNormal];
}


- (UIButton *)btnInView:(UIView *)inView withTitle:(NSString *)title action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.layer.cornerRadius = 22.5;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [inView addSubview:btn];
    return btn;
}

- (void)addTipsInButtonView:(UIView *)inView {
    [self resetContentView:inView];
    
    _tipsLabel = [UILabel labelWithText:@" 6 天 01:20:20 后开启签到赴约"
                              textColor:[UIColor colorWithHexString:@"#FF5D9C"]
                          textAlignment:NSTextAlignmentCenter
                               font:[UIFont systemFontOfSize:16]
                                 inView:inView
                              tapAction:^(UILabel *label, UIGestureRecognizer *tap) {
                                  
                              }];
    _tipsLabel.numberOfLines = 2;
    [_tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (void)addSignInBottomView:(UIView *)inView {
    [self resetContentView:inView];
    
    //
    _signinBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH - 120 - 15, 15, 120, 45);
        [btn setTitle:@"签到赴约" forState:UIControlStateNormal];
        [btn setBackgroundImage:[self gradientImageOfSize:btn.bounds] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.layer.cornerRadius = 22.5;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(signinAction) forControlEvents:UIControlEventTouchUpInside];
        [inView addSubview:btn];
        btn;
    });
    
    _tipsLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(16, 623, 181, 14);
        label.text = @"01:20:20 后关闭签到赴约";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        label.textColor = [UIColor colorWithRed:67/255.0 green:72/255.0 blue:77/255.0 alpha:1/1.0];
        label.numberOfLines = 2;
        [inView addSubview:label];
        
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(inView);
            make.left.offset(15);
            make.right.equalTo(_signinBtn.mas_left);
        }];
        label;
    });
    
}

- (UIImage *)gradientImageOfSize:(CGRect)bounds {
    CAGradientLayer *layer = [CAGradientLayer layer];
    UIColor *color0 = [UIColor colorWithHexString:@"#FF599E"];
    UIColor *color1 = [UIColor colorWithHexString:@"#FFAB68"];
    layer.colors = @[(id)color0.CGColor,
                     (id)color1.CGColor];
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1, 0.5);
    layer.frame = bounds;
    //layer.locations = @[@(0.0f), @(1)];
    
    UIGraphicsBeginImageContext(layer.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}

- (UIView *)tableViewFooterView {
    UIView *v = [[UIView alloc] init];
    
    
    UILabel *titleLabel = [UILabel labelWithText:@"约会小贴士:"
                                      textColor:[UIColor colorWithHexString:@"#7D7D7D"]
                                       font:[UIFont systemFontOfSize:14]
                                         inView:v
                                      tapAction:NULL];
    
    UILabel *infoLabel = [UILabel labelWithText:self.viewModel.tips
                                      textColor:[UIColor colorWithHexString:@"#BCBCBC"]
                                       font:[UIFont systemFontOfSize:12]
                                         inView:v
                                      tapAction:NULL];
    infoLabel.numberOfLines = 0;
    titleLabel.frame = CGRectMake(15, 20, 200, 20);
    
    CGSize size = [infoLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 35, CGFLOAT_MAX)];
    infoLabel.frame = CGRectMake(15,
                                 CGRectGetMaxY(titleLabel.frame) + 15,
                                 size.width,
                                 size.height);
    
//    CGFloat height = [v systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = v.frame;
    frame.size.height = 160 + 75;
    v.frame = frame;
    
    return v;
}

- (UIView *)tableHeaderView {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    v.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(go2userInfoView)];
    [v addGestureRecognizer:tap];
    
    
    UIImageView *avator = [[UIImageView alloc] init];
    [v addSubview:avator];
    avator.clipsToBounds = YES;
    avator.layer.cornerRadius = 65 * 0.5;
    avator.userInteractionEnabled = YES;
    avator.contentMode = UIViewContentModeScaleAspectFill;
    [avator sd_setImageWithURL:[NSURL URLWithString:self.avatar ?: @""]
              placeholderImage:[UIImage imageNamed:AVATAR_PLACEHOLDER]];
    
    
    UILabel *nameLabel = [UILabel labelWithText:self.name ?: @""
                                      textColor:[UIColor colorWithHexString:@"#030303"]
                                       font:[UIFont systemFontOfSize:16]
                                         inView:v
                                      tapAction:NULL];
    
    UIImageView *arrow = [UIImageView imageViewWithImageName:@"cellarrow" inView:v];
    
    [avator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.centerX.equalTo(v);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(v);
        make.top.equalTo(avator.mas_bottom).offset(15);
    }];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(v);
        make.right.equalTo(v).offset(-15);
    }];
    
    return v;
}

#pragma mark - Lazy Loading


@end
