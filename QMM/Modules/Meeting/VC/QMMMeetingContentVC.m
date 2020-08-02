//
//  QMMMeetingContentVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMMeetingContentVC.h"
#import "QMMMeetingCommendCell.h"
#import "QMMInfoListCell.h"
#import "QMMBottomActionVM.h"
#import "QMMUnreadMsgFetcher.h"

static NSString *const kCommendCellReuseID = @"kCommendCellReuseID";
static NSString *const kInfoListCellReuseID = @"kInfoListCellReuseID";


@interface QMMMeetingContentVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) QMMMeetingVM *viewModel;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) QMMBottomActionVM *actionVM;

@property (nonatomic, strong) QMMMemberInfoModel *actionModel;

@end

@implementation QMMMeetingContentVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self bind];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.type == ContentTypeNearby) {
            [self checkLocationAuthority];
        }
        [YSProgressHUD showInView:self.view];
        [self requestData];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 每次显示页面更新推荐数据
    if (!self.isFirstLoad && self.type == ContentTypeRecommend) {
        [self.viewModel.commendRequestCmd execute:nil];
    }
    self.isFirstLoad = NO;
    
    
    // 请求最新的未读数据
    [[QMMUnreadMsgFetcher shareInstance].unreadMsgCmd execute:nil];
}

#pragma mark - Action

- (void)updataWithFilterInfos:(QMMFilterRecordModel *)filterInfos {
    // 附近不能筛选, 其他的可以筛选
    if (self.type == ContentTypeNearby) {
        return;
    }
    
    self.viewModel.filterInfos = filterInfos;
    [self requestData];
}


- (void)requestData {
    [self.viewModel.requestDataCmd execute:@1];
}

- (void)requestMoreData {
    [self.viewModel.listRequestCmd execute:self.viewModel.flag];
}

- (BOOL)checkLocationAuthority {
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"定位服务未开启"
                                            message:@"定位功能未开启,现在去设置授权,否则将无法使用对应功能"
                                     preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"现在去打开"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                              [[UIApplication sharedApplication] openURL:appSettings];
                                                          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }]];
        [self presentViewController:alertController animated:YES completion:NULL];
        return NO;
    }
    return YES;
}

//- (bo)checkEmptyView {
//    @weakify(self);
//    if (self.viewModel.dataArray.count == 0) {
//        [self.view showFailureViewOfType:WDFailureViewTypeEmpty
//                         withClickAction:^{
//                             @strongify(self);
//                             [self requestData];
//                         }];
//    }
//    else {
//        [self.view hiddenFailureView];
//        [self.tableView reloadData];
//    }
//}

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
                                                [YSMediator pushToViewController:kModuleMembership
                                                                      withParams:@{}
                                                                        animated:YES
                                                                        callBack:nil];
                                            }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)go2DatingWithModel:(QMMMemberInfoModel *)m {
    NSDictionary *params = @{
                             @"dateID": m.appointmentid ?: @"",
                             @"appointmentstatus": m.appointmentstatus ? @1 : @0,
                             @"uid": m.uid ?: @"",
                             @"avatar": m.avatar ?: @"",
                             @"name": m.name ?: @""
                             };
    
    [YSMediator pushToViewController:kModuleDatingInfo
                          withParams:params
                            animated:YES
                            callBack:NULL];
}

- (void)doHeartActionWithModel:(QMMMemberInfoModel *)m {
    NSNumber *type = @1;
    // 接口操作字段: 1:心动，2:取消心动
    // private int type;
    if (m.beckoningstatus) {
        type = @2;
    }
    self.actionModel = m;
    [self.actionVM.heartCmd execute:@{@"uid": m.uid ?: @"",
                                      @"type": type
                                      }];
}

- (void)popPayTopView {
    @weakify(self);
    id rst = ^(BOOL isSuccess){
        @strongify(self);
        if (isSuccess) {
            [YSProgressHUD showTips:@"置顶成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.55 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestData];
            });
        }
    };
    [YSMediator presentToViewController:kModuleTopDisplayPay
                             withParams:@{
                                          @"type": @0,
                                          @"payResult": rst
                                          }
                               animated:YES
                               callBack:NULL];
}

