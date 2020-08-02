//
//  HYIdentifyInfoCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYIdentifyInfoCell.h"


@interface HYIdentifyInfoCell ()

@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation HYIdentifyInfoCell

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
    @weakify(self);
    [RACObserve(self, cellModel) subscribeNext:^(HYIdentifyCellModel *_Nullable x) {
        @strongify(self);
        [self.titleBtn setImage:[UIImage imageNamed:x.icon] forState:UIControlStateNormal];
        [self.titleBtn setTitle:[NSString stringWithFormat:@"  %@", x.title] forState:UIControlStateNormal];
        self.infoLabel.text = x.info;
    }];
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _titleBtn = [UIButton buttonWithTitle:nil
                               titleColor:[UIColor colorWithHexString:@"#4A4A4A"]
                                 font:[UIFont systemFontOfSize:16]
                                  bgColor:nil
                                   inView:self.contentView
                                   action:NULL];
    _infoLabel = [UILabel labelWithText:nil
                              textColor:[UIColor colorWithHexString:@"#7D7D7D"]
                               font:[UIFont systemFontOfSize:14]
                                 inView:self.contentView
                              tapAction:NULL];
    _infoLabel.numberOfLines = 0;
}

- (void)setupSubviewsLayout {
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(30);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(45);
        make.right.offset(-20);
        make.top.equalTo(self.titleBtn.mas_bottom).offset(10);
        make.bottom.offset(0);
    }];
}
@end
