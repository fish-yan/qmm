//
//  QMMPrivateMsgDateCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMPrivateMsgDateCell.h"

@interface QMMPrivateMsgDateCell ()
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *titileBgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *appointmentdateLabel;
@property (nonatomic, strong) UILabel *appointmentaddress;
@property (nonatomic, strong) UILabel *lookDetailLabel;

@end

@implementation QMMPrivateMsgDateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupview];
        [self layout];
        [self bindmodel];
    }
    return self;
}
- (void)setupview {
    self.avatar = [UIImageView
    imageViewWithImageName:@"man"
                    inView:self.contentView
                 tapAction:^(UIImageView *imgView, UIGestureRecognizer *tap) {

                     if (self.model.isself) {
                         return;
                     }
                     NSDictionary *params = @{ @"uid": self.model.uid ?: @"" };
                     [YSMediator pushToViewController:kModuleUserInfo withParams:params animated:YES callBack:NULL];
                 }];
    self.avatar.contentMode = UIViewContentModeScaleToFill;
    [self.avatar.layer setMasksToBounds:YES];
    [self.avatar.layer setCornerRadius:15];

    self.bgView = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:self.contentView];

    [self.bgView.layer setMasksToBounds:YES];
    [self.bgView.layer setBorderColor:[UIColor colorWithHexString:@"#7D7D7D"].CGColor];
    [self.bgView.layer setBorderWidth:0.5];

    self.titileBgView = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:self.bgView];

    CAGradientLayer *layer = [CAGradientLayer new];

    layer.colors = @[
        (__bridge id) [UIColor colorWithHexString:@"#FF599E"].CGColor,
        (__bridge id) [UIColor colorWithHexString:@"#FFAB68"].CGColor
    ];
    layer.startPoint = CGPointMake(0, 1);
    layer.endPoint   = CGPointMake(1, 1);
    layer.frame      = self.bounds;
    [self.titileBgView.layer addSublayer:layer];

    self.titleLabel = [UILabel labelWithText:@"哈哈"
                                   textColor:[UIColor whiteColor]
                                    font:[UIFont systemFontOfSize:15]
                                      inView:self.bgView
                                   tapAction:nil];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.appointmentdateLabel     = [UILabel labelWithText:@"约会时间：2018.3.12 12:30"
                                             textColor:[UIColor colorWithHexString:@"#313131"]
                                              font:[UIFont systemFontOfSize:15]
                                                inView:self.bgView
                                             tapAction:nil];
    self.appointmentdateLabel.numberOfLines = 0;
    self.appointmentdateLabel.textAlignment = NSTextAlignmentLeft;
    self.appointmentdateLabel.textAlignment = NSTextAlignmentLeft;
    self.appointmentaddress = [UILabel labelWithText:@"约会地点：曼哈顿自助海鲜（百联滨江店）"
                                           textColor:[UIColor colorWithHexString:@"#313131"]
                                            font:[UIFont systemFontOfSize:15]
                                              inView:self.bgView
                                           tapAction:nil];
    self.appointmentaddress.numberOfLines = 0;
    self.appointmentaddress.textAlignment = NSTextAlignmentLeft;

    self.lookDetailLabel = [UILabel labelWithText:@"查看详情"
                                        textColor:[UIColor colorWithHexString:@"#7D7D7D"]
                                         font:[UIFont systemFontOfSize:12]
                                           inView:self.bgView
                                        tapAction:nil];
    CALayer *l        = [CALayer new];
    l.backgroundColor = [UIColor colorWithHexString:@"#7D7D7D"].CGColor;
    float w           = SCREEN_WIDTH - 110;
    l.frame           = CGRectMake(0, 0, w, 0.5);
    [self.lookDetailLabel.layer addSublayer:l];
    self.lookDetailLabel.textAlignment = NSTextAlignmentCenter;
}
- (void)layout {
    @weakify(self);
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.mas_left).offset(60);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    [self.titileBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
        make.top.equalTo(self.bgView.mas_top);
        make.height.equalTo(@40);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
        make.top.equalTo(self.bgView.mas_top);
        make.height.equalTo(@40);
    }];

    [self.appointmentdateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.top.equalTo(self.titileBgView.mas_bottom).offset(20);
    }];
    [self.appointmentaddress mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.top.equalTo(self.appointmentdateLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-59);
    }];
    [self.lookDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
        make.top.equalTo(self.bgView.mas_bottom).offset(-37);
        make.bottom.equalTo(self.bgView.mas_bottom);
    }];
}
- (void)bindmodel {
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(QMMPrivateMsgModel *_Nullable x) {
        @strongify(self);
        self.titleLabel.text = x.appointmentstatus;
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:x.useravatar]
                       placeholderImage:[UIImage imageNamed:@"man"]];
        self.appointmentdateLabel.text = [NSString stringWithFormat:@"约会时间：%@", x.appointmentdate];
        self.appointmentaddress.text   = [NSString stringWithFormat:@"约会地点：%@", x.appointmentaddress];
        if (x.isself) {
            [self.avatar mas_remakeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.right.equalTo(self.contentView.mas_right).offset(-15);
                make.size.mas_equalTo(CGSizeMake(30, 30));
                make.top.equalTo(self.contentView.mas_top).offset(10);
            }];

            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.contentView.mas_left).offset(50);
                make.top.equalTo(self.contentView.mas_top).offset(10);
                make.right.equalTo(self.contentView.mas_right).offset(-60);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }];

        } else {
            [self.avatar mas_remakeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.contentView.mas_left).offset(15);
                make.size.mas_equalTo(CGSizeMake(30, 30));
                make.top.equalTo(self.contentView.mas_top).offset(10);
            }];

            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.contentView.mas_left).offset(60);
                make.top.equalTo(self.contentView.mas_top).offset(10);
                make.right.equalTo(self.contentView.mas_right).offset(-50);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }];
        }
    }];
}
@end
