//
//  QMMLoginRegisterVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMLoginRegisterVC.h"

@interface QMMLoginRegisterVC ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *agreementInfoLabel;
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation QMMLoginRegisterVC


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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self.view endEditing:YES];
    }];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![AppContext shareContext].isNewUpdate) {
        [self showKeyboard];
    }
    
    //    if (self.isViewLoaded && self.view.window) {
    //        // viewController is visible
    //    }
    
}

#pragma mark - Action

- (void)go2codeInputView {
    NSString *tel = self.viewModel.mobile;
    if (tel.isEmpty) {
        return;
    }
    if (tel.length != 11) {
        [YSProgressHUD showTips:@"无效的手机号码"];
        return;
    }
    
    [YSMediator pushToViewController:kModuleMessageCode
                          withParams:@{@"tel": tel}
                            animated:YES
                            callBack:NULL];
}


#pragma mark - Bind

- (void)bind {
    RAC(self.viewModel, mobile) = self.textField.rac_textSignal;
    
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"SPLASH_VIEW_HIDDEN" object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(id  _Nullable x) {
         @strongify(self);
         [self.textField becomeFirstResponder];
     }];
}


#pragma mark - Initialize

- (void)initialize {
    self.goBackBtn.hidden = YES;
    
#warning - TODO:
    //[[WDSplashViewManager manager] addSplashViewDismissObserver:self selector:@selector(showKeyboard)];
}

- (void)showKeyboard {
    [_textField becomeFirstResponder];
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    _titleLabel = [UILabel labelWithText:@"登录/注册"
                               textColor:[UIColor whiteColor]
                                    font:[UIFont pingFongFontOfSize:30]
                                  inView:self.view
                               tapAction:NULL];
    _infoLabel = [UILabel labelWithText:@"请输入手机号"
                               textColor:[UIColor whiteColor]
                                    font:[UIFont pingFongFontOfSize:15]
                                  inView:self.view
                               tapAction:NULL];
    _textField = [UITextField textFieldWithText:nil
                                      textColor:[UIColor whiteColor]
                                           font:[UIFont pingFongFontOfSize:20]
                                    andDelegate:nil
                                         inView:self.view];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    _agreementInfoLabel = [UILabel labelWithText:@"注册表示同意【花缘注册协议】"
                                       textColor:[UIColor whiteColor]
                                        font:[UIFont pingFongFontOfSize:14]
                                          inView:self.view
                                       tapAction:^(UILabel *label, UIGestureRecognizer *tap) {
                                           [YSMediator openURL:@"https://www.huayuanvip.com/help/WXNprotcol.html"];
                                       }];
    
    @weakify(self);
    _nextBtn = [UIButton buttonWithTitle:@"下一步"
                              titleColor:[UIColor redColor]
                                font:[UIFont pingFongFontOfSize:16]
                                 bgColor:[UIColor whiteColor]
                                  inView:self.view
                                  action:^(UIButton *btn) {
                                      @strongify(self);
                                      [self go2codeInputView];
                                  }];
    _nextBtn.clipsToBounds = YES;
    _nextBtn.layer.cornerRadius = 45 * 0.5;
    
}

- (void)setupSubviewsLayout {
    CGFloat padding = 30;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(padding);
        make.top.offset(80);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(35);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoLabel);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(20);
        make.right.offset(-padding);
        make.height.mas_equalTo(20);
    }];
    
    UIView *line = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:self.view];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(padding);
        make.right.offset(-padding);
        make.top.equalTo(self.textField.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    [_agreementInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line);
        make.top.equalTo(line.mas_bottom).offset(20);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreementInfoLabel.mas_bottom).offset(60);
        make.left.offset(padding);
        make.right.offset(-padding);
        make.height.mas_equalTo(45);
    }];
}


@end
