//
//  HYPrivateListCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYPrivateListCell.h"
#import "HYPrivateCellViewModel.h"
#import "HYPrivateCellViewModel.h"

@interface HYPrivateListCell ()
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *userNamelabel;
@property (nonatomic, strong) UILabel *timelabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *lastMessageLabel;
//@property (nonatomic ,strong) UIView  *isReadView;

@property (nonatomic, strong) UILabel *badgeLabel;

@property (nonatomic, strong) HYPrivateCellViewModel *viewModel;

@end

@implementation HYPrivateListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpView];
        [self setLayout];
        [self bindModel];
    }
    return self;
}


- (void)setUpView {
    self.avatarView = [UIImageView
    imageViewWithImageName:@"man"
                    inView:self.contentView
                 tapAction:^(UIImageView *imgView, UIGestureRecognizer *tap) {


                     NSDictionary *params = @{ @"uid": self.viewModel.uid ?: @"" };
                     [YSMediator pushToViewController:kModuleUserInfo withParams:params animated:YES callBack:NULL];

                 }];

    self.userNamelabel = [UILabel labelWithText:@"张"
                                      textColor:[UIColor tc3Color]
                                           font:[UIFont systemFontOfSize:15]
                                         inView:self.contentView
                                      tapAction:nil];
    self.timelabel = [UILabel labelWithText:@"一小时前"
                                  textColor:[UIColor tc4Color]
                                   font:[UIFont systemFontOfSize:12]
                                     inView:self.contentView
                                  tapAction:nil];
    self.timelabel.textAlignment = NSTextAlignmentRight;
    self.lastMessageLabel        = [UILabel labelWithText:@"一小时前"
                                         textColor:[UIColor tc8Color]
                                          font:[UIFont systemFontOfSize:14]
                                            inView:self.contentView
                                         tapAction:nil];
    self.lastMessageLabel.textAlignment = NSTextAlignmentLeft;
    self.lastMessageLabel.numberOfLines = 1;

    self.desLabel = [UILabel labelWithText:@""
                                 textColor:[UIColor tc4Color]
                                  font:[UIFont systemFontOfSize:14]
                                    inView:self.contentView
                                 tapAction:nil];
    self.desLabel.textAlignment = NSTextAlignmentLeft;

    _badgeLabel = [UILabel labelWithText:@" +99+ "
                               textColor:[UIColor whiteColor]
                                font:[UIFont systemFontOfSize:9]
                                  inView:self.contentView
                               tapAction:NULL];
    _badgeLabel.backgroundColor    = [UIColor redColor];
    _badgeLabel.layer.cornerRadius = 6;
    _badgeLabel.clipsToBounds      = YES;
}


- (void)setLayout {
    @weakify(self);
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.avatarView.layer setMasksToBounds:YES];
    [self.avatarView.layer setCornerRadius:20];

    [self.userNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.avatarView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.height.equalTo(@15);
    }];
    [self.timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.userNamelabel.mas_centerY);
        make.height.equalTo(@12);
        make.left.equalTo(self.userNamelabel.mas_right).offset(15);
    }];

    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.avatarView.mas_right).offset(10);
        make.top.equalTo(self.userNamelabel.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];

    [self.lastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.userNamelabel.mas_left);
        make.top.equalTo(self.desLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-58);
        make.height.equalTo(@14);
    }];

    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timelabel);
        make.centerY.equalTo(self.lastMessageLabel);
    }];
}


- (void)bindWithViewModel:(id)vm {
    if (vm && [vm isKindOfClass:[HYPrivateCellViewModel class]]) {
        self.viewModel = (HYPrivateCellViewModel *) vm;
    }
}


- (void)bindModel {
    @weakify(self);

    [RACObserve(self, viewModel.phtotUrl) subscribeNext:^(NSURL *x) {
        @strongify(self);
        if (x) {
            NSString *string = [self.viewModel.fromsex isEqualToString:@"男"] ? @"man" : @"woman";
            [self.avatarView sd_setImageWithURL:x placeholderImage:[UIImage imageNamed:string]];
        }
    }];

    RAC(self.desLabel, attributedText) = RACObserve(self, viewModel.des);
    RAC(self.userNamelabel, text)      = RACObserve(self, viewModel.userName);
    RAC(self.timelabel, text)          = RACObserve(self, viewModel.time);
    RAC(self.lastMessageLabel, text)   = RACObserve(self, viewModel.lastMessage);

    [RACObserve(self, viewModel.isVip) subscribeNext:^(NSNumber *_Nullable x) {
        @strongify(self);
        if ([x intValue] > 0) {
            self.lastMessageLabel.textColor = [UIColor tc8Color];
        } else {
            self.lastMessageLabel.textColor = [UIColor tc3Color];
        }
    }];

    RAC(self.badgeLabel, text) = RACObserve(self, viewModel.newcount);
    [RACObserve(self, viewModel.hasRead) subscribeNext:^(id _Nullable x) {
        @strongify(self);
        self.badgeLabel.hidden = [x boolValue];
    }];
}
@end
