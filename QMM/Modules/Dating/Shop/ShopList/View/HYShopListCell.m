//
//  HYShopListCell.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/24.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYShopListCell.h"

@interface HYShopListCell()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UILabel *rangeLabel;

@end

@implementation HYShopListCell

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

- (UILabel *)createMainTitle {
    return [UILabel labelWithText:nil
                        textColor:[UIColor colorWithHexString:@"#030303"]
                             font:[UIFont systemFontOfSize:16]
                           inView:self.contentView tapAction:NULL];
}

- (UILabel *)createInfoTitle {
    return [UILabel labelWithText:nil
                        textColor:[UIColor colorWithHexString:@"#7D7D7D"]
                         font:[UIFont systemFontOfSize:14]
                           inView:self.contentView
                        tapAction:NULL];
}
#pragma mark - Bind

- (void)bind {
    RAC(self.titleLabel, text) = RACObserve(self, model.name);
    RAC(self.priceLabel, text) = [RACObserve(self, model.price)
                                  map:^id _Nullable(id  _Nullable value) {
                                      id v = ([value doubleValue] > 0.0) ? value: @"-";
                                      return [NSString stringWithFormat:@"¥%@元/人", v];
                                  }];
    RAC(self.typeLabel, text) = RACObserve(self, model.type);
    RAC(self.areaLabel, text) = RACObserve(self, model.businessArea);
    RAC(self.rangeLabel, text) = [RACObserve(self, model.range)
                                  map:^id _Nullable(id  _Nullable value) {
                                      return [NSString stringWithFormat:@"%@米", value];
                                  }];
    
    @weakify(self);
    [RACObserve(self, model.images) subscribeNext:^(NSArray * _Nullable x) {
        @strongify(self);
        NSString *url = [x firstObject];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:url?:@""]
                         placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    }];
    
    // 如果是城市关键字搜索的, 不显示距离
    RAC(self.rangeLabel, hidden) = RACObserve(self, isCitySearch);
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _iconView = [UIImageView imageViewWithImageName:@"defaultImage" inView:self.contentView];
    _iconView.layer.cornerRadius = 8;
    _iconView.clipsToBounds = YES;
    
    _titleLabel = [self createMainTitle];
    _priceLabel = [self createMainTitle];
    _typeLabel = [self createInfoTitle];
    _areaLabel = [self createInfoTitle];
    _rangeLabel = [self createInfoTitle];
}

- (void)setupSubviewsLayout {
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 80));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView);
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.right.offset(-15);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(_titleLabel);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_iconView);
        make.left.equalTo(_iconView.mas_right).offset(10);
    }];
    
    [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_iconView);
        make.left.equalTo(_typeLabel.mas_right).offset(10);
    }];
    
    [_rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_iconView);
        make.right.offset(-15);
    }];
}


#pragma mark - Lazy Loading

@end
