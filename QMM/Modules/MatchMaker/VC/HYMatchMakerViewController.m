//
//  HYMatchMakerViewController.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYMatchMakerViewController.h"
#import "HYMatchMakerListCell.h"
#import "YSPickerViewData.h"
#import "YSPickerView.h"

@interface HYMatchMakerViewController ()

@property (nonatomic, strong) HYMatchMakerVM *viewModel;
@property (nonatomic, strong) YSPickerView *pickerView;

@end

@implementation HYMatchMakerViewController


+ (void)load {
    [self mapName:kModuleMatchMaker withParams:nil];
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

#pragma mark - Action

- (void)submitAction {
    [YSMediator pushToViewController:kModuleUserList
                          withParams:self.viewModel.callBackParams
                            animated:YES
                            callBack:NULL];
}

- (void)resetAllSelect {
    self.viewModel = [HYMatchMakerVM new];
    [self.tableView reloadData];
}


#pragma mark - Bind

- (void)bind {
    [super bind];
}


#pragma mark - Initialize

- (void)initialize {
    [super initialize];
    
    self.navigationItem.title = @"红娘推荐";
    self.style = UITableViewStyleGrouped;
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewModel = [HYMatchMakerVM new];
}


#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HYMatchMakerCellModel *sectionModel = self.viewModel.dataArray[section];
    return sectionModel.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYMatchMakerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID" forIndexPath:indexPath];
    
    HYMatchMakerCellModel *sectionModel = self.viewModel.dataArray[indexPath.section];
    cell.cellModel = sectionModel.arr[indexPath.row];
    
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

- (void)go2openVIP {
    [YSMediator pushToViewController:kModuleMembership
                          withParams:nil
                            animated:YES
                            callBack:NULL];
}

- (void)showPickerViewWithModel:(HYMatchMakerCellModel *)model type:(FilterCellType)type {
    NSArray *dataArr = nil;
    YSPickerViewType pType = 0;
    BOOL sameData = NO;
    switch (type) {
        case FilterCellTypeLocation:
            pType = YSPickerViewTypeTriple;
            dataArr = [YSPickerViewData shareData].places;
            break;
        case FilterCellTypeAge:
            pType = YSPickerViewTypeDouble;
            dataArr = [YSPickerViewData shareData].friendAgeRange;
            sameData = YES;
            break;
        case FilterCellTypeHeight:
            pType = YSPickerViewTypeDouble;
            dataArr = [YSPickerViewData shareData].heightRange;
            sameData = YES;
            break;
        case FilterCellTypeEdu:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].degree;
            break;
        case FilterCellTypeJob:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].perfession;
            break;
        case FilterCellTypeIncome:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].salary;
            break;
        case FilterCellTypeConstellation:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].constellation;
            break;
        case FilterCellTypeMarryDate:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].wantMarrayTime;
            break;
        case FilterCellTypeMarryStatus:
            pType = YSPickerViewTypeSingle;
            dataArr = [YSPickerViewData shareData].marryStatus;
            break;
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
        
        
        switch (type) {
            case FilterCellTypeLocation: {
                self.viewModel.cityID = m2.mid;
                str = [NSString stringWithFormat:@"%@ %@ %@", m0.name, m1.name, m2.name];
                break;
            }
            case FilterCellTypeAge: {
                self.viewModel.agestart = m0.mid;
                self.viewModel.ageend = m1.mid;
                str = [NSString stringWithFormat:@"%@ - %@", m0.name, m1.name];
                break;
            }
            case FilterCellTypeHeight: {
                self.viewModel.heightstart = m0.mid;
                self.viewModel.heightend = m1.mid;
                str = [NSString stringWithFormat:@"%@ - %@", m0.name, m1.name];
                break;
            }
            case FilterCellTypeEdu: {
                self.viewModel.degree = m0.mid;
                str = m0.name;
                break;
            }
            case FilterCellTypeJob: {
                self.viewModel.degree = m0.mid;
                str = m0.name;
                break;
            }
            case FilterCellTypeIncome: {
                self.viewModel.salary = m0.mid;
                str = m0.name;
                break;
            }
            case FilterCellTypeConstellation:
                self.viewModel.constellation = m0.mid;
                str = m0.name;
                break;
            case FilterCellTypeMarryDate:
                self.viewModel.wantmarry = m0.mid;
                str = m0.name;
                break;
            case FilterCellTypeMarryStatus: {
                self.viewModel.marry = m0.mid;
                str = m0.name;
                break;
            }
            default:
                break;
        }
        
        model.info = str;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYMatchMakerCellModel *sectionModel = self.viewModel.dataArray[indexPath.section];
    HYMatchMakerCellModel *model = sectionModel.arr[indexPath.row];
    FilterCellType type = model.type;
    [self showPickerViewWithModel:model type:type];
    
}

- (YSPickerViewModel *)modelIn:(NSArray *)arr atIndex:(NSInteger)idx {
    if (arr.count == 0 || (arr.count && arr.count <= idx)) return nil;
    return arr[idx];
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    [super setupSubviews];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [self footerView];
    [self.tableView registerClass:[HYMatchMakerListCell class] forCellReuseIdentifier:@"reuseID"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(resetAllSelect)];
}

- (void)setupSubviewsLayout {
    [super setupSubviewsLayout];
}

- (UIView *)footerView {
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    NSString *title = @"确定";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    @weakify(self);
    [[btn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self submitAction];
    }];
    
    [container addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(container);
        make.size.mas_equalTo(CGSizeMake(315, 45));
    }];
    
    return container;
}
@end
