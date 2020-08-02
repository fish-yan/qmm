//
//  HYExclusiveGreetVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYExclusiveGreetVC.h"
#import "HYGreetAnimator.h"

@interface HYExclusiveGreetVC () <UITextViewDelegate>

@property (nonatomic, strong) HYGreetAnimator *animator;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UITextView *inputView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *submitBtn;
@end

@implementation HYExclusiveGreetVC

+ (void)load {
    [self mapName:kModuleExclusiveGreetView withParams:nil];
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

- (void)submitAction {
    if (self.submitClickHandler) {
        self.submitClickHandler(self.inputView.text);
    }
}

- (void)cancleAction {
    if (self.cancleClickHandler) {
        self.cancleClickHandler();
    }
}


#pragma mark - Bind

- (void)bind {
}


#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length > 10) {
        return NO;
    }
    return YES;
}


#pragma mark - Initialize

- (void)initialize {
    self.view.backgroundColor = [UIColor clearColor];
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    self.maskView = [UIView viewWithBackgroundColor:[UIColor blackColor] inView:self.view];
    self.maskView.tag = 1024;
    self.maskView.alpha = 0.4;
    self.maskView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.contentView = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:self.view];
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.tag = 1025;
    
    //
    _titleLabel = [UILabel labelWithText:@"专属打招呼"
                               textColor:[UIColor colorWithHexString:@"#313131"]
                           textAlignment:NSTextAlignmentCenter
                                font:[UIFont systemFontOfSize:18]
                                  inView:_contentView
                               tapAction:NULL];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    _infoLabel = [UILabel labelWithText:@"为保护会员隐私，认证后才可以发送私信"
                              textColor:[UIColor colorWithHexString:@"#313131"]
                          textAlignment:NSTextAlignmentCenter
                               font:[UIFont systemFontOfSize:15]
                                 inView:_contentView
                              tapAction:NULL];
    _infoLabel.numberOfLines = 0;
    
    _inputView = [UITextView textViewWithText:nil
                                    textColor:[UIColor blackColor]
                                     font:[UIFont systemFontOfSize:14]
                                     delegate:self
                                       inView:_contentView];
    _inputView.placeholder = @"请输入（30字以内）";
    _inputView.layer.borderWidth = 0.5;
    _inputView.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    _inputView.layer.cornerRadius = 2;
    [_contentView addSubview:_inputView];
    
    @weakify(self);
    _cancelBtn = [UIButton buttonWithTitle:@"取消"
                                titleColor:[UIColor colorWithHexString:@"#313131"]
                                  font:[UIFont systemFontOfSize:16]
                                   bgColor:[UIColor colorWithHexString:@"#F7F7F7"]
                                    inView:_contentView
                                    action:^(UIButton *btn) {
                                        @strongify(self);
                                        [self cancleAction];
                                    }];
    _submitBtn = [UIButton buttonWithTitle:@"确认"
                                titleColor:[UIColor colorWithHexString:@"#FF8BB1"]
                                  font:[UIFont systemFontOfSize:16]
                                   bgColor:[UIColor colorWithHexString:@"#F7F7F7"]
                                    inView:_contentView
                                    action:^(UIButton *btn) {
                                        @strongify(self);
                                        [self submitAction];
                                    }];
}

- (void)setupSubviewsLayout {
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    CGFloat contentPadding = 30;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(contentPadding);
        make.right.offset(-contentPadding);
        make.center.equalTo(self.view);
        make.bottom.equalTo(self.submitBtn.mas_bottom);
    }];
    
    //
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.offset(25);
        make.height.mas_equalTo(20);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(10);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.mas_equalTo(70);
    }];
    
    UIView *lineH = [UIView viewWithBackgroundColor:[UIColor colorWithHexString:@"E7E7E7"] inView:_contentView];
    UIView *lineV = [UIView viewWithBackgroundColor:[UIColor colorWithHexString:@"E7E7E7"] inView:_contentView];
    
    [lineH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.inputView.mas_bottom).offset(20);
    }];
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineH.mas_bottom);
        make.bottom.centerX.offset(0);
        make.width.mas_equalTo(1);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(lineH.mas_bottom);
        make.right.equalTo(lineV.mas_left);
        make.height.mas_equalTo(55);
    }];
    
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.top.equalTo(lineH.mas_bottom);
        make.left.equalTo(lineV.mas_right);
        make.height.equalTo(self.cancelBtn);
    }];
}


@end
