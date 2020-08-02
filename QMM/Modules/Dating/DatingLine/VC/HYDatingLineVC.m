//
//  HYDatingLineVC.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/26.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYDatingLineVC.h"
#import "HYDatingLineCell.h"
#import "HYDatingLineVM.h"

static NSString *const kDatingLineCellReuseID = @"kDatingLineCellReuseID";

@interface HYDatingLineVC ()

@property (nonatomic, strong) HYDatingLineVM *viewModel;

@end

@implementation HYDatingLineVC

+ (void)load {
    [self mapName:kModuleDatingLine withParams:nil];
}


#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YSProgressHUD showInView:self.view];
    [self requestData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                                                  forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - Action

- (void)requestData {
    [self.viewModel.requestCmd execute:nil];
}


#pragma mark - Bind

- (void)bind {
    [super bind];
    
    @weakify(self);
    [[self.viewModel.requestCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
    }];
    
    [[self.viewModel.requestCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        [self.view hiddenFailureView];
        
        self.tableView.tableHeaderView = [self headerView];
        [self.tableView reloadData];
    }];
    
    [self.viewModel.requestCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
        @strongify(self);
        [self.view showFailureViewOfType:WDFailureViewTypeError withClickAction:^{
            @strongify(self);
            [YSProgressHUD showInView:self.view];
            [self requestData];
        }];
    }];
    
//    [RACObserve(self.viewModel, showHeaderInfo) subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        if ([x boolValue]) {
//            self.tableView.tableHeaderView = [self headerView];
//        }
//        else {
//            self.tableView.tableHeaderView = nil;
//        }
//    }];
}


#pragma mark - Initialize

- (void)initialize {
    [super initialize];
    
    self.viewModel = [HYDatingLineVM new];
    self.viewModel.dateId = self.dateId;
    self.navigationItem.titleView = [self titleLabel];
}

- (UILabel *)titleLabel {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"约会足迹";
    return titleLabel;
}


#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYDatingLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kDatingLineCellReuseID];
    if (!cell) {
        cell = [[HYDatingLineCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kDatingLineCellReuseID];
    }
    cell.model = self.viewModel.dataArray[indexPath.row];
    cell.isFirstItem = (indexPath.row == 0);
    cell.isLastItem = (indexPath.row == (self.viewModel.dataArray.count - 1));
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HYDatingLineCell" bundle:nil]
         forCellReuseIdentifier:kDatingLineCellReuseID];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupSubviewsLayout {
    [super setupSubviewsLayout];
}

- (UIView *)headerView {
    CGSize size = CGSizeMake(SCREEN_WIDTH, 230);
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    container.backgroundColor = [UIColor colorWithPatternImage:[UIImage gradientImageOfSize:size]];
    
    
    UIImageView *sourceP = [self avatorWithImage:self.viewModel.initiatoravatar inView:container];
    UILabel *sourceN = [self nameLabelOfName:self.viewModel.initiatorname inView:container];

    CGFloat margin = 40;
    CGFloat wh = 65;
    [sourceP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container.mas_centerX).offset(-margin);
        make.width.height.mas_equalTo(wh);
        make.top.offset(100);
    }];
    [sourceN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sourceP.mas_bottom).offset(10);
        make.centerX.equalTo(sourceP);
    }];
    
    //
    UIImageView *targetP = [self avatorWithImage:self.viewModel.receiveravatar inView:container];
    UILabel *targetN = [self nameLabelOfName:self.viewModel.receivername inView:container];
    
    
    [targetP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_centerX).offset(margin);
        make.width.height.mas_equalTo(wh);
        make.top.offset(100);
    }];
    [targetN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(targetP.mas_bottom).offset(10);
        make.centerX.equalTo(targetP);
    }];
    
    
    return container;
}

- (UILabel *)nameLabelOfName:(NSString *)name inView:(UIView *)inView {
    return [UILabel labelWithText:name
                        textColor:[UIColor whiteColor]
                    textAlignment:NSTextAlignmentCenter
                         font:[UIFont systemFontOfSize:16]
                           inView:inView
                        tapAction:NULL];
}

- (UIImageView *)avatorWithImage:(NSString *)imgName inView:(UIView *)inView {
    UIImageView *avator = [[UIImageView alloc] init];
    avator.layer.borderColor = [UIColor whiteColor].CGColor;
    avator.layer.borderWidth = 2;
    avator.layer.cornerRadius = 65.0 * 0.5;
    avator.clipsToBounds = YES;
    [avator sd_setImageWithURL:[NSURL URLWithString:imgName]
              placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    [inView addSubview:avator];
    
    return avator;
}

#pragma mark - Lazy Loading




@end
