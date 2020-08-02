//
//  HYUserInfoCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUserInfoCell.h"
#import "HYUserInfoModel.h"

@interface NSMutableAttributedString (AppendOval)

- (NSMutableAttributedString *)appendString:(NSString *)str;

@end

@implementation NSMutableAttributedString (AppendOval)

- (NSMutableAttributedString *)appendString:(NSString *)str {
    if (!str) return self;
    
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"user_info_gray_oval"];
    NSAttributedString *oval = [NSMutableAttributedString attributedStringWithAttachment:attach];
    [self appendAttributedString:oval];
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", str]]];
    
    return self;
}

@end

@interface HYUserInfoCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *marryDateBtn;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *localLabel;

@end

@implementation HYUserInfoCell

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
    [RACObserve(self, cellModel) subscribeNext:^(HYUserInfoCellModel * _Nullable x) {
        if (!x) return;
        
        @strongify(self);
        HYUserInfoModel *m = x.value;
        NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc]
                                               initWithString:[NSString stringWithFormat:@"%@岁", m.age]];
        self.infoLabel.attributedText = [[[attrStrM
                                           appendString:[NSString stringWithFormat:@"%@", m.height ?: @"-"]]
                                          appendString:m.msalary]
                                         appendString:m.constellation ?: @""];
        
        self.nameLabel.text = m.name;
        [self.marryDateBtn setTitle:[NSString stringWithFormat:@"  %@", m.wantmarry ?: @""] forState:UIControlStateNormal];
        self.localLabel.text = m.workcity;
    }];
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _nameLabel = [UILabel labelWithText:@"姓名"
                              textColor:[UIColor colorWithHexString:@"#4A4A4A"]
                               font:[UIFont systemFontOfSize:20]
                                 inView:self.contentView
                              tapAction:NULL];
    _nameLabel.font = [UIFont boldSystemFontOfSize:20];
    
    _marryDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _marryDateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_marryDateBtn setImage:[UIImage imageNamed:@"user_info_oval"] forState:UIControlStateNormal];
    [_marryDateBtn setTitle:@"  一年内" forState:UIControlStateNormal];
    [_marryDateBtn setTitleColor:[UIColor colorWithHexString:@"#FF8BB1"] forState:UIControlStateNormal];
    [self.contentView addSubview:_marryDateBtn];
    
    
    _infoLabel = [UILabel labelWithText:nil
                              textColor:[UIColor colorWithHexString:@"#464446"]
                               font:[UIFont systemFontOfSize:13]
                                 inView:self.contentView
                              tapAction:NULL];
    
    _localLabel =  [UILabel labelWithText:@"上海"
                                textColor:[UIColor colorWithHexString:@"#464446"]
                                 font:[UIFont systemFontOfSize:13]
                                   inView:self.contentView
                                tapAction:NULL];
}

- (void)setupSubviewsLayout {
    [_marryDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(20);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(20);
        make.right.lessThanOrEqualTo(self.marryDateBtn.mas_left).offset(-15);
    }];
    
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.offset(-20);
    }];
    
    [_localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.bottom.offset(-20);
    }];
}


@end
