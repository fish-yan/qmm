//
//  HYDatingListContentVC.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "HYDatingListContentVC.h"
#import "HYDatingListVM.h"
#import "HYDatingListCell.h"
#import "HYDatingInfoModel.h"
#import "QMMUnreadMsgFetcher.h"

@interface HYDatingListContentVC ()

@property (nonatomic, strong) HYDatingListVM *viewModel;

@property (nonatomic, strong) UILabel *emptyInfoLabel;
//@property (nonatomic, strong) UIButton *emptyDatingBtn;

@end

@implementation HYDatingListContentVC

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [YSProgressHUD showInView:self.view];
    [self requestData];
    // 请求最新的未读数据
    
    [[QMMUnreadMsgFetcher shareInstance].unreadMsgCmd execute:nil];
}


#pragma mark - Request

- (void)requestData {
    [self.viewModel.requestCmd execute:nil];
}

- (void)requestMoreData {
    [self.viewModel.requestMoreCmd execute:nil];
}


#pragma mark - Action

- (void)go2dating {
    [[QMMUIAssistant shareInstance].rootTabBarController setSelectedIndex:0];
}

- (void)endRefreshing {
    [YSProgressHUD hiddenHUD];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [[[self.viewModel.requestCmd.executionSignals switchToLatest]
     merge:[self.viewModel.requestMoreCmd.executionSignals switchToLatest]]
subscribeNext:^(NSArray * _Nullable x) {
        @strongify(self);
        [self endRefreshing];
        [self.view hiddenFailureView];
        [self.tableView reloadData];
    
        if (self.requestHandler) {
            self.requestHandler(self.viewModel.totalCount);
        }
    }];

    [self.viewModel.requestCmd.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [YSProgressHUD showTips:x.localizedDescription];
        
        [self.view showFailureViewOfType:WDFailureViewTypeError withClickAction:^{
            @strongify(self);
            [YSProgressHUD showInView:self.view];
            [self requestData];
        }];
    }];
    
    [[self.viewModel.requestCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (![x boolValue]) {
            if (!self.viewModel.dataArray || self.viewModel.dataArray.count == 0) {
                [self.view showFailureViewOfType:WDFailureViewTypeEmpty withClickAction:^{
                    @strongify(self);
                    [YSProgressHUD showInView:self.view];
                    [self requestData];
                }];
            }
//            [self changeGo2DatingViewDisplay:(!self.viewModel.dataArray || self.viewModel.dataArray.count == 0)];
        }
    }];
    
    //
    [self.viewModel.requestMoreCmd.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
        [YSProgressHUD showTips:x.localizedDescription];
    }];
    
    
    RAC(self.tableView.mj_footer, hidden) = [RACObserve(self.viewModel, hasMore) not];
}

- (void)changeGo2DatingViewDisplay:(BOOL)isShow {
    self.emptyInfoLabel.hidden = !isShow;
    //self.emptyDatingBtn.hidden = !isShow;
    self.tableView.hidden = isShow;
}


#pragma mark - Initialize

- (void)initialize {
    self.viewModel = [HYDatingListVM new];
    self.viewModel.status = self.status;
    self.viewModel.type = self.type;
    self.view.backgroundColor = [UIColor colorWithRed:250/255. green:250/255. blue:250/255. alpha:1];
}



#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYDatingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID"];
    if (!cell) {
        cell = [[HYDatingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseID"];
    }
    cell.model = self.viewModel.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYDatingInfoModel *info = self.viewModel.dataArray[indexPath.row];
    NSDictionary *params = @{
                             @"dateID": info.mid ?: @"",
                             @"appointmentstatus": @1,
                             @"uid": info.uid ?: @"",
                             @"avatar": info.avatar ?: @"",
                             @"name": info.name ?: @""
                             };

    [YSMediator pushToViewController:kModuleDatingInfo
                          withParams:params
                            animated:YES
                            callBack:NULL];
}



#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [YSRefresher headerWithRefreshingBlock:^{
        [self requestData];
    }];
    self.tableView.mj_footer = [YSRefresher footerWithRefreshingBlock:^{
        [self requestMoreData];
    }];
    
    _emptyInfoLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(140,285,96,18);
        label.text = @"暂无相关数据";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:49/255.0 alpha:1];
        label.hidden = YES;
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.offset(168);
        }];
        
        label;
    });
    
//    _emptyDatingBtn = ({
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 60, 45);
//        [btn setTitle:@"约一下咯" forState:UIControlStateNormal];
//        [btn setBackgroundImage:[self gradientImageOfSize:btn.bounds] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:16];
//        btn.layer.cornerRadius = 22.5;
//        btn.clipsToBounds = YES;
//        btn.hidden = YES;
//        [btn addTarget:self action:@selector(go2dating) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
//
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.emptyInfoLabel.mas_bottom).offset(140);
//            make.centerX.equalTo(self.view);
//        }];
//        btn;
//    });
    
    
}

- (UIImage *)gradientImageOfSize:(CGRect)bounds {
    CAGradientLayer *layer = [CAGradientLayer layer];
    UIColor *color0 = [UIColor colorWithHexString:@"#FF599E"];
    UIColor *color1 = [UIColor colorWithHexString:@"#FFAB68"];
    layer.colors = @[(id)color0.CGColor,
                     (id)color1.CGColor];
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1, 0.5);
    layer.frame = bounds;
    //layer.locations = @[@(0.0f), @(1)];
    
    UIGraphicsBeginImageContext(layer.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}


#pragma mark - Lazy Loading



@end
