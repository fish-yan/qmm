//
//  QMMProfileInvationCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/11/13.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMProfileInvationCell.h"

@interface QMMProfileInvationCell ()

@property (nonatomic, strong) UILabel *mainTitle;
@property (nonatomic, strong) UILabel *subTitle;

@end

@implementation QMMProfileInvationCell


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
    self.backgroundColor = [UIColor colorWithHexString:@"#BDFDD7"];
}


#pragma mark - Bind

- (void)bind {
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _mainTitle = [UILabel labelWithText:@"邀请10名好友得250元现金"
                              textColor:[UIColor colorWithHexString:@"#464646"]
                          textAlignment:NSTextAlignmentCenter
                                   font:[UIFont boldSystemFontOfSize:26]
                                 inView:self.contentView
                              tapAction:nil];
    
    _subTitle = [UILabel labelWithText:@"(可立即提现)"
                             textColor:[UIColor colorWithHexString:@"#3B2C37"]
                         textAlignment:NSTextAlignmentCenter
                                  font:[UIFont systemFontOfSize:20]
                                inView:self.contentView
                             tapAction:nil];
    
}

- (void)setupSubviewsLayout {
    [_mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.offset(30);
    }];
    
    [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.mainTitle.mas_bottom).offset(10);
    }];
}


#pragma mark - Lazy Loading
@end
