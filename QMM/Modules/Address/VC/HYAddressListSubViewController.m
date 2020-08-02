//
//  HYAddressListSubViewController.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYAddressListSubViewController.h"
#import "HYAddressListViewModel.h"
#import "HYAddressListTableViewCell.h"
#import "HYUnreadInfoFetcher.h"

#define HYAddressListTableViewCell_ID @"HYAddressListTableViewCell"

@interface HYAddressListSubViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) HYAddressListViewModel *viewModel;

@end


@implementation HYAddressListSubViewController

+ (void)load {
    [self mapName:kModuleUserList withParams:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel      = [HYAddressListViewModel new];
    self.viewModel.type = self.currentIndex;
    [self setUpview];
    [self.mTableView reloadData];
    [self bindViewModel];

    [YSProgressHUD showInView:self.mTableView];
    [self.viewModel.getAddresslistRaccommand execute:@{
        @"type": @(self.currentIndex + 1),
        @"page": @(1),
        @"count": @(20)
    }];


    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 获取最新的未读信息数据
    [[HYUnreadInfoFetcher shareInstance].unreadMsgCmd execute:nil];
}

- (void)setUpview {
    self.mTableView =
    [UITableView tableViewOfStyle:UITableViewStyleGrouped inView:self.view withDatasource:self delegate:self];
    self.mTableView.showsVerticalScrollIndicator = NO;
    self.mTableView.estimatedRowHeight           = 0;
    ;
    self.mTableView.estimatedSectionHeaderHeight = 0;
    self.mTableView.estimatedSectionFooterHeight = 0;
    self.mTableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.mTableView.backgroundColor              = [UIColor whiteColor];

    [self.mTableView registerClass:[HYAddressListTableViewCell class]
            forCellReuseIdentifier:HYAddressListTableViewCell_ID];
    [self.view addSubview:self.mTableView];
    @weakify(self);
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-64 - 50);
    }];

    self.mTableView.mj_footer = [YSRefresher footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.getAddresslistRaccommand execute:@{
            @"type": @(self.currentIndex + 1),
            @"page": @(self.viewModel.page),
            @"count": @(20)
        }];
    }];
    self.mTableView.mj_header = [YSRefresher headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.getAddresslistRaccommand execute:@{
            @"type": @(self.currentIndex + 1),
            @"page": @(1),
            @"count": @(20)
        }];
    }];

    self.mTableView.mj_footer.hidden = YES;
}

- (void)bindViewModel {
    @weakify(self);
    [[self.viewModel.getAddresslistRaccommand.executionSignals switchToLatest] subscribeNext:^(id _Nullable x) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        [self.mTableView hiddenFailureView];
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
        if (self.viewModel.convertArray.count == 0) {
            [self.mTableView showFailureViewOfType:WDFailureViewTypeEmpty
                                   withClickAction:^{
                                       @strongify(self);
                                       [YSProgressHUD showInView:self.mTableView];
                                       [self.mTableView hiddenFailureView];
                                       [self.viewModel.getAddresslistRaccommand execute:@{
                                           @"type": @(self.currentIndex + 1),
                                           @"page": @(1),
                                           @"count": @(20)
                                       }];
                                   }];
        } else {
            [self.mTableView reloadData];
        }
        self.mTableView.mj_footer.hidden = !self.viewModel.hasMore;
    }];
    [self.viewModel.getAddresslistRaccommand.errors subscribeNext:^(NSError *_Nullable x) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        [self.mTableView hiddenFailureView];
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
        [self.mTableView showFailureViewOfType:WDFailureViewTypeError
                               withClickAction:^{
                                   @strongify(self);
                                   [YSProgressHUD showInView:self.mTableView];
                                   [self.mTableView hiddenFailureView];
                                   [self.viewModel.getAddresslistRaccommand execute:@{
                                       @"type": @(self.currentIndex + 1),
                                       @"page": @(1),
                                       @"count": @(20)
                                   }];
                               }];
    }];
}

#pragma mark tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.convertArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYAddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HYAddressListTableViewCell_ID];
    [cell bindWithViewModel:self.viewModel.convertArray[indexPath.row]];
    return cell;
}
@end
