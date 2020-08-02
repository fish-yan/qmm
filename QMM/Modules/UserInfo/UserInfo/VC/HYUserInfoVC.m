//
//  HYUserInfoVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUserInfoVC.h"
#import "HYUserInfoCellModel.h"
#import "HYUserInfoHeaderCell.h"
#import "HYUserInfoPhotosCell.h"
#import "HYUserInfoCell.h"
#import "HYUserInfoListCell.h"
#import "HYUserInfoDescCell.h"
#import "HYUserInfoTagCell.h"
#import "YSPickerView.h"
#import "YSPickerViewData.h"
#import "HYPersonActionView.h"
#import "HYPersonActionVM.h"
#import "IDMPhotoBrowser.h"
#import "ImagePickerHelper.h"


static NSString *const kUserInfoHeaderCellReuseID = @"kUserInfoHeaderCellReuseID";
static NSString *const kUserInfoCellReuseID = @"kUserInfoCellReuseID";
static NSString *const kUserInfoPhotosCellReuseID = @"kUserInfoPhotosCellReuseID";
static NSString *const kUserInfoListCellReuseID = @"kUserInfoListCellReuseID";
static NSString *const kUserInfoDescCellReuseID = @"kUserInfoDescCellReuseID";
static NSString *const kUserInfoTagCellReuseID = @"kUserInfoTagCellReuseID";

@interface HYUserInfoVC ()

@property (nonatomic, strong) HYUserInfoVM *viewModel;

@property (nonatomic, strong) HYPersonActionView *actionView;
@property (nonatomic, strong) HYPersonActionVM *actionVM;

@property (nonatomic, strong) ImagePickerHelper *imgPicker;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *reportBtn;

@end

@implementation HYUserInfoVC

+ (void)load {
    [self mapName:kModuleUserInfo withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestData];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - Action

- (void)requestData {
    [self.viewModel.requestCmd execute:nil];
}

- (void)openImagesByPhotoBrowser:(NSArray<NSString *> *)images atIdx:(NSInteger)idx {
    // Create an array to store IDMPhoto objects
    NSMutableArray *photos = [NSMutableArray new];
    for (NSString *s in images) {
        IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:s]];
        [photos addObject:photo];
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    [browser setInitialPageIndex:idx];
    [self presentViewController:browser animated:YES completion:nil];
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [[[self.viewModel.requestCmd executionSignals] switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        [self.tableView reloadData];
    }];
    
    [[[self.viewModel.requestCmd.executing skip:1]
      merge:[self.viewModel.updateCmd.executing skip:1]]
     subscribeNext:^(NSNumber * _Nullable x) {
         @strongify(self);
         if ([x boolValue]) {
             [YSProgressHUD showInView:self.view];
         }
     }];
    
    [[self.viewModel.requestCmd errors] subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
        
        @strongify(self)
        [self.view showFailureViewOfType:WDFailureViewTypeError
                         withClickAction:^{
                             @strongify(self);
                             [self requestData];
                         }];
    }];
    
    
    //
    [[[self.viewModel.updateCmd executionSignals] switchToLatest] subscribeNext:^(id  _Nullable x) {
        [YSProgressHUD showTips:x];
    }];
    [[self.viewModel.updateCmd errors] subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
    
    //
    //
    [[self.actionVM.heartCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            [YSProgressHUD showIndeterminate];
        }
    }];
    [[self.actionVM.heartCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        [YSProgressHUD showTips:x];
        @strongify(self);
        self.viewModel.beckoningstatus = !self.viewModel.beckoningstatus;
    }];
    
    [self.actionVM.heartCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
    
    // 心动按钮
    RAC(self.actionView.heartBtn, selected) = RACObserve(self.viewModel, beckoningstatus);
}


#pragma mark - Initialize

- (void)initialize {
    self.viewModel = [HYUserInfoVM new];
    self.viewModel.uid = self.uid;
    self.viewModel.type = self.type;
    
    self.imgPicker = [ImagePickerHelper new];
    
    if (self.type == UserTypeOther) {
        self.actionVM = [HYPersonActionVM new];
    }
}



