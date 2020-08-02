//
//  QMMContactItemView.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMContactItemView.h"
#import "QMMContactItemVM.h"

@interface QMMContactItemView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *AgeAndCity;
@property (nonatomic, strong) UIButton *heartButton;
@property (nonatomic, strong) UIButton *meetButton;
@property (nonatomic, strong) UIButton *talkButton;
@property (nonatomic, strong) UIImageView *badgeImgV;

@property (nonatomic, strong) QMMContactItemVM *viewModel;
@end


@implementation QMMContactItemView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        [self layout];
        [self bindmodel];
    }
    return self;
}

- (void)setUpView {
    self.bgView = [UIView
    viewWithBackgroundColor:[UIColor redColor]
                     inView:self
                  tapAction:^(UIView *view, UIGestureRecognizer *tap) {
                      if (![self.viewModel.isView boolValue]) {
                          [self.viewModel.markCmd execute:nil];
                      }

                      NSDictionary *params = @{ @"uid": self.viewModel.userID ?: @"" };
                      [YSMediator pushToViewController:kModuleUserInfo withParams:params animated:YES callBack:NULL];
                  }];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.bgView.layer setMasksToBounds:YES];
    [self.bgView.layer setCornerRadius:5];
    [self.bgView.layer setBorderWidth:0.5];
    [self.bgView.layer setBorderColor:[UIColor colorWithHexString:@"#E7E7E7"].CGColor];
    [self addSubview:self.bgView];

    self.headView = [UIImageView imageViewWithImageName:@"img_placeholder_a" inView:self.bgView];

    [self.headView.layer setMasksToBounds:YES];
    [self.headView.layer setCornerRadius:35];


    self.nickNameLabel = [UILabel labelWithText:@""
                                      textColor:[UIColor colorWithHexString:@"#030303"]
                                       font:[UIFont pingFongFontOfSize:16]
                                         inView:self.bgView
                                      tapAction:nil];
    self.AgeAndCity = [UILabel labelWithText:@"29岁* 广州"
                                   textColor:[UIColor colorWithHexString:@"#7D7D7D"]
                                    font:[UIFont pingFongFontOfSize:13]
                                      inView:self.bgView
                                   tapAction:nil];
    self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
    self.AgeAndCity.textAlignment    = NSTextAlignmentCenter;

    @weakify(self);
    self.heartButton = [UIButton buttonWithNormalImgName:@"ic_heart_n"
                                                 bgColor:[UIColor clearColor]
                                                  inView:self.bgView
                                                  action:^(UIButton *btn) {
                                                      @strongify(self);
                                                      [self.viewModel.heartCmd execute:@{
                                                          @"uid": self.viewModel.userID,
                                                          @"type": self.viewModel.heartType
                                                      }];
                                                      self.viewModel.heartType = @(![self.viewModel.heartType boolValue]);
                                                  }];
    self.meetButton = [UIButton buttonWithNormalImgName:@"ic_contact_date"
                                                bgColor:[UIColor clearColor]
                                                 inView:self.bgView
                                                 action:^(UIButton *btn) {
                                                     @strongify(self);
                                                     [YSProgressHUD showTips:@"敬请期待"];
//                                                     [YSMediator pushToViewController:kModuleDatingInfo
//                                                                           withParams:@{
//                                                                               @"dataID": self.viewModel.userID ?: @""
//                                                                           }
//                                                                             animated:YES
//                                                                             callBack:NULL];
                                                 }];
    self.talkButton =
    [UIButton buttonWithNormalImgName:@"ic_msg_n"
                              bgColor:[UIColor clearColor]
                               inView:self.bgView
                               action:^(UIButton *btn) {
                                   @strongify(self);
                                   if (![[QMMUserContext shareContext].userModel.vipstatus boolValue]) {
                                       [YSMediator pushToViewController:kModuleMembership
                                                             withParams:@{}
                                                               animated:YES
                                                               callBack:nil];
                                       return;
                                   }
                                   [YSMediator pushToViewController:kMessageDetail
                                                         withParams:@{
                                                             @"cantactName": self.viewModel.nickname,
                                                             @"cantactID": self.viewModel.userID,
                                                             @"avatar": [self.viewModel.avatar path]
                                                         }
                                                           animated:YES
                                                           callBack:nil];
                               }];


    self.badgeImgV        = [UIImageView imageViewWithImageName:@"ic_contact_badge" inView:self.bgView];
    self.badgeImgV.hidden = YES;
}

- (void)layout {
    @weakify(self);

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self.mas_top).offset(30);
        make.height.equalTo(@188);
    }];

    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.top.equalTo(self.bgView.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];

    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.headView.mas_bottom).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.height.equalTo(@15);
    }];
    [self.AgeAndCity mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(12);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.height.equalTo(@13);
    }];


    [self.meetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.AgeAndCity.mas_bottom).offset(19);
        CGSizeMake(40, 40);
        make.centerX.equalTo(self.headView.mas_centerX);
    }];

    [self.heartButton mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.top.equalTo(self.AgeAndCity.mas_bottom).offset(19);
        CGSizeMake(40, 40);
        make.right.equalTo(self.meetButton.mas_left).offset(-10);
    }];
    [self.talkButton mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.top.equalTo(self.AgeAndCity.mas_bottom).offset(19);
        CGSizeMake(40, 40);
        make.left.equalTo(self.meetButton.mas_right).offset(10);
    }];


    [self.badgeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.size.mas_equalTo(self.badgeImgV.image.size);
    }];
}

- (void)bindmodel {
    @weakify(self);

    [RACObserve(self, viewModel.avatar) subscribeNext:^(NSURL *_Nullable x) {
        @strongify(self);
        if (x) {
            [self.headView sd_setImageWithURL:x placeholderImage:[UIImage imageNamed:@"img_placeholder_a"]];
        }
    }];
    RAC(self.nickNameLabel, text) = RACObserve(self, viewModel.nickname);
    RAC(self.AgeAndCity, text)    = RACObserve(self, viewModel.userAgeAndcity);
    [RACObserve(self, viewModel.heartType) subscribeNext:^(NSNumber *_Nullable x) {
        @strongify(self);
        if (x) {
            if ([x boolValue]) {
                [self.heartButton setImage:[UIImage imageNamed:@"ic_heart_s"] forState:UIControlStateNormal];
                [self.heartButton setImage:[UIImage imageNamed:@"ic_heart_s"] forState:UIControlStateHighlighted];
            } else {
                [self.heartButton setImage:[UIImage imageNamed:@"ic_heart_n"] forState:UIControlStateNormal];
                [self.heartButton setImage:[UIImage imageNamed:@"ic_heart_n"] forState:UIControlStateHighlighted];
            }
        }
    }];

    [RACObserve(self, viewModel.isView) subscribeNext:^(id _Nullable x) {
        @strongify(self);
        //        if (self.viewModel.type == 0) {
        //            self.badgeImgV.hidden = YES;
        //        }
        //        else {
        //        }
        self.badgeImgV.hidden = [x boolValue];
    }];
}

- (void)bindWithViewModel:(id)vm {
    if (vm && [vm isKindOfClass:[QMMContactItemVM class]]) {
        self.viewModel = vm;
    }
    
}
@end

