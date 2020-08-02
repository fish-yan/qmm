//
//  HYShopListVC.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/24.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYShopListVC.h"
#import "HYShopListCell.h"
#import "HYShopListVM.h"
#import "LocationHelper.h"
#import "SCNavigationMenuView.h"
//#import "HYCItiesListVC.h"
#import "HYCitiesListContentVC.h"

static NSString *const kShopListCellReuseID  = @"kShopListCellReuseID";

@interface HYShopListVC ()<SCNavigationMenuViewDelegate>

@property (nonatomic, strong) SCNavigationMenuView *menuView;

@property (nonatomic, strong) NSMutableArray *dataArrayM;
@property (nonatomic, strong) HYShopListVM *viewModel;
@property (nonatomic, strong) UIButton *titleCityBtn;

@end

@implementation HYShopListVC

+ (void)load {
    [self mapName:kModuleShopList withParams:nil];
}


#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YSProgressHUD showInView:self.view];
    [self requestData];
}


#pragma mark - Action


- (void)requestData {
    @weakify(self);
    [self.viewModel requestDataWithSuccessHandler:^(NSArray *arr) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        [self.tableView.mj_header endRefreshing];
        
        if (self.viewModel.dataArray.count == 0) {
            [self.view showFailureViewOfType:WDFailureViewTypeEmpty withClickAction:^{
                @strongify(self);
                [self requestData];
            }];
            return;
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        @strongify(self);
        
        [self.tableView.mj_header endRefreshing];
        [YSProgressHUD showTips:error.localizedDescription];
        
        [self.view showFailureViewOfType:WDFailureViewTypeError withClickAction:^{
            @strongify(self);
            [self requestData];
        }];
    }];
}

- (void)requestMoreData {
    @weakify(self);
    [self.viewModel requestMoreDataWithSuccessHandler:^(NSArray *arr) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        @strongify(self);
        [YSProgressHUD showTips:error.localizedDescription];
        [self.tableView.mj_footer endRefreshing];
        
        [self.view showFailureViewOfType:WDFailureViewTypeError withClickAction:^{
            @strongify(self);
            [self requestData];
        }];
    }];
}

- (void)go2chooseCity {
//    id callBack = ^(NSDictionary *info){
//        NSLog(@"---%@", info);
//    };
    
    HYCitiesListContentVC *vc = [HYCitiesListContentVC new];
    vc.callBack = ^(NSDictionary *info) {
        self.viewModel.cityName = info[@"name"];
        [self requestData];
    };
    YSNavigationController *nav = [[YSNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:NULL];
//    [YSMediator presentToViewController:@"kModuleCitiesList"
//                             withParams:@{@"callBack": callBack}
//                               animated:YES
//                               callBack:NULL];
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [RACObserve(self.viewModel, dataArray) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [RACObserve(self.viewModel, menuItems) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.menuView setNavigationMenuItems:x];
    }];
    
    RAC(self.tableView.mj_footer, hidden) = [RACObserve(self.viewModel, hasMore) not];
    
    [RACObserve(self, viewModel.cityName) subscribeNext:^(NSString * _Nullable x) {
        if (!x) return;
        @strongify(self);
        [self.titleCityBtn setTitle:x forState:UIControlStateNormal];
    }];
}


#pragma mark - Initialize

- (void)initialize {
    [super initialize];
    
    self.viewModel = [HYShopListVM new];
}


#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopListCellReuseID
                                                           forIndexPath:indexPath];
    cell.model = self.viewModel.dataArray[indexPath.row];
    cell.isCitySearch = self.viewModel.isSearchByCity;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYShopInfoModel *m = self.viewModel.dataArray[indexPath.row];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:m forKey:@"infoModel"];
    if (self.selected) {
        [params setObject:self.selected forKey:@"selected"];
    }
    [YSMediator pushToViewController:kModuleDatingShop
                          withParams:params
                            animated:YES
                            callBack:NULL];
}



#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    
    [self.tableView registerClass:[HYShopListCell class] forCellReuseIdentifier:kShopListCellReuseID];
    self.tableView.mj_header = [YSRefresher headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.tableView.mj_footer = [YSRefresher footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    

    self.navigationController.navigationBar.translucent = NO;
    NSString *city = [LocationHelper shareHelper].location.city;
    
    @weakify(self);
    _titleCityBtn = [UIButton buttonWithTitle:city ?: @"上海"
                                   titleColor:[UIColor colorWithHexString:@"#313131"]
                                     font:[UIFont systemFontOfSize:14]
                                      bgColor:nil
                                       inView:nil
                                       action:^(UIButton *btn) {
                                           @strongify(self);
                                           [self go2chooseCity];
                                       }];

    _titleCityBtn.frame = CGRectMake(0, 0, 200, 40);
    self.navigationItem.titleView = _titleCityBtn;//self.menuView;
}


#pragma mark - SCNavigationMenuViewDelegate

- (void)navigationMenuView:(SCNavigationMenuView *)navigationMenuView didSelectItemAtIndex:(NSUInteger)index {
    
}

- (void)setupSubviewsLayout {
    [super setupSubviewsLayout];
}


#pragma mark - Lazy Loading

- (SCNavigationMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[SCNavigationMenuView alloc] initWithNavigationMenuItems:nil];
        _menuView.delegate = self;
        [_menuView displayMenuInView:self.view];
    }
    return _menuView;
}


@end
