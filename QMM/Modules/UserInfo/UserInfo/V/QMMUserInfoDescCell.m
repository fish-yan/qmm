//
//  QMMUserInfoDescCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMUserInfoDescCell.h"


@interface QMMUserInfoDescCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@end


@implementation QMMUserInfoDescCell

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
    //    @weakify(self);
    //    [RACObserve(self, cellModel) subscribeNext:^(QMMUserInfoCellModel * _Nullable x) {
    //        @strongify(self);
    //        self.titleLabel.text = x.title;
    //        self.infoLabel.text = x.desc;
    //    }];
    RAC(self.titleLabel, text) = RACObserve(self, cellModel.title);
    RAC(self.infoLabel, text) = RACObserve(self, cellModel.desc);
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _titleLabel = [UILabel labelWithText:nil
                               textColor:[UIColor colorWithHexString:@"#313131"]
                                font:[UIFont systemFontOfSize:14]
                                  inView:self.contentView
                               tapAction:NULL];
    
    _infoLabel = [UILabel labelWithText:nil
                              textColor:[UIColor colorWithHexString:@"#7D7D7D"]
                               font:[UIFont systemFontOfSize:14]
                                 inView:self.contentView
                              tapAction:NULL];
    _infoLabel.numberOfLines = 0;
}

- (void)setupSubviewsLayout {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(20);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(self.titleLabel);
        make.right.offset(-15);
        make.bottom.offset(-20);
    }];
    
}

@end
