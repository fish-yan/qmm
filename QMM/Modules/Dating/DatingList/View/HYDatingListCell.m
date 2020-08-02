//
//  HYDatingListCell.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "HYDatingListCell.h"

@interface HYDatingListCell ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *avatorView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *addressTitleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *statusTitleLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation HYDatingListCell

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
    self.backgroundColor = [UIColor clearColor];
    
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [RACObserve(self, model.avatar) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.avatorView sd_setImageWithURL:[NSURL URLWithString:x ?: @""] placeholderImage:[UIImage imageNamed:@"pman"]];
    }];
    
    RAC(self.nameLabel, text) = RACObserve(self, model.name);
    RAC(self.timeLabel, text) = RACObserve(self, model.appointmentdate);
    RAC(self.addressLabel, text) = RACObserve(self, model.address);
    RAC(self.statusLabel, text) = RACObserve(self, model.appstatus2);
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _container = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:self.contentView];
//    _container.clipsToBounds = YES;
    _container.layer.cornerRadius = 5;
    _container.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _container.layer.shadowOpacity = 0.2;
    _container.layer.shadowRadius = 1;
    _container.layer.borderColor = [UIColor colorWithHexString:@"#E7E7E7"].CGColor;
    _container.layer.borderWidth = 0.4;
    _container.layer.shadowOffset = CGSizeMake(0, 0);
    
    
    _avatorView = [UIImageView imageViewWithImageName:nil inView:self.container];
    _avatorView.clipsToBounds = YES;
    _avatorView.layer.cornerRadius = 20;
    
    
    _nameLabel = [UILabel labelWithText:nil
                              textColor:[UIColor colorWithHexString:@"#4A4A4A"]
                               font:[UIFont systemFontOfSize:16]
                                 inView:self.container
                              tapAction:NULL];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    
    UIColor *color = [UIColor colorWithHexString:@"#313131"];
    _timeTitleLabel = [UILabel labelWithText:@"约会时间"
                              textColor:color
                               font:[UIFont systemFontOfSize:14]
                                 inView:self.container
                              tapAction:NULL];
    _timeLabel = [UILabel labelWithText:nil
                                   textColor:color
                                    font:[UIFont systemFontOfSize:14]
                                      inView:self.container
                                   tapAction:NULL];
    _addressTitleLabel = [UILabel labelWithText:@"约会地点"
                              textColor:color
                               font:[UIFont systemFontOfSize:14]
                                 inView:self.container
                              tapAction:NULL];
    _addressLabel = [UILabel labelWithText:nil
                              textColor:color
                               font:[UIFont systemFontOfSize:14]
                                 inView:self.container
                              tapAction:NULL];
    _statusTitleLabel = [UILabel labelWithText:@"状态"
                              textColor:color
                               font:[UIFont systemFontOfSize:14]
                                 inView:self.container
                              tapAction:NULL];
    _statusLabel = [UILabel labelWithText:nil
                                textColor:[UIColor colorWithHexString:@"#313131"]
                               font:[UIFont systemFontOfSize:14]
                                 inView:self.container
                              tapAction:NULL];
    
    _nameLabel.text = @"张三";
    _timeLabel.text = @"2018.3.12";
    _addressLabel.text = @"啊哈哈哈哈哈哈哈哈哈哈哈哈";
    _statusLabel.text = @"带映月";
    
}


- (void)setupSubviewsLayout {
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
        make.bottom.equalTo(self.contentView);
    }];
    
    CGFloat padding = 20;
    [_avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.top.offset(20);
        make.left.offset(padding);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatorView.mas_right).offset(15);
        make.centerY.equalTo(_avatorView);
    }];
    
    //
    [_timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(padding);
        make.top.equalTo(_avatorView.mas_bottom).offset(20);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeTitleLabel.mas_right).offset(10);
        make.centerY.equalTo(_timeTitleLabel);
    }];
    
    //
    [_addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeTitleLabel.mas_bottom).offset(10);
        make.left.offset(padding);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressTitleLabel.mas_right).offset(10);
        make.centerY.equalTo(_addressTitleLabel);
        make.right.lessThanOrEqualTo(self.container).offset(-padding);
    }];
    
    //
    [_statusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressLabel.mas_bottom).offset(10);
        make.left.offset(padding);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusTitleLabel.mas_right).offset(10);
        make.centerY.equalTo(_statusTitleLabel);
    }];
}


#pragma mark - Lazy Loading
@end
