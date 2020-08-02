//
//  HYPrivateListViewController.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYPrivateListViewController.h"
#import "QMMUnreadMsgFetcher.h"

#define HYPRIVVATE_CELL_INDENTIFY @"HyprivateListcell_indentify"

@interface HYPrivateListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYPrivateListViewModel *viewModel;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation HYPrivateListViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewModel = [HYPrivateListViewModel new];
    self.canBack = NO;
    [self setUpView];
    [self bindmodel];
    [YSProgressHUD showInView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewModel.page = 1;
    [self.viewModel.doCommand execute:@"1"];
    // 获取最新的未读信息数据
    [[QMMUnreadMsgFetcher shareInstance].unreadMsgCmd execute:nil];
}

- (void)setUpView {
    self.tableView = [UITableView tableViewOfStyle:UITableViewStylePlain
                                            inView:self.view
                                    withDatasource:self
                                          delegate:self];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor              = [UIColor clearColor];
    [self.tableView registerClass:[HYPrivateListCell class] forCellReuseIdentifier:HYPRIVVATE_CELL_INDENTIFY];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44);
    }];

    self.tableView.mj_header = [YSRefresher headerWithRefreshingBlock:^{
        @strongify(self);

        self.viewModel.page = 1;
        [self.viewModel.doCommand execute:@"1"];
    }];

    self.tableView.mj_footer = [YSRefresher footerWithRefreshingBlock:^{
        [self.viewModel.doCommand execute:@"1"];
    }];
}


#pragma mark-- tableview delegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYPrivateListCell *cell    = [tableView dequeueReusableCellWithIdentifier:HYPRIVVATE_CELL_INDENTIFY];
    HYPrivateCellViewModel *vm = [self.viewModel.listArray objectAtIndex:indexPath.row];
    [cell bindWithViewModel:vm];
    cell.showBottomLine = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105.0;
}

- (void)showPayAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"升级会员即可无限畅聊"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action){

                                            }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"免费试用"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *_Nonnull action) {
                          [YSMediator pushToViewController:kModuleMembership
                                                withParams:@{}
                                                  animated:YES
                                                  callBack:nil];
                      }]];
    
    [self presentViewController:alert
                       animated:YES
                     completion:^{

                     }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[QMMUserContext shareContext].userModel.vipstatus boolValue]) {
        [self showPayAlert];
        return;
    }

    HYPrivateCellViewModel *vm = [self.viewModel.listArray objectAtIndex:indexPath.row];

    if ([vm.usertype intValue] == 3) {
        [vm.doRecommand execute:@"1"];
        [YSMediator pushToViewController:kMessageDetail
                              withParams:@{
                                  @"cantactName": vm.userName,
                                  @"cantactID": vm.uid,
                                  @"avatar": vm.photoString
                              }
                                animated:YES
                                callBack:nil];
        return;
    }


    if (![[QMMUserContext shareContext].userModel.vipstatus boolValue]) {
        [YSMediator pushToViewController:kModuleMembership
                              withParams:@{}
                                animated:YES
                                callBack:nil];
        return;
    }

    [vm.doRecommand execute:@"1"];
    [YSMediator pushToViewController:kMessageDetail
                          withParams:@{
                                       @"cantactName": vm.userName,
                                       @"cantactID": vm.uid,
                                       @"avatar": vm.photoString
                                       }
                            animated:YES
                            callBack:^{
                                HYPrivateCellViewModel *vm = [self.viewModel.listArray objectAtIndex:indexPath.row];
                                vm.hasRead = YES;
                                // 获取最新的未读信息数据
                                [[QMMUnreadMsgFetcher shareInstance].unreadMsgCmd execute:nil];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 从数据源中删除
    NSMutableArray *array     = [NSMutableArray arrayWithArray:self.viewModel.listArray];
    HYPrivateCellViewModel *m = [array objectAtIndex:indexPath.row];
    [array removeObjectAtIndex:indexPath.row];
    //这边需要调用删除接口
    [self.viewModel.dodeleteCommand execute:@{ @"id": m.messageID }];

    self.viewModel.listArray = [array copy];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)bindmodel {
    @weakify(self);
    [[self.viewModel.doCommand.executionSignals switchToLatest] subscribeNext:^(id _Nullable x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [YSProgressHUD hiddenHUD];
        [self.view hiddenFailureView];
        [self.tableView reloadData];
        if (self.viewModel.listArray.count == 0) {
            [self.view showFailureViewOfType:WDFailureViewTypeMessageEmpty
                             withClickAction:^{
                                 [YSProgressHUD showInView:self.view];
                                 [self.view hiddenFailureView];
                                 self.viewModel.page = 1;
                                 [self.viewModel.doCommand execute:@1];

                             }];
        }

    }];
    [self.viewModel.doCommand.errors subscribeNext:^(NSError *_Nullable x) {
        [YSProgressHUD hiddenHUD];
        [self.view hiddenFailureView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [YSProgressHUD showTips:x.localizedDescription];

        [self.view showFailureViewOfType:WDFailureViewTypeError
                         withClickAction:^{
                             [YSProgressHUD showInView:self.view];
                             [self.view hiddenFailureView];
                             self.viewModel.page = 1;
                             [self.viewModel.doCommand execute:@1];

                         }];


    }];

    [RACObserve(self.viewModel, hasMore) subscribeNext:^(NSNumber *_Nullable x) {

        @strongify(self);
        if ([x boolValue]) {
            self.tableView.mj_footer.hidden = NO;
        }
        else
        {
            self.tableView.mj_footer.hidden=YES;
        }

    }];
}

@end
