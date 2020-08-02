//
//  QMMSupplementaryGenderVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMSupplementaryGenderVC.h"

@interface QMMSupplementaryGenderVC ()

@property (nonatomic, strong) UIButton *maleBtn;
@property (nonatomic, strong) UILabel *maleLabel;
@property (nonatomic, strong) UIButton *femaleBtn;
@property (nonatomic, strong) UILabel *femaleLabel;

@end

@implementation QMMSupplementaryGenderVC


+ (void)load {
    [self mapName:kModuleCompleteInfoGender withParams:nil];
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

- (void)clickAction:(UIButton *)sender {
    if (sender.selected) return;
    sender.selected = YES;
    
    if (sender.tag == 100) {
        self.femaleBtn.selected = NO;
    } else {
        self.maleBtn.selected = NO;
    }
    
    self.viewModel.isMale = self.maleBtn.selected;
    self.viewModel.gender = self.maleBtn.selected == YES ? @"男" : @"女";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YSMediator pushToViewController:kModuleCompleteInfoNick
                              withParams:@{@"viewModel": self.viewModel}
                                animated:YES
                                callBack:NULL];
    });
}

#pragma mark - Bind

- (void)bind {
}


#pragma mark - Initialize

- (void)initialize {
    self.titleLabel.text = @"完善资料";
    self.stepLabel.text = @"(1/5)";
    self.infoLabel.text = @"请选择您的性别";
    self.descLabel.text = @"让我们更懂你";
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    
    _maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _maleBtn.adjustsImageWhenHighlighted = NO;
    [_maleBtn setImage:[UIImage imageNamed:@"ic_man_unclick"] forState:UIControlStateNormal];
    [_maleBtn setImage:[UIImage imageNamed:@"ic_man_click"] forState:UIControlStateSelected];
    [_maleBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchDown];
    _maleBtn.tag = 100;
    [self.view addSubview:_maleBtn];
    
    _maleLabel = [UILabel labelWithText:@"帅哥"
                              textColor:[UIColor whiteColor]
                                   font:[UIFont pingFongFontOfSize:18]
                                 inView:self.view
                              tapAction:NULL];
    
    //
    _femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _femaleBtn.adjustsImageWhenHighlighted = NO;
    [_femaleBtn setImage:[UIImage imageNamed:@"ic_woman_unclick"] forState:UIControlStateNormal];
    [_femaleBtn setImage:[UIImage imageNamed:@"ic_woman_click"] forState:UIControlStateSelected];
    [_femaleBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchDown];
    _femaleBtn.tag = 101;
    [self.view addSubview:_femaleBtn];
    
    _femaleLabel = [UILabel labelWithText:@"美女"
                                textColor:[UIColor whiteColor]
                                 font:[UIFont pingFongFontOfSize:18]
                                   inView:self.view
                                tapAction:NULL];
}

- (void)setupSubviewsLayout {
    [super setupSubviewsLayout];
    
    [_maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.top.equalTo(self.descLabel.mas_bottom).offset(60);
        make.right.equalTo(self.view.mas_centerX).offset(-35);
    }];
    
    [_maleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.maleBtn.mas_bottom).offset(35);
        make.centerX.equalTo(self.maleBtn);
    }];
    
    [_femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.top.equalTo(self.descLabel.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_centerX).offset(35);
    }];
    
    [_femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.femaleBtn.mas_bottom).offset(35);
        make.centerX.equalTo(self.femaleBtn);
    }];
}




@end