#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [[self.viewModel.requestDataCmd.executionSignals switchToLatest]
     subscribeNext:^(NSArray *  _Nullable x) {
         @strongify(self);
         [self.tableView.mj_header endRefreshing];
         [YSProgressHUD hiddenHUD];
         [self.view hiddenFailureView];
         
         if (self.viewModel.dataArray.count == 0) {
             [self.view showFailureViewOfType:WDFailureViewTypeEmpty
                              withClickAction:^{
                                  @strongify(self);
                                  [self requestData];
                              }];
         }
         else {
             [self.view hiddenFailureView];
             [self.tableView reloadData];
         }
     }];
    
    [self.viewModel.requestDataCmd.errors
     subscribeNext:^(NSError * _Nullable x) {
         @strongify(self);
         [self.tableView.mj_header endRefreshing];
         [YSProgressHUD hiddenHUD];
         
         [YSProgressHUD showTips:x.localizedDescription];
         [self.view showFailureViewOfType:WDFailureViewTypeError
                          withClickAction:^{
                              @strongify(self);
                              [self requestData];
                          }];
     }];
    
    //
    [[self.viewModel.listRequestCmd.executionSignals switchToLatest] subscribeNext:^(NSArray *  _Nullable x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
        [self.view hiddenFailureView];
        [self.tableView reloadData];
    }];
    
    [self.viewModel.listRequestCmd.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
        [YSProgressHUD showTips:x.localizedDescription];
    }];
    
    
    //
    [[self.viewModel.commendRequestCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    
    
    
    //
    [[self.actionVM.heartCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            [YSProgressHUD showIndeterminate];
        }
    }];
    [[self.actionVM.heartCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [YSProgressHUD showTips:@"心动成功"];
        self.actionModel.beckoningstatus = !self.actionModel.beckoningstatus;
        
    }];
    
    [self.actionVM.heartCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
    
    
    //
    RAC(self.tableView.mj_footer, hidden) = [RACObserve(self.viewModel, hasMore) not];
}


#pragma mark - Initialize

- (void)initialize {
    self.viewModel = [QMMMeetingVM new];
    self.viewModel.type = self.type;
    self.isFirstLoad = YES;
    self.actionVM = [QMMBottomActionVM new];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.viewModel.dataArray[section];
    if (self.viewModel.dataArray.count == 2 && section == 0) {
        return 1;
    }
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.viewModel.dataArray[indexPath.section];
    QMMMemberInfoModel *m = arr[indexPath.row];
    
    if (self.viewModel.hasCommend && indexPath.section == 0) {
        QMMMeetingCommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommendCellReuseID forIndexPath:indexPath];
        cell.dataArray = arr;
        NSString *title = @"今日推荐";
        switch (self.type) {
            case ContentTypeRecommend:
                break;
            case ContentTypeLatest:
                title = @"最新推荐";
                break;
            case ContentTypeNearby:
                title = @"最近推荐";
                break;
            default:
                break;
        }
        cell.title = title;
        cell.itemClickedAction = ^(QMMMemberInfoModel *m) {
            NSDictionary *params = @{@"uid": m.uid ?: @""};
            [YSMediator pushToViewController:kModuleUserInfo
                                  withParams:params
                                    animated:YES
                                    callBack:NULL];
            //[self go2DatingWithModel:m];
        };
        cell.heartAction = ^(QMMMemberInfoModel *m) {
            [self doHeartActionWithModel:m];
        };
        cell.topAction = ^{
            [self popPayTopView];
        };
        return cell;
    }
    else {
        QMMInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoListCellReuseID forIndexPath:indexPath];
        cell.cellType = self.type == ContentTypeNearby ? InfoListCellTypeDistance : InfoListCellTypeCity;
        cell.model = m;
        cell.heartClickHandler = ^(NSString *uid, NSInteger beckoningstatus) {
            [self doHeartActionWithModel:m];
        };
        cell.msgClickHandler = ^(NSString *uid, NSString * name,NSString * avatar) {
            if(![[QMMUserContext shareContext].userModel.vipstatus boolValue]) {
                [self showPayAlert];
                return;
            }
            
            [YSMediator  pushToViewController:kMessageDetail
                                   withParams:@{@"cantactName":name,@"cantactID":uid,@"avatar":avatar }
                                     animated:YES
                                     callBack:nil];
        };
        cell.dateClickHandler = ^(NSString *dateId, NSString *uid) {
            [self go2DatingWithModel:m];
        };
        cell.memberClicked = ^{
            [YSMediator pushToViewController:kModuleMembership
                                  withParams:nil
                                    animated:YES
                                    callBack:NULL];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? 200 : 165;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.viewModel.dataArray[indexPath.section];
    QMMMemberInfoModel *m = arr[indexPath.row];
    NSDictionary *params = @{@"uid": m.uid ?: @""};
    [YSMediator pushToViewController:kModuleUserInfo
                          withParams:params
                            animated:YES
                            callBack:NULL];
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    @weakify(self);
    self.tableView.mj_header = [YSRefresher headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestData];
    }];
    self.tableView.mj_footer = [YSRefresher footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestMoreData];
    }];
    
    [self.tableView registerClass:[QMMMeetingCommendCell class] forCellReuseIdentifier:kCommendCellReuseID];
    [self.tableView registerClass:[QMMInfoListCell class] forCellReuseIdentifier:kInfoListCellReuseID];
    
//    _tableView = ({
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        tableView.dataSource = self;
//        tableView.delegate = self;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        @weakify(self);
//        tableView.mj_header = [YSRefresher headerWithRefreshingBlock:^{
//            @strongify(self);
//            [self requestData];
//        }];
//        tableView.mj_footer = [YSRefresher footerWithRefreshingBlock:^{
//            @strongify(self);
//            [self requestMoreData];
//        }];
//        [self.view addSubview:tableView];
//        
//        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
//        
//        [tableView registerClass:[QMMMeetingCommendCell class] forCellReuseIdentifier:kCommendCellReuseID];
//        [tableView registerClass:[QMMInfoListCell class] forCellReuseIdentifier:kInfoListCellReuseID];
//        
//        tableView;
//    });
}

@end
