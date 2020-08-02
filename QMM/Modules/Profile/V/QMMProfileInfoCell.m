//
//  QMMProfileInfoCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMProfileInfoCell.h"

@interface NSMutableAttributedString (AppendOval)

- (NSMutableAttributedString *)appendString:(NSString *)str;

@end

@implementation NSMutableAttributedString (AppendOval)

- (NSMutableAttributedString *)appendString:(NSString *)str {
    if (!str) return self;
    
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"ic_dot_gray"];
    NSAttributedString *oval = [NSMutableAttributedString attributedStringWithAttachment:attach];
    [self appendAttributedString:oval];
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", str]]];
    
    return self;
}

@end


@interface QMMProfileInfoCell()

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *memberLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIButton *accountBtn;
@property (nonatomic, strong) UIButton *vertifyBtn;
@property (nonatomic, strong) UIButton *infoBtn;

@end

@implementation QMMProfileInfoCell

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
    [[RACObserve(self, cellModel)
      map:^id _Nullable(QMMProfileCellModel * _Nullable value) {
          return value.value;
      }]
     subscribeNext:^(HYUserModel * _Nullable x) {
         @strongify(self);
         self.nameLabel.text = x.name;
         self.memberLabel.text = x.vipstatus ? @"高级会员" : @"";
         
         NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc]
                                                initWithString:[NSString stringWithFormat:@"%@岁", x.age]];
         self.infoLabel.attributedText = [[attrStrM
                                           appendString:[NSString stringWithFormat:@"%@cm", x.height ?: @"-"]]
                                          appendString:x.reciveSalary];
         
         [self.avatarView sd_setImageWithURL:[NSURL URLWithString:x.avatar]
                                    forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:@"ic_login_male_sel"]];
         
     }];
    
    
    [[self.avatarView rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         if (self.avatarHandler) {
             self.avatarHandler();
         }
     }];
}


- (NSAttributedString *)attributeNameWithName:(NSString *)name isVip:(BOOL)isVip {
    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc]
                                              initWithString:name
                                              attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20],
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]
                                                           }];
    if (isVip) {
        NSAttributedString *vipAttr = [[NSAttributedString alloc]
                                       initWithString:@"  高级会员"
                                       attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13],
                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                    }];
        [attrStringM appendAttributedString:vipAttr];
    }
    return attrStringM;
}

#pragma mark - Action

- (void)go2AccountView {
    if (self.accoundHandler) {
        self.accoundHandler();
    }
}

- (void)go2VeritfyView {
    if (self.identityHandler) {
        self.identityHandler();
    }
}

- (void)go2InfoView {
    if (self.userInfoHandler) {
        self.userInfoHandler();
    }
}

#pragma mark - Setup UI

- (void)setupSubviews {
    _bgImgView = [UIImageView imageViewWithImageName:@"pofile_bg" inView:self.contentView];
    
    _avatarView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_avatarView setImage:[UIImage imageNamed:@"img_placeholder_a"] forState:UIControlStateNormal];
    [self.contentView addSubview:_avatarView];
    _avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarView.layer.borderWidth = 2;
    _avatarView.layer.cornerRadius = 65 * 0.5;
    _avatarView.clipsToBounds = YES;
    
    _nameLabel = [UILabel labelWithText:@"张三"
                              textColor:[UIColor whiteColor]
                               font:[UIFont systemFontOfSize:20]
                                 inView:self.contentView
                              tapAction:NULL];
    _memberLabel = [UILabel labelWithText:@"高级会员"
                                textColor:[UIColor whiteColor]
                                 font:[UIFont systemFontOfSize:13]
                                   inView:self.contentView
                                tapAction:NULL];
    _infoLabel = [UILabel labelWithText:@""
                              textColor:[UIColor whiteColor]
                               font:[UIFont systemFontOfSize:13]
                                 inView:self.contentView
                              tapAction:NULL];
    _infoLabel.numberOfLines = 2;
    
    //
    _container = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:self.contentView];
    _container.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _container.layer.shadowOpacity = 0.2;
    _container.layer.shadowOffset = CGSizeMake(1, 1);
    _container.layer.cornerRadius = 15;
    
    _accountBtn = [self btnWithImageName:@"ic_menu_account" name:@"我的账户" action:@selector(go2AccountView)];
    _vertifyBtn = [self btnWithImageName:@"ic_menu_vertify" name:@"实名认证" action:@selector(go2VeritfyView)];
    _infoBtn = [self btnWithImageName:@"ic_menu_info" name:@"我的资料" action:@selector(go2InfoView)];
}

- (void)setupSubviewsLayout {
    CGFloat scale = SCREEN_WIDTH / 375.0 * 190.0;
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(190).multipliedBy(scale);
    }];
    
    //
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.left.offset(30);
        make.top.offset(69);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).offset(10);
        make.top.equalTo(self.avatarView).offset(10);
        make.width.mas_lessThanOrEqualTo(140);
    }];
    
    [_memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
    }];
    
    //
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).offset(10);
        make.right.offset(-10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    // ------
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.right.offset(-8);
        make.height.mas_equalTo(120);
        make.top.offset(174);
    }];
    
    
//    CGFloat m = 40;
    [_vertifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.container.mas_centerX).offset(-m);
        make.centerX.equalTo(self.container);
        make.top.bottom.offset(0);
        make.width.mas_equalTo(80);
    }];
    
    [_accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.top.bottom.width.equalTo(self.vertifyBtn);
    }];
    
    [_infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-40);
//        make.left.equalTo(self.container.mas_centerX).offset(m);
        make.top.bottom.width.equalTo(self.vertifyBtn);
    }];
    
    
}


- (UIButton *)btnWithImageName:(NSString *)imgName name:(NSString *)name action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:UIControlStateNormal];
    [btn setImagePositionStyle:ImagePositionStyleTop imageTitleMargin:20];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [self.container addSubview:btn];
    return btn;
}


@end
