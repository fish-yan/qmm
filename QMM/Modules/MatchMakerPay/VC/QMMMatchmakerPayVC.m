//
//  QMMMatchmakerPayVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMMatchmakerPayVC.h"
#import "QMMMatchmakerPayVM.h"
#import "HYMatchMakerPayItemCell.h"
#import "HYMatchMakerPayIntroCell.h"

static NSString *const kIntroCell = @"kIntroCell";
static NSString *const kItemCell = @"kItemCell";

@interface QMMMatchmakerPayVC ()

@property (nonatomic, strong) QMMMatchmakerPayVM *viewModel;

@end

@implementation QMMMatchmakerPayVC

#pragma mark - Life Circle

+ (void)load {
    [self mapName:kModuleMatchMakerPay withParams:@{@"payResultHandler": @"rst"}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestProducts];
}


#pragma mark - Action

- (void)requestProducts {
    [FYVIPViewModel request:@"4" complete:^(NSArray<FYProduct *> * _Nonnull dataArray) {
        NSMutableArray *arr = [NSMutableArray array];
        for (FYProduct *p in dataArray) {
            [arr addObject:p.productIdentifier];
        }
        self.viewModel.iapHelper.identifiers = arr;
        self.viewModel.productIdentifiers = arr;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YSProgressHUD showInView:self.view];
        @weakify(self);
        [self.viewModel fetchDataWithResult:^(NSArray * _Nonnull d, NSError * _Nonnull error) {
            @strongify(self);
            [self.viewModel updateDataArray:dataArray];
            [self.tableView reloadData];
            [YSProgressHUD hiddenHUD];
            
        }];
        });
        
    }];
    
}

- (void)purchase {
    [self.viewModel.fetchOrderIDCmd execute:nil];
}

#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [[self.viewModel.fetchOrderIDCmd.executionSignals switchToLatest] subscribeNext:^(id _Nullable x) {
        @strongify(self);
        [self.viewModel purchaseWithResult:^(NSString * _Nonnull receipt, NSError * _Nonnull error) {
            @strongify(self);
            NSLog(@"%@", error);
            if (error) {
                [YSProgressHUD hiddenHUD];
                [YSProgressHUD showTips:error.localizedDescription];
                return;
            }
            
            [self.viewModel.checkReceiptCmd execute:receipt];
        }];
    }];
    
    [self.viewModel.fetchOrderIDCmd.errors subscribeNext:^(NSError *_Nullable x) {
        [YSProgressHUD hiddenHUD];
        [YSProgressHUD showTips:x.localizedDescription];
    }];
    
    [[self.viewModel.fetchOrderIDCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
    }];
    
    //
    [[self.viewModel.checkReceiptCmd.executionSignals switchToLatest] subscribeNext:^(id _Nullable x) {
        [[QMMUserContext shareContext] fetchLatestUserinfoWithSuccessHandle:^(HYUserModel *infoModel) {
            [YSProgressHUD hiddenHUD];
            @strongify(self);
            if (self.payResultHandler) {
                self.payResultHandler(YES);
            }
            
            [[QMMUserContext shareContext] deployLoginActionWithUserModel:infoModel];
            [YSMediator pushToViewController:kModulePaySuccess
                                  withParams:@{@"isFromProfile": @1}
                                    animated:YES
                                    callBack:NULL];
            
        }
                                                             failureHandle:^(NSError *error) {
                                                                 [YSProgressHUD hiddenHUD];
                                                             }];
        
        
    }];
    [self.viewModel.checkReceiptCmd.errors subscribeNext:^(NSError *_Nullable x) {
        [YSProgressHUD hiddenHUD];
        [YSProgressHUD showTips:@"购买凭证校验失败"];
    }];
}


#pragma mark - Initialize

- (void)initialize {
    self.navigationItem.title = @"红娘推荐";
    self.viewModel = [QMMMatchmakerPayVM new];
}


#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMMMatchmakerPayCellModel *m = self.viewModel.dataArray[indexPath.row];
    switch (m.type) {
        case HYMatchMakerPayCellTypeIntro: {
            HYMatchMakerPayIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:kIntroCell forIndexPath:indexPath];
            return cell;
            break;
        }
        case HYMatchMakerPayCellTypeItems: {
            HYMatchMakerPayItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemCell forIndexPath:indexPath];
            cell.dataArray = m.date;
            @weakify(self);
            cell.selectedHandler = ^(NSInteger idx) {
                @strongify(self);
                self.viewModel.itemSelectedIdx = idx;
            };
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMMMatchmakerPayCellModel *m = self.viewModel.dataArray[indexPath.row];
    switch (m.type) {
        case HYMatchMakerPayCellTypeIntro: {
            return SCREEN_WIDTH /375.0 * 305.0;
            break;
        }
        case HYMatchMakerPayCellTypeItems:
            return 270;
            break;
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [self footerView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYMatchMakerPayIntroCell" bundle:nil] forCellReuseIdentifier:kIntroCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYMatchMakerPayItemCell" bundle:nil] forCellReuseIdentifier:kItemCell];
}

- (void)setupSubviewsLayout {
    [super setupSubviewsLayout];
}


- (UIView *)footerView {
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    
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
                                                 [self purchase];
                                             }];
    
    UILabel *l1 = [self protocalLabel:@"服务协议" action:^{
        [YSMediator openURL:@"https://www.huayuanvip.com/help/WXNVIPprotcol.html"];
    }];
    [content addSubview:l1];
    
    UILabel *l2 = [self protocalLabel:@"订阅协议" action:^{
        [YSMediator openURL:@"https://www.huayuanvip.com/help/dingyueprotcol.html"];
    }];
    [content addSubview:l2];
    
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.mas_equalTo(45);
    }];
    
    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(submitBtn.mas_bottom).offset(44);
        make.right.equalTo(content.mas_centerX).offset(-20);
    }];
    
    [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(submitBtn.mas_bottom).offset(44);
        make.left.equalTo(content.mas_centerX).offset(20);
    }];
    
    return content;
}


- (UILabel *)protocalLabel:(NSString *)protocal action:(void(^)(void))action {
    UILabel *label = [[UILabel alloc] init];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]
                                       initWithString:protocal
                                       attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                    NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#3DA8F5"],
                                                    }];
    
    label.attributedText = attr;
    label.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [label addGestureRecognizer:tap];
    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        if (action) {
            action();
        }
    }];
    
    return label;
}

@end
