//
//  HYDatingRuleVC.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "HYDatingRuleVC.h"
#import "HYDatingRuleCell.h"

@interface HYDatingRuleVC ()

@property (nonatomic, strong) UIScrollView *container;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HYDatingRuleVC

+ (void)load {
    [self mapName:kModuleDatingRule withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self setupSubviewsLayout];
    [self bind];
}


#pragma mark - Action


#pragma mark - Bind

- (void)bind {
}


#pragma mark - Initialize

- (void)initialize {
    self.navigationItem.title = @"规则";
}



#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYDatingRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID" forIndexPath:indexPath];
    
    [self configCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configCell:(HYDatingRuleCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *rule = self.dataArray[indexPath.section];
    
    cell.titleLabel.text = rule[@"title"];
    cell.info = rule[@"info"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"reuseID" configuration:^(id cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView viewWithBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"] inView:nil];
}



#pragma mark - Setup Subviews

- (void)setupSubviews {
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        [tableView registerClass:[HYDatingRuleCell class] forCellReuseIdentifier:@"reuseID"];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
}

- (void)setupSubviewsLayout {
}


#pragma mark - Lazy Loading

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@{@"title": @"约会流程",
                         @"info": @"1.一方选择约会时间、地点，支付约会保证金，向另一方发出约会邀请。\n2.另一方同意约会（支付约会保证金）、或拒绝约会（拒绝后线上约会流程关闭）。\n3.双方按约定的约会时间、地点进行线下见面约会（在规定时间内线上【签到赴约】），线上约会流程结束。\n4.申请取消约会的：约会达成后，一方发起【取消约会】申请，只有另一方同意后，约会才算取消成功；否则，双方都应按约定时间进行线下赴约；每方最多可申请取消3次。"
                         },
                       @{@"title": @"约会保证金",
                         @"info": @"“约会保证金”是保障您和约会对象双方利益的一种有效机制，具体如下：\n1.若对方没有按时接受您的邀请，保证金将全额退还至您的钱包账户；\n2.若您或者对方协商一致取消约会，双方保证金将全额退还至双方的钱包账户；\n3.若双方达成约会共识，一方违约（即未到场签到），您的保证金将全额退还至您的钱包账户、且违约方的保证金也将全额补偿给如约方（共计398元）；\n4.若双方达成约会共识，两方违约（即均未到场签到），则双方保证金均不退还；\n5.若您和对方成功约会，保证金将退还90%至您的钱包账户，平台各收取10%（即19.9元）作为佣金。"
                         },
                       @{@"title": @"约会小贴士",
                         @"info": @"1.为保证您和对方的人身安全，请选择咖啡馆/餐厅/商场等公开场所见面；\n2.发起约会前，可先与对方协商好约会时间、地点，提高约会成功率；\n3.见面前，请和对方线上多多交流，多了解对方的性格爱好；\n4.约会前，请给自己准备一套得体的服装，第一印象很重要；\n5.约会时，多问问对方的意见，让对方感受到你是一个很体贴的人；\n6.祝您有一个难忘的约会。"
                         },];
    }
    return _dataArray;
}

@end
