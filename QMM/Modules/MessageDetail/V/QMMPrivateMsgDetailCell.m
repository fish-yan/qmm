//
//  QMMPrivateMsgDetailCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMPrivateMsgDetailCell.h"
#import "QMMPrivateMsgModel.h"

@interface QMMPrivateMsgDetailCell () {
    CGRect backgroundFrame, contentFrame;
}
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIView *backgroundImgView;

@end

@implementation QMMPrivateMsgDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpview];
        [self bindWithModel];
    }
    return self;
}

- (void)setUpview {
    self.avatarImageView = [UIImageView
    imageViewWithImageName:@"man"
                    inView:self.contentView
                 tapAction:^(UIImageView *imgView, UIGestureRecognizer *tap) {
                     NSDictionary *params = @{ @"uid": self.Model.uid ?: @"" };
                     [YSMediator pushToViewController:kModuleUserInfo withParams:params animated:YES callBack:NULL];
                 }];

    self.avatarImageView.contentMode = UIViewContentModeScaleToFill;
    [self.avatarImageView.layer setMasksToBounds:YES];
    [self.avatarImageView.layer setCornerRadius:15];
    self.backgroundImgView = [UIView viewWithBackgroundColor:[UIColor clearColor] inView:self.contentView];
    self.contentLabel      = [UILabel labelWithText:@""
                                     textColor:[UIColor tc3Color]
                                          font:[UIFont systemFontOfSize:15]
                                        inView:self.contentView
                                     tapAction:nil];
    self.contentLabel.numberOfLines = 30;
    [self.backgroundImgView.layer setMasksToBounds:YES];
    [self.backgroundImgView.layer setCornerRadius:2];
}

- (void)showOtherlayout {
    self.backgroundImgView.backgroundColor = [UIColor bg3Color];
    self.avatarImageView.frame             = CGRectMake(15, 10, 30, 30);
    CGSize size                            = [QMMPrivateMsgDetailCell getlabelHeight:self.Model.messageContent
                                                     width:(SCREEN_WIDTH - 60 - 75 - 30)
                                                      font:[UIFont systemFontOfSize:15]];

    self.contentLabel.frame      = CGRectMake(75, 25, size.width, size.height);
    self.backgroundImgView.frame = CGRectMake(60, 10, size.width + 30, size.height + 30);
}

- (void)showSelflayout {
    self.backgroundImgView.backgroundColor = [UIColor bg4Color];

    self.avatarImageView.frame = CGRectMake(SCREEN_WIDTH - 45, 10, 30, 30);
    CGSize size                = [QMMPrivateMsgDetailCell getlabelHeight:self.Model.messageContent
                                                     width:(SCREEN_WIDTH - 60 - 75 - 30)
                                                      font:[UIFont systemFontOfSize:15]];

    self.contentLabel.frame      = CGRectMake(SCREEN_WIDTH - 60 - size.width - 15, 25, size.width, size.height);
    self.backgroundImgView.frame = CGRectMake(SCREEN_WIDTH - 60 - size.width - 30, 10, size.width + 30, size.height + 30);
}


- (void)bindWithModel {
    @weakify(self);

    [RACObserve(self, Model) subscribeNext:^(QMMPrivateMsgModel *_Nullable x) {

        if (x) {
            @strongify(self);

            NSString *string = [x.sex isEqualToString:@"男"] ? @"man" : @"woman";
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:x.useravatar]
                                    placeholderImage:[UIImage imageNamed:string]];
            self.contentLabel.text = x.messageContent;
            if (x.isself) {
                [self showSelflayout];
            } else {
                [self showOtherlayout];
            }
        }

    }];
}

+ (CGFloat)getheight:(QMMPrivateMsgModel *)model {
    float h     = 20.0;
    CGSize size = [QMMPrivateMsgDetailCell getlabelHeight:model.messageContent
                                                     width:(SCREEN_WIDTH - 60 - 75 - 30)
                                                      font:[UIFont systemFontOfSize:15]];
    h = size.height + h + 30;
    return h;
}

+ (CGSize)getlabelHeight:(NSString *)string width:(float)width font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{
                                        NSFontAttributeName: font
                                    }
                                       context:nil].size;
    return size;
}

@end
