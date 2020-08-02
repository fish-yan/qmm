//
//  QMMSupplementaryAvatarVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMSupplementaryAvatarVC.h"
#import "ImagePickerHelper.h"

@interface QMMSupplementaryAvatarVC () {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *avatarBtn;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UIButton *skipBtn;

@property (nonatomic, strong) ImagePickerHelper *imgPicker;

@end

@implementation QMMSupplementaryAvatarVC


+ (void)load {
    [self mapName:kModuleCompleteInfoAvatar withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self setupSubviewsLayout];
    [self bind];
}


#pragma mark - Action

- (void)doGo2HomeAction {
    HYUserCenterModel *model = [QMMUserContext shareContext].userModel;
    model.iscomplete = UserInfoTypeComplete;
    [[QMMUserContext shareContext] updateUserInfo:model];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self go2HomeView];
    });
}

- (void)doAddImageAction {
    self.imgPicker.uploadType = ImageUploadTypeAvatar;
    self.imgPicker.tips = @"上传头像";
    [self.imgPicker showImagePickerInVC:self
                          uploadHandler:^(NSArray<UIImage *> *imgs, NSArray<NSString *> *imgUrls, NSError *error) {
                              if (error) {
                                  [YSProgressHUD showTips:error.localizedDescription];
                              }
                              
                              [self doGo2HomeAction];
                          }];
}

- (void)go2HomeView {
    [[QMMUIAssistant shareInstance].setTabBarVCAsRootVCCommand execute:nil];
}


#pragma mark - Bind

- (void)bind {
}


#pragma mark - Initialize

- (void)initialize {
    self.titleLabel.text = @"完善资料";
    self.stepLabel.text = @" ";
    self.infoLabel.text = @"上传真实的照片，展现最美的自己";
    self.descLabel.text = @"得到更多曝光机会，邂逅更多心仪对象";
    
    self.imgPicker = [ImagePickerHelper new];
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:scrollView];
        scrollView;
    });
    
    self.contentView = [UIView viewWithBackgroundColor:nil inView:_scrollView];
    
    //
    self.titleLabel = [UILabel labelWithText:nil
                                   textColor:[UIColor whiteColor]
                               textAlignment:NSTextAlignmentCenter
                                    font:[UIFont pingFongFontOfSize:30]
                                      inView:self.contentView
                                   tapAction:NULL];
    self.stepLabel = [UILabel labelWithText:nil
                                  textColor:[UIColor whiteColor]
                              textAlignment:NSTextAlignmentCenter
                                   font:[UIFont pingFongFontOfSize:14]
                                     inView:self.contentView
                                  tapAction:NULL];
    self.infoLabel = [UILabel labelWithText:nil
                                  textColor:[UIColor whiteColor]
                              textAlignment:NSTextAlignmentCenter
                                   font:[UIFont pingFongFontOfSize:20]
                                     inView:self.contentView
                                  tapAction:NULL];
    self.descLabel = [UILabel labelWithText:nil
                                  textColor:[UIColor whiteColor]
                              textAlignment:NSTextAlignmentCenter
                                   font:[UIFont pingFongFontOfSize:16]
                                     inView:self.contentView
                                  tapAction:NULL];
    
    // 判断是男是女,选择不同的占位图
    NSString *bgImg = self.viewModel.isMale ?  @"ic_upload_man" : @"ic_upload_woman";
    _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _avatarBtn.layer.cornerRadius = 75.0;
    _avatarBtn.clipsToBounds = YES;
    [_avatarBtn setBackgroundImage:[UIImage imageNamed:bgImg] forState:UIControlStateNormal];
    [_avatarBtn addTarget:self action:@selector(doAddImageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_avatarBtn];
    
    UIImageView *tagView = [UIImageView imageViewWithImageName:@"ic_upload_add" inView:self.view];
    [self.contentView addSubview:tagView];
    
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.right.equalTo(self.avatarBtn).offset(-10);
        make.bottom.equalTo(self.avatarBtn).offset(0);
    }];
    
    
    //
    _openBtn = [self ceateBtnWithTitle:@"开启我的约会" handle:^(UIButton *btn) {
        if (self.avatarBtn.selected) {
            [self go2HomeView];
        }
    }];
    
    _skipBtn = [self ceateBtnWithTitle:@"跳过" handle:^(UIButton *btn) {
        [self go2HomeView];
    }];
}

- (UIButton *)ceateBtnWithTitle:(NSString *)title handle:(void(^)(UIButton *btn))handler {
    UIButton *btn = [UIButton buttonWithTitle:title
                                   titleColor:[UIColor colorWithHexString:@"#FF5D9C"]
                                     font:[UIFont pingFongFontOfSize:16]
                                      bgColor:[UIColor whiteColor]
                                       inView:self.view
                                       action:handler];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 45 * 0.5;
    [self.view addSubview:btn];
    return btn;
}

- (void)setupSubviewsLayout {
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.equalTo(self.view);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.offset(80);
    }];
    
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.stepLabel.mas_bottom).offset(25);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(10);
    }];
    [_avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(150);
        make.top.equalTo(self.descLabel.mas_bottom).offset(50);
        make.centerX.equalTo(self.contentView);
    }];
    
    CGFloat padding = 30;
    [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarBtn.mas_bottom).offset(50);
        make.left.offset(padding);
        make.right.offset(-padding);
        make.height.mas_equalTo(45);
    }];
    
    [_skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openBtn.mas_bottom).offset(25);
        make.left.offset(padding);
        make.right.offset(-padding);
        make.height.mas_equalTo(45);
    }];
    
    
    //
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);    // 一定要写
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.skipBtn).offset(20);
    }];
}

@end
