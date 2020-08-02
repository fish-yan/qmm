//
//  HYFilterListCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYFilterListCell.h"

@interface HYFilterListCell ()

@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIButton *infoBtn;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation HYFilterListCell

#pragma mark - Initialize

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
        [self setupSubviews];
        [self bind];
    }
    return self;
}

- (void)initialize {
    self.showBottomLine = YES;
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [RACObserve(self, cellModel.name) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.titleBtn setTitle:[NSString stringWithFormat:@"  %@", x] forState:UIControlStateNormal];
    }];
    
    [RACObserve(self, cellModel.icon) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.titleBtn setImage:[UIImage imageNamed:x] forState:UIControlStateNormal];
    }];
    
    [[RACObserve(self, cellModel.isLocked) merge:RACObserve(self, cellModel.info)]
     subscribeNext:^(id  _Nullable x) {
         @strongify(self);
         if (self.cellModel.isLocked) {
             [self.infoBtn setImage:[UIImage imageNamed:@"filter_lock"] forState:UIControlStateNormal];
         } else {
             [self.infoBtn setImage:nil forState:UIControlStateNormal];
             [self.infoBtn setTitle:self.cellModel.info forState:UIControlStateNormal];
         }
     }];
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _titleBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithHexString:@"43484D"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:btn];
        btn;
    });
    _infoBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:btn];
        btn;
    });
    _arrow = [UIImageView imageViewWithImageName:@"cellarrow" inView:self.contentView];
    
    
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.offset(15);
    }];
    
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(self.arrow.image.size);
    }];
    
    [_infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.arrow.mas_left).offset(-10);
    }];
}
@end
