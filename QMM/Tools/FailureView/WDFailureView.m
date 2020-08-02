//
//  WDFailureView.m
//  HCDoctor
//
//  Created by Joseph Gao on 2017/6/14.
//  Copyright © 2017年 WondersGroup.com. All rights reserved.
//

#import "WDFailureView.h"

@interface WDFailureView ()

@property (nonatomic, strong) UIImageView *failureImgV;

@property (nonatomic, strong) UIButton *tapBtn;


@property (nonatomic, copy) void(^touchHandler)(void);

@end

@implementation WDFailureView

#pragma mark - Initialize

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setubSubviews];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}


#pragma mark - Action

- (void)showFailureViewWithImage:(UIImage *)image
                            tips:(NSString *)tips
               labelClickHandler:(void(^)(void))labelClickHandler
                 btnClickHandler:(void(^)(UIButton *tapBtn))handler {
    
    self.failureImgV.image = image;
    self.tipsLabel.text  = tips;
    
    if (labelClickHandler) self.touchHandler = labelClickHandler;
    
    if (handler) {
        self.tapBtn.hidden = NO;
        handler(self.tapBtn);
    } else {
        self.tapBtn.hidden = YES;
    }
    
    [self layoutIfNeeded];
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    if (self.touchHandler) {
        self.touchHandler();
    }
}


#pragma mark - Setup Subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat topOffset = self.tapBtn.hidden ? 0 : -20.0;
    
    [_tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self).offset(topOffset);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    [_failureImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tipsLabel.mas_top).offset(-20);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(100);
    }];
    
    [_tapBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(self.tapBtn.size);
    }];
}

- (void)setubSubviews {
    // ----
    _failureImgV = [[UIImageView alloc] init];
    _failureImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_failureImgV];
    
    // ----
    _tipsLabel = [[UILabel alloc] init];
    [_tipsLabel setBackgroundColor:[UIColor clearColor]];
    _tipsLabel.textColor = [UIColor tc7Color];
    _tipsLabel.font = [UIFont systemFontOfSize:14];
    _tipsLabel.numberOfLines = 0;
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    [_tipsLabel sizeToFit];
    [self addSubview:_tipsLabel];
    
    // ----
    _tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_tapBtn];
}


@end
