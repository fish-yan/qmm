//
//  HYDatingRuleCell.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "HYDatingRuleCell.h"

@implementation HYDatingRuleCell

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
    RAC(self.infoLabel, attributedText) = [[RACObserve(self, info)
                                  filter:^BOOL(id  _Nullable value) {
                                      return value != nil;
                                  }]
                                 map:^id _Nullable(NSString * _Nullable value) {
                                     NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
                                     parag.paragraphSpacing = 15.0;
                                     parag.lineSpacing = 5;
                                     NSAttributedString *attr = [[NSAttributedString alloc]
                                                                 initWithString:value
                                                                 attributes:@{NSParagraphStyleAttributeName: parag,
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                        }];
                                     return attr;
                                 }];
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _titleLabel = [UILabel labelWithText:nil
                               textColor:[UIColor colorWithHexString:@"#313131"]
                                font:[UIFont systemFontOfSize:16]
                                  inView:self.contentView
                               tapAction:NULL];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    _infoLabel = [UILabel labelWithText:nil
                               textColor:[UIColor colorWithHexString:@"43484D"]
                                font:[UIFont systemFontOfSize:14]
                                  inView:self.contentView
                               tapAction:NULL];
    _infoLabel.numberOfLines = 0;
    _infoLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setupSubviewsLayout {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(25);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(_titleLabel.mas_bottom).offset(20);
        make.right.offset(-20);
        make.bottom.offset(-20);
    }];
}


#pragma mark - Lazy Loading
@end
