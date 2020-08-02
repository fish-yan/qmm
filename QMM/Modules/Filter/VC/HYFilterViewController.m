//
//  HYFilterViewController.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYFilterViewController.h"
#import "HYFilterListCell.h"
#import "YSPickerView.h"
#import "YSPickerViewData.h"
#import "HYFilterVM.h"

@interface HYFilterViewController ()

@property (nonatomic, strong) HYFilterVM *viewModel;
@property (nonatomic, strong) YSPickerView *pickerView;

@end

@implementation HYFilterViewController


+ (void)load {
    [self mapName:kModuleFilter withParams:nil];
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

- (void)fetchFilterData {
    [self doPopBack];
}

- (void)resetAllSelect {
    self.viewModel.recordModel = [HYFilterRecordModel new];
    if (self.callBack) {
        self.callBack(nil);
    }
    
    [self.tableView reloadData];
}


- (void)doPopBack {
    if (self.callBack) {
        self.callBack(self.viewModel.recordModel);
    }
    [self popBack];
}


#pragma mark - Bind

- (void)bind {
    [super bind];
}


#pragma mark - Initialize

- (void)initialize {
    [super initialize];
    
    self.navigationItem.title = @"筛选";
    self.style = UITableViewStyleGrouped;
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewModel = [HYFilterVM new];
    self.viewModel.recordModel = self.filterInfo;
}


#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HYFilterCellModel *sectionModel = self.viewModel.dataArray[section];
    return sectionModel.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYFilterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseID" forIndexPath:indexPath];
    
    HYFilterCellModel *sectionModel = self.viewModel.dataArray[indexPath.section];
    cell.cellModel = sectionModel.arr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HYFilterCellModel *sectionModel = self.viewModel.dataArray[section];
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    content.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    
    UILabel *titleL = [UILabel labelWithText:sectionModel.name
                                   textColor:[UIColor colorWithHexString:@"#3A444A"]
                                    font:[UIFont systemFontOfSize:14]
                                      inView:content
                                   tapAction:NULL];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(content);
    }];
    
    if (sectionModel.isLocked) {
        @weakify(self);
        UIButton *openBtn = [UIButton buttonWithTitle:sectionModel.info
                                           titleColor:[UIColor colorWithHexString:@"#FF5D9C"]
                                                 font:[UIFont systemFontOfSize:14]
                                        normalImgName:@"arrowright"
                                 highlightedImageName:nil
                                              bgColor:nil
                                    normalBgImageName:nil
                               highlightedBgImageName:nil
                                               inView:content
                                               action:^(UIButton *btn) {
                                                   @strongify(self);
                                                   [self showPayAlertView];
                                               }];
        [openBtn setImagePositionStyle:ImagePositionStyleRight imageTitleMargin:10];
        
        [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20);
            make.centerY.equalTo(content);
        }];
    }
    
    
    return content;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)showPayAlertView {
    @weakify(self);
    id rst = ^(BOOL isSuccess){
        if (isSuccess) {
            [[QMMUserContext shareContext] fetchLatestUserinfoWithSuccessHandle:^(HYUserCenterModel *infoModel) {
                @strongify(self);
                self.viewModel = [HYFilterVM new];
                [self.tableView reloadData];
            } failureHandle:^(NSError *error) {
                [YSProgressHUD showTips:error.localizedDescription];
            }];
        }
    };
    
    [YSMediator pushToViewController:@"kModuleMatchMakerPay"
                          withParams:@{@"rst": rst}
                            animated:YES
                            callBack:NULL];
}

- (void)showPickerViewWithModel:(HYFilterCellModel *)model type:(FilterCellType)type {
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
                //                self.viewModel.cityID = m2.mid;
                str = [NSString stringWithFormat:@"%@ %@ %@", m0.name, m1.name, m2.name];
                self.viewModel.recordModel.cityID = m2.mid;
                self.viewModel.recordModel.cityName = str;
                break;
            }
            case FilterCellTypeAge: {
                //                self.viewModel.agestart = m0.mid;
                //                self.viewModel.ageend = m1.mid;
                str = [NSString stringWithFormat:@"%@ - %@", m0.name, m1.name];
                self.viewModel.recordModel.agestart = m0.mid;
                self.viewModel.recordModel.ageend = m1.mid;
                self.viewModel.recordModel.ageName = str;
                break;
            }
            case FilterCellTypeHeight: {
                //                self.viewModel.heightstart = m0.mid;
                //                self.viewModel.heightend = m1.mid;
                str = [NSString stringWithFormat:@"%@ - %@", m0.name, m1.name];
                self.viewModel.recordModel.heightstart = m0.mid;
                self.viewModel.recordModel.heightend = m1.mid;
                self.viewModel.recordModel.heightName = str;
                break;
            }
            case FilterCellTypeEdu: {
                //                self.viewModel.degree = m0.mid;
                str = m0.name;
                self.viewModel.recordModel.degree = m0.mid;
                self.viewModel.recordModel.degreeName = str;
                break;
            }
            case FilterCellTypeJob: {
                //                self.viewModel.degree = m0.mid;
                str = m0.name;
                break;
            }
            case FilterCellTypeIncome: {
                //                self.viewModel.salary = m0.mid;
                str = m0.name;
                self.viewModel.recordModel.salary = m0.mid;
                self.viewModel.recordModel.salaryName = str;
                break;
            }
            case FilterCellTypeConstellation:
                //                self.viewModel.constellation = m0.mid;
                str = m0.name;
                self.viewModel.recordModel.constellation = m0.mid;
                self.viewModel.recordModel.constellationName = str;
                break;
            case FilterCellTypeMarryDate:
                //                self.viewModel.wantmarry = m0.mid;
                str = m0.name;
                self.viewModel.recordModel.wantmarry = m0.mid;
                self.viewModel.recordModel.wantmarryName = str;
                break;
            case FilterCellTypeMarryStatus: {
                //                self.viewModel.marry = m0.mid;
                str = m0.name;
                self.viewModel.recordModel.marry = m0.mid;
                self.viewModel.recordModel.marryStatusName = str;
                break;
            }
            default:
                break;
        }
        
        model.info = str;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYFilterCellModel *sectionModel = self.viewModel.dataArray[indexPath.section];
    HYFilterCellModel *model = sectionModel.arr[indexPath.row];
    FilterCellType type = model.type;
    
    switch (type) {
        case FilterCellTypeHeight:
        case FilterCellTypeEdu:
        case FilterCellTypeJob:
        case FilterCellTypeIncome:
        case FilterCellTypeConstellation:
        case FilterCellTypeMarryDate:
        case FilterCellTypeMarryStatus:
            if (!self.viewModel.hasBuyMatchMaker) {
                [self showPayAlertView];
                return;
            }
            break;
        default:
            break;
    }
    
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
    [self.tableView registerClass:[HYFilterListCell class] forCellReuseIdentifier:@"reuseID"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(resetAllSelect)];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 8, 14);
    [btn setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doPopBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
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
        [self fetchFilterData];
    }];
    
    [container addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(container);
        make.size.mas_equalTo(CGSizeMake(315, 45));
    }];
    
    return container;
}

@end
