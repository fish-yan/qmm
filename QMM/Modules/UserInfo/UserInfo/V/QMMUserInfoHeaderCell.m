//
//  QMMUserInfoHeaderCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMUserInfoHeaderCell.h"

@interface QMMUserInfoHeaderCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation QMMUserInfoHeaderCell

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
    self.clipsToBounds = YES;
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [RACObserve(self, cellModel.value) subscribeNext:^(NSString * _Nullable x) {
        if (!x || x.length == 0) return;
        
        @strongify(self);
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:x]
                        placeholderImage:[UIImage imageNamed:@"img_placeholder_b"]];
    }];
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _imgView = [UIImageView imageViewWithImageName:@"img_placeholder_b" inView:self.contentView];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setupSubviewsLayout {
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
@end