#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.viewModel.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sections = self.viewModel.dataArray[indexPath.section];
    HYUserInfoCellModel *cellModel = sections[indexPath.row];
    @weakify(self);
    
    switch (cellModel.cellType) {
        case UserInfoCellTypeHeader: {
            HYUserInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoHeaderCellReuseID];
            cell.cellModel = cellModel;
            return cell;
            break;
        }
        case UserInfoCellTypeInfo: {
            HYUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellReuseID];
            cell.cellModel = cellModel;
            return cell;
            break;
        }
        case UserInfoCellTypePhotos: {
            HYUserInfoPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoPhotosCellReuseID];
            cell.isMySelf = self.type == UserTypeSelf;
            cell.cellModel = cellModel;
            cell.addBtnClickHandler = ^{
                @strongify(self);
                self.imgPicker.uploadType = ImageUploadTypeShowPic;
                self.imgPicker.tips = @"上传展示照片";
                [self.imgPicker showImagePickerInVC:self
                                      uploadHandler:^(NSArray<UIImage *> *imgs, NSArray<NSString *> *imgUrls, NSError *error) {
                                          if (!error) {
                                              [self requestData];
                                          }
                                      }];
            };
            cell.imageBtnClickHandler = ^(NSArray *images, NSInteger idx) {
                [self openImagesByPhotoBrowser:images atIdx:idx];
            };
            return cell;
            break;
        }
        case UserInfoCellTypeList: {
            HYUserInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoListCellReuseID];
            cell.cellModel = cellModel;
            return cell;
            break;
        }
        case UserInfoCellTypeDesc: {
            HYUserInfoDescCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoDescCellReuseID];
            cell.cellModel = cellModel;
            return cell;
        }
        case UserInfoCellTypeTags: {
            HYUserInfoTagCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoTagCellReuseID];
            cell.cellModel = cellModel;
            return cell;
        }
        default:
            break;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sections = self.viewModel.dataArray[indexPath.section];
    HYUserInfoCellModel *cellModel = sections[indexPath.row];
    if (cellModel.cellType == UserInfoCellTypeDesc) {
        return [tableView fd_heightForCellWithIdentifier:kUserInfoDescCellReuseID configuration:^(HYUserInfoDescCell *cell) {
            cell.cellModel = cellModel;
        }];
    }
    else if (cellModel.cellType == UserInfoCellTypeTags) {
        return [tableView fd_heightForCellWithIdentifier:kUserInfoTagCellReuseID configuration:^(HYUserInfoTagCell *cell) {
            cell.cellModel = cellModel;
        }];
    }
    
    return cellModel.cellHeight;
}

- (YSPickerViewModel *)modelIn:(NSArray *)arr atIndex:(NSInteger)idx {
    if (arr.count == 0 || (arr.count && arr.count <= idx)) return nil;
    return arr[idx];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sections = self.viewModel.dataArray[indexPath.section];
    HYUserInfoCellModel *cellModel = sections[indexPath.row];
    
    // 点击头像
    if (self.type == UserTypeSelf && cellModel.cellType == UserInfoCellTypeHeader) {
        self.imgPicker.uploadType = ImageUploadTypeAvatar;
        self.imgPicker.tips = @"上传头像";
        [self.imgPicker showImagePickerInVC:self
                              uploadHandler:^(NSArray<UIImage *> *imgs, NSArray<NSString *> *imgUrls, NSError *error) {
                                  if (!error) {
                                      [self requestData];
                                  }
                              }];
        return;
    }
    
    
    if ([cellModel.title isEqualToString:@"最后登陆时间"]
        || [cellModel.title isEqualToString:@"上线提醒"]
        || [cellModel.title isEqualToString:@"设置备注"]) {
        [YSProgressHUD showTips:@"该功能暂未开通，敬请期待"];
        return;
    }
    if (cellModel.cellType != UserInfoCellTypeList || self.type != UserTypeSelf) return;
    
    
    
    if ([cellModel.title isEqualToString:@"所在地区"]) {
        YSPickerView *picker = [YSPickerView pickerViewWithType:YSPickerViewTypeTriple];
        [picker showPickerViewWithDataArray:[YSPickerViewData shareData].places sureHandle:^(NSArray *arr) {
            YSPickerViewModel *m0 = arr[0];
            YSPickerViewModel *m1 = arr[1];
            YSPickerViewModel *m2 = arr[2];
            NSString *str = [NSString stringWithFormat:@"%@ %@ %@", m0.name, m1.name, m2.name];
            cellModel.desc = str;
            // 修改地址接口
            [self.viewModel.updateCmd execute:@{@"workarea": m2.mid}];
            
        }];
        return;
    }
    
    if ([cellModel.title isEqualToString:@"基本资料"]) {
        [YSMediator pushToViewController:@"kModuleBasicInfo"
                              withParams:@{@"infoModel": self.viewModel.infoModel ?: [NSNull null]}
                                animated:YES
                                callBack:nil];
    }
    else if ([cellModel.title isEqualToString:@"交友条件"]) {
        [YSMediator pushToViewController:@"kModuleBasicInfo"
                              withParams:@{
                                           @"infoModel": self.viewModel.infoModel ?: [NSNull null],
                                           @"type": @1
                                           }
                                animated:YES
                                callBack:nil];
    }
    else if ([cellModel.title isEqualToString:@"自我介绍"]) {
        [YSMediator pushToViewController:kModuleInfoEdit
                              withParams:@{
                                           @"type": @2,
                                           @"info": [self.viewModel.infoModel intro] ?: @""
                                           }
                                animated:YES
                                callBack:NULL];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView viewWithBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"] inView:nil];
}


#pragma mark - Setup Subviews

- (void)registerCell {
    [self.tableView registerClass:[HYUserInfoHeaderCell class] forCellReuseIdentifier:kUserInfoHeaderCellReuseID];
    [self.tableView registerClass:[HYUserInfoCell class] forCellReuseIdentifier:kUserInfoCellReuseID];
    [self.tableView registerClass:[HYUserInfoPhotosCell class] forCellReuseIdentifier:kUserInfoPhotosCellReuseID];
    [self.tableView registerClass:[HYUserInfoListCell class] forCellReuseIdentifier:kUserInfoListCellReuseID];
    [self.tableView registerClass:[HYUserInfoDescCell class] forCellReuseIdentifier:kUserInfoDescCellReuseID];
    [self.tableView registerClass:[HYUserInfoTagCell class] forCellReuseIdentifier:kUserInfoTagCellReuseID];
    
}

- (void)fekeRequest {
    [YSProgressHUD showIndeterminate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YSProgressHUD showTips:@"谢谢您的举报，我们会及时核查"];
    });
}

