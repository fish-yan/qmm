//
//  QMMCitiesListVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMCitiesListVC.h"
#import "QMMCitiesListVM.h"
#import "QMMCityModel.h"

@interface QMMCitiesListVC ()

@property (nonatomic, strong) QMMCitiesListVM *viewModel;

@end

@implementation QMMCitiesListVC



#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    
}


#pragma mark - Action

- (void)requestData {
    [YSProgressHUD showInView:self.view];
    [self.viewModel.fetchCitiesCmd execute:nil];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [[[self.viewModel.fetchCitiesCmd executionSignals] switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        [self.tableView reloadData];
    }];
    
    [[self.viewModel.fetchCitiesCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
    }];
    
    [self.viewModel.fetchCitiesCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
        [self.view showFailureViewOfType:WDFailureViewTypeError withClickAction:^{
            @strongify(self);
            [self requestData];
        }];
    }];
    
}


#pragma mark - Initialize

- (void)initialize {
    [super initialize];
    
    self.navigationItem.title = @"选择城市";
    self.viewModel = [QMMCitiesListVM new];
}



#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.cities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.viewModel.cities[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseId"];
    }
    
    NSArray *arr = self.viewModel.cities[indexPath.section];
    QMMCityModel *model = arr[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    label.text = [NSString stringWithFormat:@"  %@", self.viewModel.indexArr[section]];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.viewModel.indexArr;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.viewModel.cities[indexPath.section];
    QMMCityModel *model = arr[indexPath.row];
    NSDictionary *info = @{
                           @"name": model.name,
                           @"pinyin": model.pinyin,
                           @"mid": model.code
                           };
    if (self.callBack) {
        self.callBack(info);
    }
    [self popBack];
}



#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_back"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(dismiss)];
    
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
}

@end
