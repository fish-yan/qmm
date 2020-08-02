//
//  QMMSupplementaryBaseVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMSupplementaryBaseVC.h"

@interface QMMSupplementaryBaseVC ()

@end

@implementation QMMSupplementaryBaseVC


#pragma mark - Life Circle

- (instancetype)init {
    if (self = [super init]) {
        self.viewModel = [QMMSupplementaryVM new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    UIView *bgView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = [UIApplication sharedApplication].keyWindow.bounds;
    layer.colors = @[
                     (__bridge id)[UIColor colorWithRed:253/255. green:166/255. blue:112/255. alpha:1].CGColor,
                     (__bridge id)[UIColor colorWithRed:253/255. green:107/255. blue:148/255. alpha:1].CGColor
                     ];
    layer.startPoint = CGPointZero;
    layer.endPoint = CGPointMake(0, 1);
    [bgView.layer addSublayer:layer];
    
    [self.view insertSubview:bgView atIndex:0];
    
    _goBackBtn = [UIButton buttonWithNormalImgName:@"nav_back_white"
                                           bgColor:nil
                                            inView:self.view
                                            action:^(UIButton *btn) {
                                                [self popBack];
                                            }];
    
  
    
    _titleLabel = [UILabel labelWithText:nil
                               textColor:[UIColor whiteColor]
                           textAlignment:NSTextAlignmentCenter
                                font:[UIFont pingFongFontOfSize:30]
                                  inView:self.view
                               tapAction:NULL];
    _stepLabel = [UILabel labelWithText:nil
                              textColor:[UIColor whiteColor]
                          textAlignment:NSTextAlignmentCenter
                               font:[UIFont pingFongFontOfSize:14]
                                 inView:self.view
                              tapAction:NULL];
    _infoLabel = [UILabel labelWithText:nil
                              textColor:[UIColor whiteColor]
                          textAlignment:NSTextAlignmentCenter
                               font:[UIFont pingFongFontOfSize:20]
                                 inView:self.view
                              tapAction:NULL];
    _descLabel = [UILabel labelWithText:nil
                              textColor:[UIColor whiteColor]
                          textAlignment:NSTextAlignmentCenter
                               font:[UIFont pingFongFontOfSize:16]
                                 inView:self.view
                              tapAction:NULL];
}

- (void)setupSubviewsLayout {
    [_goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(80);
    }];
    
    [_stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.stepLabel.mas_bottom).offset(25);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(10);
    }];
    
}

@end