- (void)setupSubviews {
    [super setupSubviews];
    
    @weakify(self);
    CGFloat wh = 25;
    self.backBtn = ({
        UIButton *btn = [UIButton buttonWithNormalImgName:@"top_back"
                                                  bgColor:[UIColor colorWithWhite:1 alpha:0.5]
                                                   inView:self.view
                                                   action:^(UIButton *btn) {
                                                       [self popBack];
                                                   }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(wh, wh));
            make.left.offset(15);
            make.top.offset(35);
        }];
        
        btn.layer.cornerRadius = wh * 0.5;
        
        btn;
    });
    
    self.reportBtn = ({
        UIButton *btn = [UIButton buttonWithTitle:@"举报"
                                       titleColor:[UIColor blackColor]
                                             font:[UIFont systemFontOfSize:14]
                                    normalImgName:nil
                                          bgColor:[UIColor colorWithWhite:1 alpha:0.5]
                                           inView:self.view
                                           action:^(UIButton *btn) {
                                               @strongify(self);
                                               [self fekeRequest];
                                           }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.top.offset(35);
            make.size.mas_equalTo(CGSizeMake(40, wh));
        }];
        
        btn.layer.cornerRadius = 3;
        
        btn;
    });
    
    if (self.type == UserTypeOther) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.bottom.offset(-50);
        }];
        [self setupBottom];
    }
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerCell];
}


- (void)setupBottom {
    @weakify(self);
    self.actionView = [HYPersonActionView viewWithHeartClickAction:^(UIButton *btn) {
        @strongify(self);
        NSNumber *type = @1;
        // 接口操作字段: 1:心动，2:取消心动
        // private int type;
        if (self.viewModel.beckoningstatus) {
            type = @2;
        }
        [self.actionVM.heartCmd execute:@{@"uid": self.viewModel.uid ?: @"",
                                          @"type": type
                                          }];
        
        NSLog(@"-----heart");
    }
                                                   dateClickAction:^(UIButton *btn) {
                                                       @strongify(self);
                                                       NSLog(@"----约会");
                                                       NSDictionary *params = @{
                                                                                @"dateID": self.viewModel.dateId ?: @"",
                                                                                @"appointmentstatus": self.viewModel.appointmentstatus ? @1 : @0,
                                                                                @"uid": self.viewModel.uid ?: @"",
                                                                                @"avatar": self.viewModel.avatar ?: @"",
                                                                                @"name": self.viewModel.name ?: @""
                                                                                };
                                                       
                                                       [YSMediator pushToViewController:kModuleDatingInfo
                                                                             withParams:params
                                                                               animated:YES
                                                                               callBack:NULL];
                                                   }
                                                messageClickAction:^(UIButton *btn) {
                                                    @strongify(self);
                                                    if(![[QMMUserContext shareContext].userModel.vipstatus boolValue]) {
                                                        [self showPayAlert];
                                                        return;
                                                    }
                                                    NSDictionary *params = @{@"cantactName": self.viewModel.name,
                                                                             @"cantactID": self.viewModel.uid,
                                                                             @"avatar": self.viewModel.avatar };
                                                    [YSMediator  pushToViewController:@"PrivateMessageDetialViewController"
                                                                           withParams:params
                                                                             animated:YES
                                                                             callBack:nil];
                                                }];
    [self.view addSubview:self.actionView];
    
    [_actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(48);
    }];
    
}

- (void)showPayAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"升级会员即可无限畅聊"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"免费试用"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [YSMediator pushToViewController:@"HYMembershipVC"
                                                                      withParams:@{}
                                                                        animated:YES
                                                                        callBack:nil];
                                            }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
@end
