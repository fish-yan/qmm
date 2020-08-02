//
//  HYProfileMenuListCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYProfileMenuListCell.h"

@interface HYProfileMenuListCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation HYProfileMenuListCell

#pragma mark - Initialize

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
        [self setupSubviews];
        [self setupSubviewsLayout];
        [self bind];
    }
    return self;
}

- (void)initialize {
    
}


#pragma mark - Bind

- (void)bind {
    RAC(self.titleLabel, text) = RACObserve(self, cellModel.title);
    RAC(self.infoLabel, text) = RACObserve(self, cellModel.desc);
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _titleLabel = [UILabel labelWithText:nil
                               textColor:[UIColor colorWithHexString:@"#43484D"]
                                font:[UIFont systemFontOfSize:14]
                                  inView:self.contentView
                               tapAction:NULL];
    
    _arrow = [UIImageView imageViewWithImageName:@"arrowright" inView:self.contentView];
    
    _infoLabel = [UILabel labelWithText:nil
                              textColor:[UIColor colorWithHexString:@"#313131"]
                               font:[UIFont systemFontOfSize:14]
                                 inView:self.contentView
                              tapAction:NULL];
}

- (void)setupSubviewsLayout {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrow.image.size);
        make.centerY.offset(0);
        make.right.offset(-15);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.arrow.mas_left).offset(-5);
    }];
    
    self.showBottomLine = NO;
    UIView *line = [UIView viewWithBackgroundColor:[UIColor colorWithHexString:@"#E7E7E7"] inView:self.contentView];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

@end
