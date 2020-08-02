//
//  QMMBottomActionView.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMBottomActionView.h"
#import "QMMBottomActionVM.h"

@interface QMMBottomActionView ()

@property (nonatomic, copy) void(^heartAction)(UIButton *heartBtn);
@property (nonatomic, copy) void(^dateAction)(UIButton *dateAction);
@property (nonatomic, copy) void(^messageAction)(UIButton *messageAction);

@end

@implementation QMMBottomActionView

+ (instancetype)viewWithHeartClickAction:(void(^)(UIButton *btn))heartAction
                         dateClickAction:(void(^)(UIButton *btn))dateAction
                      messageClickAction:(void(^)(UIButton *btn))messageAction {
    QMMBottomActionView *v = [[QMMBottomActionView alloc] init];
    v.heartAction = heartAction;
    v.dateAction = dateAction;
    v.messageAction = messageAction;
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

- (void)bind {
    @weakify(self);
    [[self.heartBtn rac_signalForControlEvents:UIControlEventTouchDown]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         if (self.heartAction) {
             self.heartAction(x);
         }
     }];
    
    [[self.dateBtn rac_signalForControlEvents:UIControlEventTouchDown]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         if (self.dateAction) {
             self.dateAction(x);
         }
     }];
    
    
    [[self.msgBtn rac_signalForControlEvents:UIControlEventTouchDown]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         if (self.messageAction) {
             self.messageAction(x);
         }
     }];
}

- (void)setupSubvews {
    UIColor *titleColor = [UIColor colorWithHexString:@"#43484D"];
    self.heartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.heartBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.heartBtn setTitle:@"  心动" forState:UIControlStateNormal];
    [self.heartBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.heartBtn setImage:[UIImage imageNamed:@"ic_heart_n"] forState:UIControlStateNormal];
    [self.heartBtn setImage:[UIImage imageNamed:@"ic_heart_s"] forState:UIControlStateSelected];
    [self addSubview:self.heartBtn];
    
    self.dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dateBtn setTitle:[NSString stringWithFormat:@"  约%@", [QMMUserContext shareContext].objectCall]
                  forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.dateBtn setImage:[UIImage imageNamed:@"ic_date_n"] forState:UIControlStateNormal];
    [self addSubview:self.dateBtn];
    
    
    self.msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.msgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.msgBtn setTitle:@"  私信" forState:UIControlStateNormal];
    [self.msgBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.msgBtn setImage:[UIImage imageNamed:@"ic_msg_n"] forState:UIControlStateNormal];
    [self addSubview:self.msgBtn];
}

- (void)setupSubvewsLayout {
    [self.heartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.equalTo(self).multipliedBy(0.3);
    }];
    
    [self.dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.bottom.equalTo(self.heartBtn);
        make.left.equalTo(self.heartBtn.mas_right);
    }];
    
    [self.msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.bottom.equalTo(self.heartBtn);
        make.left.equalTo(self.dateBtn.mas_right);
    }];
}

@end
