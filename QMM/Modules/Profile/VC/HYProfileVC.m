//
//  HYProfileVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYProfileVC.h"
#import "HYProfileInfoCell.h"
#import "HYProfileMenuCell.h"
#import "HYProfileMenuListCell.h"
#import "HYProfileViewModel.h"
#import "HYProfileCellModel.h"
#import "HYUnreadInfoFetcher.h"

static NSString *const kProfileInfoCellReuseID = @"kProfileInfoCellReuseID";
static NSString *const kProfileMenuCellReuseID = @"kProfileMenuCellReuseID";
static NSString *const kProfileListCellReuseID = @"kProfileListCellReuseID";

@interface HYProfileVC ()

@property (nonatomic, strong) HYProfileViewModel *viewModel;

@end

@implementation HYProfileVC

+ (void)load {
    [self mapName:@"kModuleProfile" withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YSProgressHUD showInView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 请求最新的未读数据
    [[HYUnreadInfoFetcher shareInstance].unreadMsgCmd execute:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}


#pragma mark - Action

- (void)requestData {
    [self.viewModel.requestCmd execute:nil];
}

- (void)go2SettingView {
    
}

- (void)dologoutAction {
    [self.viewModel.logoutCmd execute:nil];
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    
    [[[self.viewModel.requestCmd executionSignals] switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        [self.tableView.mj_header endRefreshing];
        [self.view hiddenFailureView];
        [self.tableView reloadData];
    }];
    
    
    [[self.viewModel.requestCmd errors] subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [YSProgressHUD showTips:x.localizedDescription];
        [self.tableView.mj_header endRefreshing];
        
        [self.view showFailureViewOfType:WDFailureViewTypeError withClickAction:^{
            @strongify(self);
            [self requestData];
        }];
    }];
    
    
    // ---
    [[self.viewModel.logoutCmd errors] subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
}


#pragma mark - Initialize

- (void)initialize {
    self.viewModel = [HYProfileViewModel new];
    self.navigationItem.title = @"";
}



#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *models = self.viewModel.dataArray[section];
    return models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sections = self.viewModel.dataArray[indexPath.section];
    HYProfileCellModel *model = sections[indexPath.row];
    switch (model.type) {
        case ProfileCellTypeInfo: {
            HYProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileInfoCellReuseID];
            cell.cellModel = model;
            cell.avatarHandler = ^{
                //TODO: 上传头像
            };
            cell.friendRequireHandler = ^{
                NSDictionary *params = @{
                                         @"infoModel": self.viewModel.detailModel ?: [NSNull null],
                                         @"type": @1
                                         };
                [YSMediator pushToViewController:@"kModuleBasicInfo"
                                      withParams:params
                                        animated:YES
                                        callBack:nil];
                
                //                [YSMediator pushToViewController:kModuleMyAccount
                //                                      withParams:nil
                //                                        animated:YES
                //                                        callBack:NULL];
            };
            cell.identityHandler = ^{
                if (self.viewModel.hasIdentify) {
                    [YSProgressHUD showTips:@"您已实名认证"];
                    return;
                }
                [YSMediator pushToViewController:kModuleIdentity
                                      withParams:@{@"source": @1}
                                        animated:YES
                                        callBack:NULL];
            };
            cell.userInfoHandler = ^{
                NSDictionary *params = @{
                                         @"type": @1,
                                         @"uid": self.viewModel.uid
                                         };
                [YSMediator pushToViewController:kModuleUserInfo
                                      withParams:params
                                        animated:YES
                                        callBack:NULL];
            };
            
            return cell;
            break;
        }
        case ProfileCellTypeMenu: {
            HYProfileMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileMenuCellReuseID];
            cell.cellModel = model;
            cell.menuItemClick = ^(NSInteger idx, NSString *mapStr) {
                self.navigationController.hidesBottomBarWhenPushed = YES;
                [YSMediator pushToViewController:kModuleMembership
                                      withParams:@{@"showIdx": @(idx)}
                                        animated:YES
                                        callBack:NULL];
            };
            return cell;
            break;
        }
        case ProfileCellTypeList: {
            HYProfileMenuListCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileListCellReuseID];
            cell.cellModel = model;
            return cell;
            break;
        }
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sections = self.viewModel.dataArray[indexPath.section];
    HYProfileCellModel *model = sections[indexPath.row];
    switch (model.type) {
        case ProfileCellTypeInfo: {
            return 310.0;
            break;
        }
        case ProfileCellTypeMenu: {
            return 240;
            break;
        }
        case ProfileCellTypeList: {
            return 50;
            break;
        }
        default:
            break;
    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sections = self.viewModel.dataArray[indexPath.section];
    HYProfileCellModel *model = sections[indexPath.row];
    if (model.type == ProfileCellTypeList) {
        if ([model.title isEqualToString:@"排名提前"]) {
            [YSMediator presentToViewController:model.mapStr
                                     withParams:model.value
                                       animated:YES
                                       callBack:NULL];
            //          BOOL isVIP = [[HYUserContext shareContext].userModel.vipstatus boolValue];
            //            if (!isVIP) {
            //            }
            
            return;
        }
        else if ([model.title isEqualToString:@"红娘推荐"]) {
            [YSMediator pushToViewController:@"kModuleMatchMakerPay"
                                  withParams:nil
                                    animated:YES
                                    callBack:NULL];
            //            id rst = ^(BOOL isSuccess){
            //                if (isSuccess) {
            //                    [self requestData];
            //                }
            //            };
            //            [YSMediator presentToViewController:@"kModuleTopDisplayPay"
            //                                     withParams:@{
            //                                                  @"type":@1,
            //                                                  @"payResult": rst
            //                                                  }
            //                                       animated:YES
            //                                       callBack:NULL];
            //            if (!self.viewModel.hasBuyMatchMaker) {
            //            }
            //            else {
            //                [YSMediator pushToViewController:model.mapStr
            //                                      withParams:model.value
            //                                        animated:YES
            //                                        callBack:NULL];
            //            }
            
            return;
        }
        else if ([model.title isEqualToString:@"发现星球"]) {
            [YSProgressHUD showTips:@"该功能暂未开通，敬请期待"];
            return;
        }
        else if ([model.title isEqualToString:@"邀请好友"]) {
            [YSProgressHUD showTips:@"抱歉，暂不支持邀请好友"];
            return;
        }
        
        [YSMediator pushToViewController:model.mapStr
                              withParams:model.value
                                animated:YES
                                callBack:NULL];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView viewWithBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"] inView:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.viewModel.dataArray.count - 1) {
        return 10.0;
    }
    return 0.0001;
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HYProfileInfoCell class] forCellReuseIdentifier:kProfileInfoCellReuseID];
    [self.tableView registerClass:[HYProfileMenuCell class] forCellReuseIdentifier:kProfileMenuCellReuseID];
    [self.tableView registerClass:[HYProfileMenuListCell class] forCellReuseIdentifier:kProfileListCellReuseID];
    self.tableView.tableFooterView = [self footerView];
    self.tableView.mj_header = [YSRefresher headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    //[self setupRightBarItem];
}

- (UIView *)footerView {
    UIView *f = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    @weakify(self);
    UIButton *logoutBtn = [UIButton buttonWithTitle:@""
                                         titleColor:[UIColor redColor]
                                               font:[UIFont systemFontOfSize:15]
                                      normalImgName:nil
                                            bgColor:nil
                                             inView:f
                                             action:^(UIButton *btn) {
                                                 @strongify(self);
                                                 [self dologoutAction];
                                             }];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(f);
    }];
    return f;
}

- (void)setupRightBarItem {
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(go2SettingView)];
}

- (void)setupSubviewsLayout {
    [super setupSubviewsLayout];
    
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableView.contentInset = adjustForTabbarInsets;
    self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
}
@end
