//
//  QMMLoginViewController.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/27.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMLoginViewController.h"
#import "QMMIconInputView.h"
#import "QMMLoginVM.h"

@interface QMMLoginViewController ()

@property (nonatomic, strong) QMMLoginVM *viewModel;

@property (nonatomic, strong) UIImageView *bgImgV;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *inputContainer;
@property (nonatomic, strong) QMMIconInputView *telV;
@property (nonatomic, strong) QMMIconInputView *codeV;

@property (nonatomic, strong) UIButton *sendCodeBtn;
@property (nonatomic, strong) UIButton *agreementSelectBtn;
@property (nonatomic, strong) UILabel *agreementLabel;
@property (nonatomic, strong) UIButton *agreementBtn;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, assign) NSInteger second;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation QMMLoginViewController

+ (void)load {
    [self mapName:kModuleLoginRegister withParams:nil];
}


#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self setupSubviewsLayout];
    [self bind];
}


#pragma mark - Action

- (void)loginAction {
    if (self.telV.content.length == 0 || self.codeV.content.length == 0) {
        return;
    }
    else if (self.telV.content.length != 11 || self.codeV.content.length != 4) {
        [YSProgressHUD showTips:@"请填写正确的信息"];
        return;
    }
    
    if (!_agreementSelectBtn.selected) {
        [YSProgressHUD showTips:[NSString stringWithFormat:@"请阅读并同意《%@用户协议》",APP_DISPLAY_NAME]];
        return;
    }
    
    [self.viewModel.loginCmd execute:nil];
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    
    RAC(self.viewModel, mobile) = RACObserve(self.telV, content);
    RAC(self.viewModel, code) = RACObserve(self.codeV, content);
    
    [[self.viewModel.getMobileCodeCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownAction) userInfo:nil repeats:YES];
        [YSProgressHUD showTips:x];
    }];
    
    [self.viewModel.getMobileCodeCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
    
    [[self.viewModel.getMobileCodeCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
    }];
    
    //
    [[self.viewModel.loginCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        [YSProgressHUD hiddenHUD];
        @strongify(self);
        // 1基础信息不完善; 2:未上传头像, 需要上传头像; 3:注册过,直接登录, 4: 没有芝麻认证,没有支付, 5:没有芝麻认证, 但是有支付, 6有芝麻认证, 但没有支付
        if (self.viewModel.infoType == UserInfoTypeRegister ||
            self.viewModel.infoType == UserInfoTypeNoAvatar) {
            [self.navigationController pushViewController:[CompleteInfoVC new] animated:YES];
        }
        // 信息完整或者不需要认证直接进首页
        else if (self.viewModel.infoType == UserInfoTypeNoCertifiedHadPay) {
            [[QMMUIAssistant shareInstance].setTabBarVCAsRootVCCommand execute:nil];
        }
        // 4: 没有芝麻认证,没有支付, 5:没有芝麻认证, 但是有支付
//        else if (self.viewModel.infoType == UserInfoTypeNoCertifiedNoPay ||
//                 self.viewModel.infoType == UserInfoTypeNoCertifiedHadPay) {
//            [self.navigationController pushViewController:[ZhiMaCreditVertifyVC new] animated:YES];
//        }
        // 有芝麻认证, 但没有支付
//        else if (self.viewModel.infoType == UserInfoTypeHadCertifiedNoPay) {
//            [[QMMUIAssistant shareInstance].setTabBarVCAsRootVCCommand execute:nil];
//
////            [self.navigationController pushViewController:[VertifyPayViewController new] animated:YES];
//        }
        else {
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"FYLoginVIPViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    [self.viewModel.loginCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
    
    [[self.viewModel.loginCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
        
    }];
    
    //
//    [RACObserve(self.viewModel, cutdownTime) subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        NSString *title = [NSString stringWithFormat:@"%zds 后重新发送", [x integerValue]];
//        [self.sendCodeBtn setTitle:title forState:UIControlStateDisabled];
//    }];
//
//    RAC(self.sendCodeBtn, enabled) = RACObserve(self.viewModel, resendEnable);
}


#pragma mark - Initialize

- (void)initialize {
    self.viewModel = [QMMLoginVM new];
    self.second = 60;
}


#pragma mark - Setup Subviews

- (void)countdownAction {
    self.second--;
    if (self.second == 0) {
        self.second = 60;
        [self.timer invalidate];
        self.timer = nil;
        self.sendCodeBtn.enabled = YES;
        [self.sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    } else {
        self.sendCodeBtn.enabled = NO;
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%lds 后重新发送", self.second] forState:UIControlStateDisabled];
    }
}

- (void)setupSubviews {
    _bgImgV = [UIImageView imageViewWithImageName:@"login_bg" inView:self.view];
    [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    _scrollView = ({
        UIScrollView *sv = [[UIScrollView alloc] init];
        [self.view addSubview:sv];
        [sv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
            make.width.equalTo(self.view);
        }];
        sv;
    });
    
    _contentView = [UIView viewWithBackgroundColor:nil inView:_scrollView];

    
    // ---
    _titleLabel = [UILabel labelWithText:@"登录/注册"
                               textColor:[UIColor colorWithHexString:@"#464646"]
                           textAlignment:NSTextAlignmentLeft
                                    font:[UIFont systemFontOfSize:24]
                                  inView:_contentView
                               tapAction:NULL];
    
    // --
    _inputContainer = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:_contentView];
    _inputContainer.layer.shadowOffset = CGSizeZero;
    _inputContainer.layer.cornerRadius = 10;
    _inputContainer.layer.shadowColor = [UIColor colorWithHexString:@"#540A73"].CGColor;
    _inputContainer.layer.shadowOpacity = 0.2;
    _inputContainer.layer.shadowRadius = 33;
    
    UIColor *color = [UIColor colorWithHexString:@"#A5A5A5"];
    _telV = [QMMIconInputView viewWithNormalIcon:@"ic_login_tel_n" focusIcon:@"ic_login_tel_f" placeHolder:@"请输入手机号码"];
    _telV.textField.keyboardType = UIKeyboardTypePhonePad;
    [_telV setCornerWithRadius:25 borderWidth:0.5 borderColor:color clipsToBounds:NO];

    _codeV = [QMMIconInputView viewWithNormalIcon:@"ic_login_code_n" focusIcon:@"ic_login_code_f" placeHolder:@"请输入验证码"];
    _codeV.textField.keyboardType = UIKeyboardTypeNumberPad;
    [_codeV setCornerWithRadius:25 borderWidth:0.5 borderColor:color clipsToBounds:NO];
    
    [self.inputContainer addSubview:_telV];
    [self.inputContainer addSubview:_codeV];
    
    // --
    _sendCodeBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
       
        btn.adjustsImageWhenDisabled = NO;
        [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [btn setTitle:@"60s 后重新发送" forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor colorWithHexString:@"#393939"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
       
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(__kindof UIControl * _Nullable x) {
             @strongify(self);
             if ([self.viewModel.mobile stringByTrimmingWhitespace].length != 11) {
                 return;
             }

             [self.viewModel.getMobileCodeCmd execute:nil];
             
         }];
        
        [self.contentView addSubview:btn];
        
        btn;
    });
    
    _agreementSelectBtn = [UIButton buttonWithTitle:@""
                                         titleColor:[UIColor colorWithHexString:@"#FF8371"]
                                               font:[UIFont systemFontOfSize:12]
                                            bgColor:UIColorByRGB(0xBCBCBC)
                                             inView:self.contentView
                                             action:^(UIButton *btn) {
                                                 self.agreementSelectBtn.selected = !self.agreementSelectBtn.selected;
                                             }];
    [_agreementSelectBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
    [_agreementSelectBtn setImage:[UIImage imageNamed:@"ic_pay_s"] forState:(UIControlStateSelected)];
    _agreementSelectBtn.layer.cornerRadius = 8;
    _agreementSelectBtn.selected = NO;
    
    // ---
    _agreementLabel = [UILabel labelWithText:@"请阅读并同意"
                                   textColor:[UIColor colorWithHexString:@"#D2D2D2"]
                                        font:[UIFont systemFontOfSize:12]
                                      inView:self.contentView
                                   tapAction:NULL];
    
    
    _agreementBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"《%@用户协议》", APP_DISPLAY_NAME]
                                   titleColor:[UIColor colorWithHexString:@"#FF8371"]
                                         font:[UIFont systemFontOfSize:12]
                                      bgColor:nil
                                       inView:self.contentView
                                       action:^(UIButton *btn) {
                                           [YSMediator openURL:@"http://www.huayuanvip.com/help/WXNVIPprotcol_10001.html"];
                                       }];
    
    // ---
    _loginBtn = [UIButton buttonWithTitle:@"登录"
                               titleColor:[UIColor colorWithHexString:@"#464646"]
                                     font:[UIFont systemFontOfSize:24]
                                  bgColor:[UIColor colorWithHexString:@"#BDFED7"]
                                   inView:self.contentView
                                   action:^(UIButton *btn) {
                                       [self loginAction];
                                   }];
    _loginBtn.clipsToBounds = YES;
    _loginBtn.layer.cornerRadius = 25.0;
    
//    _loginBtn = ({
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"登录" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor colorWithHexString:@"#464646"] forState:UIControlStateNormal];
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:24]];
//        [btn setBackgroundColor:[UIColor colorWithHexString:@"#BDFED7"]];
//        [btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
//        btn.clipsToBounds = YES;
//        btn.layer.cornerRadius = 25.0;
//        [self.contentView addSubview:btn];
//        
//        btn;
//    });
}


- (void)setupSubviewsLayout {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(38);
        make.top.offset(96);
    }];
    
    // --
    [_inputContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(50);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.mas_equalTo(190);
    }];
    
    [_telV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(35);
        make.height.mas_equalTo(49);
    }];
    
    [_codeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.telV);
        make.top.equalTo(self.telV.mas_bottom).offset(25);
    }];
    
    // ---
    
    [_sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeV);
        make.right.equalTo(self.inputContainer).offset(-30);
    }];
    
    [_agreementSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputContainer);
        make.top.equalTo(self.inputContainer.mas_bottom).offset(25);
        make.width.height.mas_equalTo(16);
    }];
    
    [_agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreementSelectBtn);
        make.left.equalTo(self.agreementSelectBtn.mas_right).offset(5);
    }];
    
    [_agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreementSelectBtn);
        make.left.equalTo(self.agreementLabel.mas_right).offset(5);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35);
        make.right.offset(-35);
        make.top.equalTo(self.agreementLabel.mas_bottom).offset(80);
        make.height.mas_equalTo(49);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);// 一定要写
        make.width.equalTo(self.scrollView);// 一定要写
        make.bottom.equalTo(self.loginBtn).offset(20);
    }];
}


#pragma mark - Lazy Loading
@end
