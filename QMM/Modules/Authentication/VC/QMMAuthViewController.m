//
//  QMMAuthViewController.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMAuthViewController.h"
#import "QMMAuthViewModel.h"
#import "QMMAuthInfoCell.h"
#import "QMMAuthUploadIDCell.h"
#import "ImagePickerHelper.h"


static NSString *const kInfoCellReuseID = @"kInfoCellReuseID";
static NSString *const kUploadImageCellReuseID = @"kUploadImageCellReuseID";

@interface QMMAuthViewController ()

@property (nonatomic, strong) QMMAuthViewModel *viewModel;
@property (nonatomic, strong) ImagePickerHelper *imgPicker;

@end

@implementation QMMAuthViewController


+ (void)load {
    [self mapName:kModuleIdentity withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - Action

- (void)uploadAction {
    if (!self.viewModel.frontIdPhoto || !self.viewModel.backIdPhoto) {
        return;
    }
    NSArray *photos = @[self.viewModel.frontIdPhoto,
                        self.viewModel.backIdPhoto];
    [self.imgPicker uploadPhotos:photos withResult:^(NSArray * _Nonnull imgURLs, NSError * _Nonnull error) {
        if (!error) {
            [YSProgressHUD showTips:@"上传成功, 请等待验证"];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self popBack];
        });
    }];
//    [self.imgPicker uploadIdentifyPhoto:photos withResult:^(NSArray *imgURLs, NSError *error) {
//        if (!error) {
//            [YSProgressHUD showTips:@"上传成功, 请等待验证"];
//        }
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self popBack];
//        });
//    }];
}

- (void)addImageAction:(UIButton *)btn {;
    @weakify(self);
    [self.imgPicker showImagePickerInVC:self selectedHandler:^(NSArray<UIImage *> *imgs) {
        @strongify(self);
        UIImage *img = [imgs firstObject];
        if (btn.tag == 100) {
            self.viewModel.frontIdPhoto = img;
        } else if (btn.tag == 101) {
            self.viewModel.backIdPhoto = img;
        }
        [btn setBackgroundImage:img forState:UIControlStateNormal];
    }];
}

#pragma mark - Bind

- (void)bind {
}


#pragma mark - Initialize

- (void)initialize {
    self.navigationItem.title = @"身份认证";
    self.viewModel = [QMMAuthViewModel new];
}



#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMMAuthCellModel *model = self.viewModel.dataArray[indexPath.row];
    AuthCellType cellType =  model.cellType;
    switch (cellType) {
        case AuthCellTypeInfo: {
            QMMAuthInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoCellReuseID forIndexPath:indexPath];
            cell.cellModel = model;
            return cell;
            break;
        }
        case AuthTypeUpIDImage: {
            QMMAuthUploadIDCell *cell = [tableView dequeueReusableCellWithIdentifier:kUploadImageCellReuseID forIndexPath:indexPath];
            cell.cellModel = model;
            @weakify(self);
            cell.addBtnClickHandler = ^(UIButton * _Nonnull btn) {
                @strongify(self);
                [self addImageAction:btn];
            };
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    QMMAuthCellModel *model = self.viewModel.dataArray[indexPath.row];
    AuthCellType cellType =  model.cellType;
    switch (cellType) {
        case AuthCellTypeInfo:
            [(QMMAuthInfoCell *)cell setCellModel:model];
            break;
        case AuthTypeUpIDImage:
            [(QMMAuthUploadIDCell *)cell setCellModel:model];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = nil;
    QMMAuthCellModel *model = self.viewModel.dataArray[indexPath.row];
    AuthCellType cellType =  model.cellType;
    switch (cellType) {
        case AuthCellTypeInfo:
            reuseId = kInfoCellReuseID;
            break;
        case AuthTypeUpIDImage:
            reuseId = kUploadImageCellReuseID;
            break;
        default:
            break;
    }
    @weakify(self);
    return [tableView fd_heightForCellWithIdentifier:reuseId configuration:^(id cell) {
        @strongify(self);
        [self configCell:cell atIndexPath:indexPath];
    }];
}

#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[QMMAuthInfoCell class] forCellReuseIdentifier:kInfoCellReuseID];
    [self.tableView registerNib:[UINib nibWithNibName:@"QMMAuthUploadIDCell" bundle:nil] forCellReuseIdentifier:kUploadImageCellReuseID];
    self.tableView.tableFooterView = [self footerView];
}

- (UIView *)footerView {
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    
    @weakify(self);
    UIButton *submitBtn = [UIButton buttonWithTitle:@"提交"
                                         titleColor:[UIColor whiteColor]
                                               font:[UIFont systemFontOfSize:16]
                                      normalImgName:nil
                               highlightedImageName:nil
                                            bgColor:nil
                                  normalBgImageName:@"submit_btn_bg"
                             highlightedBgImageName:nil
                                             inView:content
                                             action:^(UIButton *btn) {
                                                 @strongify(self);
                                                 [self uploadAction];
                                             }];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(content);
        make.top.offset(25);
        make.size.mas_equalTo(CGSizeMake(315, 45));
    }];
    return content;
}


#pragma mark - Lazy Loading

- (ImagePickerHelper *)imgPicker {
    if (!_imgPicker) {
        _imgPicker = [ImagePickerHelper new];
        _imgPicker.uploadType = ImageUploadTypeIdentify;
    }
    return _imgPicker;
}
@end
