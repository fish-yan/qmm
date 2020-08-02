//
//  QMMProfileVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMProfileVC.h"
#import "QMMProfileInfoCell.h"
#import "QMMProfileMenuCell.h"
#import "QMMProfileMenuListCell.h"
#import "QMMProfileVM.h"
#import "QMMProfileCellModel.h"
#import "QMMUnreadMsgFetcher.h"
#import "QMMProfileInvationCell.h"

static NSString *const kProfileInfoCellReuseID = @"kProfileInfoCellReuseID";
static NSString *const kProfileMenuCellReuseID = @"kProfileMenuCellReuseID";
static NSString *const kProfileListCellReuseID = @"kProfileListCellReuseID";
static NSString *const kProfileInvationAdCellReuseID = @"kProfileInvationAdCellReuseID";

@interface QMMProfileVC ()

@property (nonatomic, strong) QMMProfileVM *viewModel;

@end

@implementation QMMProfileVC

+ (void)load {
    [self mapName:@"kModuleProfile" withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canBack = NO;
    
    [YSProgressHUD showInView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestData];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setupNavAppearance];
    
    
    // 请求最新的未读数据
    [[QMMUnreadMsgFetcher shareInstance].unreadMsgCmd execute:nil];
}

- (void)setupNavAppearance {
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

//    [self.navigationController setNavigationBarHidden:NO animated:NO];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                                                  forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Action

- (void)requestData {
    [self.viewModel.requestCmd execute:nil];
}

- (void)go2SettingView {
    QMMSettingVC *vc = [QMMSettingVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
//    [[self.viewModel.logoutCmd errors] subscribeNext:^(NSError * _Nullable x) {
//        [YSProgressHUD showTips:x.localizedDescription];
//    }];
}


#pragma mark - Initialize

- (void)initialize {
    self.viewModel = [QMMProfileVM new];
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
    QMMProfileCellModel *model = sections[indexPath.row];
    switch (model.type) {
        case ProfileCellTypeInfo: {
            QMMProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileInfoCellReuseID];
            cell.cellModel = model;
            cell.avatarHandler = ^{
                
            };
            cell.accoundHandler = ^{
                UIViewController *vc = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"FYWalletViewController"];
                [self.navigationController pushViewController:vc animated:YES];

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
            QMMProfileMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileMenuCellReuseID];
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
        case ProfileCellTypeInvationAd: {
            QMMProfileInvationCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileInvationAdCellReuseID];
            return cell;
            break;
        }
        case ProfileCellTypeList:
        case ProfileCellTypeListInfo: {
            QMMProfileMenuListCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileListCellReuseID];
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
    QMMProfileCellModel *model = sections[indexPath.row];
    switch (model.type) {
        case ProfileCellTypeInfo: {
            return 310.0;
            break;
        }
        case ProfileCellTypeMenu: {
            return 240;
            break;
        }
        case ProfileCellTypeInvationAd: {
            return 120;
            break;
        }
        case ProfileCellTypeList:
        case ProfileCellTypeListInfo: {
            return 50;
            break;
        }
        default:
            break;
    }
    return 0.001;
}

- (void)go2InvitationView {
    InvitationVC *vc = [InvitationVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sections = self.viewModel.dataArray[indexPath.section];
    QMMProfileCellModel *model = sections[indexPath.row];
    if (model.type == ProfileCellTypeInvationAd) {
        [self go2InvitationView];
    }
    else if (model.type == ProfileCellTypeList) {
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
            [YSMediator pushToViewController:kModuleMatchMakerPay
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
//        else if ([model.title isEqualToString:@"发现星球"]) {
//            [YSProgressHUD showTips:@"该功能暂未开通，敬请期待"];
//            return;
//        }
        else if ([model.title isEqualToString:@"邀请好友"]) {
            [self go2InvitationView];
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
        // 解决iOS11 刷新上下跳的问题
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[QMMProfileInfoCell class] forCellReuseIdentifier:kProfileInfoCellReuseID];
    [self.tableView registerClass:[QMMProfileMenuCell class] forCellReuseIdentifier:kProfileMenuCellReuseID];
    [self.tableView registerClass:[QMMProfileMenuListCell class] forCellReuseIdentifier:kProfileListCellReuseID];
    [self.tableView registerClass:[QMMProfileInvationCell class] forCellReuseIdentifier:kProfileInvationAdCellReuseID];
    
    self.tableView.tableFooterView = [self footerView];
    self.tableView.mj_header = [YSRefresher headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self setupRightBarItem];
}

- (UIView *)footerView {
    UIView *f = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    @weakify(self);
    UIButton *logoutBtn = [UIButton buttonWithTitle:@"退出登录"
                                         titleColor:[UIColor whiteColor]
                                               font:[UIFont systemFontOfSize:15]
                                      normalImgName:nil
                                            bgColor:nil
                                             inView:f
                                             action:^(UIButton *btn) {
                                                 @strongify(self);
                                                 [self dologoutAction];
                                             }];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:(UIControlStateNormal)];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(38);
        make.right.offset(-38);
        make.height.offset(40);
    }];
    return f;
}

- (void)setupRightBarItem {
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_profile_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(go2SettingView)];
}

- (void)setupSubviewsLayout {
    [super setupSubviewsLayout];
    
    
//    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableView.contentInset = adjustForTabbarInsets;
    self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
}
@end
