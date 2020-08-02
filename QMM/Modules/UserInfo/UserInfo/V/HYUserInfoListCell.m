//
//  HYUserInfoListCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUserInfoListCell.h"

@interface HYUserInfoListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation HYUserInfoListCell

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
    self.showBottomLine = NO;
}


#pragma mark - Bind

- (void)bind {
    RAC(self.titleLabel, text) = RACObserve(self, cellModel.title);
    
    @weakify(self);
    RAC(self.infoLabel, text) = [RACObserve(self, cellModel.desc) map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self);
        if (!value || value.length == 0) {
            self.infoLabel.textColor = [UIColor colorWithHexString:@"#BCBCBC"];
        }
        if (!value) {
            return @"";
            //            return @"未填写";
        }
        self.infoLabel.textColor = [UIColor colorWithHexString:@"#313131"];
        return value;
    }];
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
