//
//  HYUserBasicInfoVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUserBasicInfoVC.h"
#import "HYUserBasicInfoVM.h"
#import "YSPickerView.h"
#import "YSPickerViewData.h"
#import "HYUserBasicInfoCell.h"
#import "HYUpdateUserInfoHelper.h"

@interface HYUserBasicInfoVC ()

@property (nonatomic, strong) HYUserBasicInfoVM *viewModel;
@property (nonatomic, strong) YSPickerView *pickerView;
@property (nonatomic, strong) HYUpdateUserInfoHelper *updateHelper;

@end

@implementation HYUserBasicInfoVC

+ (void)load {
    [self mapName:@"kModuleBasicInfo" withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self bind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - Bind

- (void)bind {
    [super bind];
    
    @weakify(self);
    [[self.updateHelper.updateCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        [YSProgressHUD showTips:x];
    }];
    
    [[self.updateHelper.updateCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
    }];
    
    [self.updateHelper.updateCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
}


#pragma mark - Initialize

- (void)initialize {
    [super initialize];
    
    self.navigationItem.title = self.type == UserInfoEditTypeBasic ? @"基本资料" : @"交友条件";
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewModel = [HYUserBasicInfoVM new];
    self.viewModel.type = self.type;
    self.viewModel.infoModel = self.infoModel;
    self.updateHelper = [HYUpdateUserInfoHelper new];
}


#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYUserBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID" forIndexPath:indexPath];
    cell.cellModel = self.viewModel.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (void)showPickerViewWithModel:(HYUserBasicInfoCellModel *)model type:(BasicInfoCellType)type {
    NSArray *dataArr = nil;
    YSPickerViewType pType = 0;
    BOOL sameData = NO;
    switch (type) {
        case BasicInfoCellTypeWorkPlace:
        case BasicInfoCellTypeHome:
        case BasicInfoCellTypeFriendWorkPlace:
        case BasicInfoCellTypeFriendHome:
            pType = YSPickerViewTypeTriple;
            dataArr = [YSPickerViewData shareData].places;
            break;
        case BasicInfoCellTypeBirthday:
            pType = YSPickerViewTypeDate;
            break;
        case BasicInfoCellTypeHeight:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].heightRange;
            break;
        case BasicInfoCellTypeEdu:
        case BasicInfoCellTypeFriendEdu:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].degree;
            break;
        case BasicInfoCellTypeIncome:
        case BasicInfoCellTypeFriendIncome:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].salary;
            break;
        case BasicInfoCellTypeConstellation:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].constellation;
            break;
        case BasicInfoCellTypeMarryDate:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].wantMarrayTime;
            break;
        case BasicInfoCellTypeMarryStatus:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].marryStatus;
            break;
        case BasicInfoCellTypeFriendHeight:
            pType = YSPickerViewTypeDouble;
            sameData = YES;
            dataArr = [YSPickerViewData shareData].heightRange;
            break;
        case BasicInfoCellTypeFriendAge:
            pType = YSPickerViewTypeDouble;
            sameData = YES;
            dataArr = [YSPickerViewData shareData].friendAgeRange;
        default:
            break;
    }
    
    _pickerView = [YSPickerView pickerViewWithType:pType];
    _pickerView.mutilComponentSameData = sameData;
    @weakify(self);
    @weakify(model);
    [_pickerView showPickerViewWithDataArray:dataArr sureHandle:^(NSArray<YSPickerViewModel *> *arr) {
        @strongify(self);
        @strongify(model);
        NSString *str = @"";
        YSPickerViewModel *m0 = [self modelIn:arr atIndex:0];
        YSPickerViewModel *m1 = [self modelIn:arr atIndex:1];
        YSPickerViewModel *m2 = [self modelIn:arr atIndex:2];
        
        NSDictionary *params;
        switch (type) {
            case BasicInfoCellTypeWorkPlace: {
                str = [NSString stringWithFormat:@"%@ %@ %@", m0.name, m1.name, m2.name];
                params = @{@"dk":@"workarea", @"dv": m2.mid ?: @0};
                break;
            }
            case BasicInfoCellTypeHome:{
                str = [NSString stringWithFormat:@"%@ %@ %@", m0.name, m1.name, m2.name];
                params = @{@"dk":@"homearea", @"dv": m2.mid ?: @0};
                break;
            }
            case BasicInfoCellTypeBirthday: {
                str = [NSString stringWithFormat:@"%@ %@ %@", m0.name, m1.name, m2.name];
                params = @{@"dk":@"birthday", @"dv": str};
                break;
            }
            case BasicInfoCellTypeHeight: {
                str = m0.name;
                params = @{@"dk":@"height", @"dv": m0.mid ?: @0};
                break;
            }
            case BasicInfoCellTypeEdu: {
                str = m0.name;
                params = @{@"dk":@"degree", @"dv": m0.name ?: @0};
                break;
            }
            case BasicInfoCellTypeIncome: {
                str = m0.name;
                params = @{@"dk":@"salary", @"dv": m0.mid ?: @0};
                break;
            }
            case BasicInfoCellTypeConstellation:
                str = m0.name;
                params = @{@"dk":@"constellation", @"dv": m0.name ?: @0};
                break;
            case BasicInfoCellTypeMarryDate:
                str = m0.name;
                params = @{@"dk":@"wantmarry", @"dv": m0.name ?: @0};
                break;
            case BasicInfoCellTypeMarryStatus: {
                str = m0.name;
                params = @{@"dk":@"marry", @"dv": m0.name ?: @0};
                break;
            }
            case BasicInfoCellTypeFriendWorkPlace: {
                str = [NSString stringWithFormat:@"%@ %@ %@", m0.name, m1.name, m2.name];
                params = @{@"dk":@"wantworkarea", @"dv": m2.mid ?: @0};
                break;
            }
            case BasicInfoCellTypeFriendHome: {
                str = [NSString stringWithFormat:@"%@ %@ %@", m0.name, m1.name, m2.name];
                params = @{@"dk":@"wanthomearea", @"dv": m2.mid ?: @0};
                break;
            }
            case BasicInfoCellTypeFriendAge: {
                str = [NSString stringWithFormat:@"%@-%@", m0.name, m1.name];
                NSString *value = [NSString stringWithFormat:@"%@-%@", m0.mid, m1.mid];
                params = @{@"dk":@"wantage", @"dv": value};
                break;
            }
            case BasicInfoCellTypeFriendHeight: {
                str = [NSString stringWithFormat:@"%@-%@", m0.name, m1.name];
                NSString *value = [NSString stringWithFormat:@"%@-%@", m0.mid, m1.mid];
                params = @{@"dk":@"wantheight", @"dv": value};
                break;
            }
            case BasicInfoCellTypeFriendEdu: {
                str = m0.name;
                params = @{@"dk":@"wantdegree", @"dv": m0.name ?: @0};
                break;
            }
            case BasicInfoCellTypeFriendIncome: {
                str = m0.name;
                params = @{@"dk":@"wantsalary", @"dv": m0.name ?: @0};
                break;
            }
            default:
                break;
        }
        
        model.info = str;
        [self.updateHelper.updateCmd execute:params];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYUserBasicInfoCellModel *cellModel = self.viewModel.dataArray[indexPath.row];
    BasicInfoCellType type = cellModel.type;
    
    HYUserCenterModel *model = self.viewModel.infoModel;
    @weakify(cellModel);
    id callback = ^(NSString *str){
        @strongify(cellModel);
        cellModel.info = str;
    };
    if (type == BasicInfoCellTypeName) {
        [YSMediator pushToViewController:kModuleInfoEdit
                              withParams:@{
                                           @"callback": callback,
                                           @"type": @0,
                                           @"info": model.name ?: @""
                                           }
                                animated:YES
                                callBack:NULL];
    }
    else if (type == BasicInfoCellTypeJob) {
        [YSMediator pushToViewController:kModuleInfoEdit
                              withParams:@{
                                           @"callback": callback,
                                           @"type": @1,
                                           @"info": model.personal ?: @""
                                           }
                                animated:YES
                                callBack:NULL];
    }
    else {
        [self showPickerViewWithModel:cellModel type:type];
    }
    
    
}

- (YSPickerViewModel *)modelIn:(NSArray *)arr atIndex:(NSInteger)idx {
    if (arr.count == 0 || (arr.count && arr.count <= idx)) return nil;
    return arr[idx];
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HYUserBasicInfoCell class] forCellReuseIdentifier:@"reuseID"];
}
@end
