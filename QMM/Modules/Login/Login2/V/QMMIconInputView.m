//
//  QMMIconInputView.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/27.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMIconInputView.h"

@interface QMMIconInputView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *iconBtn;

@end

@implementation QMMIconInputView

+ (instancetype)viewWithNormalIcon:(NSString *)normalIcon
                        focusIcon:(NSString *)focusIcon
                       placeHolder:(NSString *)placeHolder {
    QMMIconInputView *v = [QMMIconInputView new];
    v.normalIcon = normalIcon;
    v.focusIcon = focusIcon;
    v.placeHolder = placeHolder;
    
    [v layoutIfNeeded];
    
    return v;
}

- (void)setFocus:(BOOL)focus {
    _focus = focus;
    
    UIColor *color = [UIColor colorWithHexString:@"#464646"];
    if (focus) {
        color = [UIColor colorWithHexString:@"#FF758C"];
    }
    
    self.textField.textColor = color;
    self.layer.borderColor = color.CGColor;
    self.iconBtn.selected = focus;
}

- (void)setNormalIcon:(NSString *)normalIcon {
    _normalIcon = normalIcon;
    [self.iconBtn setImage:[UIImage imageNamed:_normalIcon] forState:UIControlStateNormal];
}

- (void)setFocusIcon:(NSString *)focusIcon {
    _focusIcon = focusIcon;
    [self.iconBtn setImage:[UIImage imageNamed:_focusIcon] forState:UIControlStateSelected];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
}

-  (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubvews];
        [self bind];
    }
    
    return self;
}

- (void)setupSubvews {
    _iconBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:btn];
        btn;
    });
    
    _textField = ({
        UITextField *tf = [UITextField textFieldWithText:nil
                                               textColor:[UIColor colorWithHexString:@"#464646"]
                                                    font:[UIFont systemFontOfSize:14]
                                             placeHolder:self.placeHolder
                                        placeHolderColor:[UIColor colorWithHexString:@"#A5A5A5"]
                                             andDelegate:self
                                                  inView:self];
        tf;
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(15);
        make.size.mas_equalTo(CGSizeMake(18, 20));
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.left.equalTo(self.iconBtn.mas_right).offset(10);
    }];
}

- (void)bind {
    @weakify(self);
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        self.focus = YES;
    }];
    
    [[self rac_signalForSelector:@selector(textFieldDidEndEditing:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        self.focus = NO;
    }];
    
    RAC(self.iconBtn, selected) = RACObserve(self, focus);
    
    RAC(self, content) = self.textField.rac_textSignal;
}



@end
