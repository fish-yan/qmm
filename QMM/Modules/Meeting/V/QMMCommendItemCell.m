//
//  QMMCommendItemCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMCommendItemCell.h"

@implementation QMMCommendItemCell

-  (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubvews];
        [self setupSubvewsLayout];
    }
    
    return self;
}

- (void)setupSubvews {
    _iconView = [UIImageView imageViewWithImageName:AVATAR_PLACEHOLDER inView:self];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.clipsToBounds = YES;
    _iconView.layer.cornerRadius = 70 * 0.5;
    
    _tagView = [UIImageView imageViewWithImageName:@"heart_n" inView:self];
    _tagView.clipsToBounds = YES;
    _tagView.layer.cornerRadius = 15;
    
    _infoLabel = [UILabel labelWithText:@"上海/23岁"
                              textColor:[UIColor colorWithHexString:@"#3A444A"]
                                   font:[UIFont systemFontOfSize:12]
                                 inView:self
                              tapAction:NULL];
}

- (void)setHadHeart:(BOOL)hasHeart {
    _hadHeart = hasHeart;
    if (hasHeart) {
        _tagView.image = [UIImage imageNamed:@"heart_s"];
    } else {
        _tagView.image = [UIImage imageNamed:@"heart_n"];
    }
    
}

- (void)setupSubvewsLayout {
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.equalTo(self.iconView).offset(-2.1);
        make.right.equalTo(self.iconView);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconView.mas_bottom).offset(20);
    }];
}

@end
