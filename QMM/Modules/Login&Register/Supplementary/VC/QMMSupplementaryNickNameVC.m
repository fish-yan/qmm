//
//  QMMSupplementaryNickNameVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMSupplementaryNickNameVC.h"

@interface QMMSupplementaryNickNameVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation QMMSupplementaryNickNameVC


+ (void)load {
    [self mapName:kModuleCompleteInfoNick withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self setupSubviewsLayout];
    [self bind];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputView becomeFirstResponder];
    });
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [self.inputView.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.viewModel.nickName = x;
    }];
}


#pragma mark - Initialize

- (void)initialize {
    self.titleLabel.text = @"完善资料";
    self.stepLabel.text = @"(2/5)";
    self.infoLabel.text = @"请输入您的昵称";
    self.descLabel.text = @"好的昵称可以提高关注度";
}


- (BOOL)checkNameNumberLimit {
    if (self.viewModel.nickName.length > 15 || self.viewModel.nickName.length < 2) {
        [YSProgressHUD showTips:@"昵称字数限制为 2 ~ 15"];
        return NO;
    }
    return YES;
}

- (void)go2NextStep {
    if (![self checkNameNumberLimit]) {
        return;
    }
    NSDictionary *params = @{
                             @"viewModel": self.viewModel,
                             @"selectType": @(0)
                             };
    [YSMediator pushToViewController:kModuleCompleteInfoSelect
                          withParams:params
                            animated:YES
                            callBack:NULL];
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    
    _inputView = [UITextField textFieldWithText:nil
                                      textColor:[UIColor whiteColor]
                                       font:[UIFont pingFongFontOfSize:20]
                                    andDelegate:self
                                         inView:self.view];
    _inputView.textAlignment = NSTextAlignmentCenter;
    
    
    @weakify(self);
    _nextBtn = [UIButton buttonWithTitle:@"下一步"
                              titleColor:[UIColor colorWithHexString:@"#FF5D9C"]
                                font:[UIFont pingFongFontOfSize:16]
                                 bgColor:[UIColor whiteColor]
                                  inView:self.view
                                  action:^(UIButton *btn) {
                                      @strongify(self);
                                      [self go2NextStep];
                                  }];
    _nextBtn.clipsToBounds = YES;
    _nextBtn.layer.cornerRadius = 45 * 0.5;
    
}

- (void)setupSubviewsLayout {
    [super setupSubviewsLayout];
    
    CGFloat padding = 30;
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(40);
        make.left.offset(padding);
        make.right.offset(-padding);
        make.height.mas_equalTo(25);
    }];
    
    UIView *line = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:self.view];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_bottom).offset(15);
        make.left.offset(padding);
        make.right.offset(-padding);
        make.height.mas_equalTo(0.5);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(50);
        make.left.offset(padding);
        make.right.offset(-padding);
        make.height.mas_equalTo(45);
    }];
}


@end
