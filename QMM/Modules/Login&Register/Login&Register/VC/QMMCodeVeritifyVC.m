//
//  QMMCodeVeritifyVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMCodeVeritifyVC.h"
#import "YSCodeVerifyView.h"

@interface QMMCodeVeritifyVC ()<YSCodeVerifyViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *telInfoLabel;
@property (nonatomic, strong) UIButton *countdownBtn;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) YSCodeVerifyView *codeInputView;

@end

@implementation QMMCodeVeritifyVC

+ (void)load {
    [self mapName:kModuleMessageCode withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self bind];
    
    if (self.viewModel.resendEnable) {
        [self.viewModel.getMobileCodeCmd execute:self.tel];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.codeInputView becomeFirstResponder];
}


#pragma mark - Action

- (void)recallMessageCode {
    [self.viewModel.getMobileCodeCmd execute:self.tel];
    NSLog(@"--- 调用重新获取短信验证码接口");
}

- (void)verifyMessageCode {
    NSLog(@"--- 验证短信验证码");
}

#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [[self.viewModel.getMobileCodeCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
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
    [[self.viewModel.verifyCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        [YSProgressHUD hiddenHUD];
        @strongify(self);
        NSString *mapName = @"";
        switch (self.viewModel.infoType) {
            case UserInfoTypeIncomplte: {   // 不完整(即:新注册) 注册流程
                mapName = kModuleCompleteInfoGender;
                break;
            }
            case UserInfoTypeNoAvatar: {    // 没头像设置头像
                mapName = kModuleCompleteInfoAvatar;
                break;
            }
            case UserInfoTypeComplete: {    // 完整进首页
                [[QMMUIAssistant shareInstance].setTabBarVCAsRootVCCommand execute:nil];
                return;
            }
            default:
                break;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YSMediator pushToViewController:mapName
                                  withParams:nil
                                    animated:YES
                                    callBack:NULL];
        });
    }];
    
    [self.viewModel.verifyCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YSMediator pushToViewController:kModuleCompleteInfoGender
                                  withParams:nil
                                    animated:YES
                                    callBack:NULL];
        });
    }];
    
    [[self.viewModel.verifyCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
        
    }];
    
    //
    [RACObserve(self.viewModel, cutdownTime) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSString *title = [NSString stringWithFormat:@"%zds 后重新发送", [x integerValue]];
        [self.countdownBtn setTitle:title forState:UIControlStateDisabled];
    }];
    
    RAC(self.countdownBtn, enabled) = RACObserve(self.viewModel, resendEnable);
}


#pragma mark - Initialize

- (void)initialize {
    self.viewModel.mobile = self.tel;
}


- (void)codeVerifyView:(YSCodeVerifyView *)codeVerifyView didEndInput:(NSString *)code {
    [codeVerifyView resignFirstResponder];
    
    NSLog(@"===> %@", code);
    
    self.viewModel.code = code;
    [self.viewModel.verifyCmd execute:code];
}

#pragma mark - Setup Subviews

- (void)setupSubviews {
    _titleLabel = [UILabel labelWithText:@"短信验证码"
                               textColor:[UIColor whiteColor]
                                font:[UIFont pingFongFontOfSize:30]
                                  inView:self.view
                               tapAction:NULL];
    _infoLabel = [UILabel labelWithText:@"验证码已通过短信发送至:"
                              textColor:[UIColor whiteColor]
                               font:[UIFont pingFongFontOfSize:14]
                                 inView:self.view
                              tapAction:NULL];
    _telInfoLabel = [UILabel labelWithText:self.tel
                                 textColor:[UIColor whiteColor]
                                  font:[UIFont pingFongFontOfSize:20]
                                    inView:self.view
                                 tapAction:NULL];
    
    CGFloat padding = 30;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(padding);
        make.top.offset(80);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
    }];
    
    [_telInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(10);
    }];
    
    
    //
    _codeInputView = [[YSCodeVerifyView alloc] init];
    _codeInputView.delegate = self;
    _codeInputView.backgroundColor = [UIColor clearColor];
    _codeInputView.font = [UIFont boldSystemFontOfSize:40];
    _codeInputView.type = YSCodeVerifyViewTypeUnderLine;
    _codeInputView.lineWidth = 2;
    _codeInputView.inputSize = CGSizeMake(45, 70);
    _codeInputView.lineColor = [UIColor whiteColor];
    _codeInputView.textColor = [UIColor whiteColor];
    
    [self.view addSubview:_codeInputView];
    [_codeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(padding);
        make.right.equalTo(self.view);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(60);
        make.height.mas_equalTo(70);
    }];
    
    
    //
    _countdownBtn = [UIButton new];
    _countdownBtn.adjustsImageWhenDisabled = NO;
    [_countdownBtn setTitle:@"点击重新发送" forState:UIControlStateNormal];
    [_countdownBtn setTitle:@"60s 后重新发送" forState:UIControlStateDisabled];
    [_countdownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _countdownBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    @weakify(self);
    [[self.countdownBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         x.enabled = NO;
         [self recallMessageCode];
         
     }];
    [self.view addSubview:_countdownBtn];
    
    [_countdownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(padding);
        make.top.equalTo(self.codeInputView.mas_bottom).offset(25);
    }];
    
    
}

@end
