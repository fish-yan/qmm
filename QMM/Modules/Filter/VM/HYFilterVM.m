//
//  HYFilterVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYFilterVM.h"
#import "QMMFilterCellModel.h"

@implementation HYFilterVM


- (instancetype)init {
    if (self = [super init]) {
        [self combineDataArray];
        
        @weakify(self);
        [RACObserve(self, recordModel) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self combineDataArray];
        }];
    }
    return self;
}

- (BOOL)hasBuyMatchMaker {
    return [[QMMUserContext shareContext].userModel.redniangstatus  boolValue];
}

- (void)combineDataArray {
    self.dataArray = @[[self commonDataModel],
                       [self matchMakerDataModel]];
}

- (QMMFilterCellModel *)commonDataModel {
    QMMFilterCellModel *m = [QMMFilterCellModel new];
    m.name = @"一般筛选";
    m.arr = @[
              [QMMFilterCellModel modelWithType:FilterCellTypeLocation
                                          name:@"工作所在地"
                                          icon:@"ic_location"
                                          info:self.recordModel.cityName ?: @"不限"
                                      isLocked:NO],
              [QMMFilterCellModel modelWithType:FilterCellTypeAge
                                          name:@"年龄范围"
                                          icon:@"ic_date"
                                          info:self.recordModel.ageName ?:@"不限"
                                      isLocked:NO]
              ];
    m.isLocked = NO;
    
    return m;
}

- (QMMFilterCellModel *)matchMakerDataModel {
    BOOL isNeedLock = !self.hasBuyMatchMaker;
    NSArray *arr = @[
                     [QMMFilterCellModel modelWithType:FilterCellTypeHeight name:@"身高范围"
                                                 icon:@"ic_man"
                                                 info:self.recordModel.heightName ?:@"不限"
                                             isLocked:isNeedLock],
                     [QMMFilterCellModel modelWithType:FilterCellTypeEdu
                                                 name:@"最高学历"
                                                 icon:@"ic_book"
                                                 info:self.recordModel.degreeName ?:@"不限"
                                             isLocked:isNeedLock],
                     [QMMFilterCellModel modelWithType:FilterCellTypeIncome
                                                 name:@"月收入"
                                                 icon:@"ic_wallet"
                                                 info:self.recordModel.salaryName ?:@"不限"
                                             isLocked:isNeedLock],
                     [QMMFilterCellModel modelWithType:FilterCellTypeConstellation
                                                 name:@"星座"
                                                 icon:@"ic_constella"
                                                 info:self.recordModel.constellationName ?:@"不限"
                                             isLocked:isNeedLock],
                     [QMMFilterCellModel modelWithType:FilterCellTypeMarryDate
                                                 name:@"期望结婚时间"
                                                 icon:@"ic_heart"
                                                 info:self.recordModel.wantmarryName ?:@"不限"
                                             isLocked:isNeedLock],
                     [QMMFilterCellModel modelWithType:FilterCellTypeMarryStatus
                                                 name:@"目前婚姻状况"
                                                 icon:@"ic_now"
                                                 info:self.recordModel.marryStatusName ?:@"不限"
                                             isLocked:isNeedLock]
                     ];
    
    
    QMMFilterCellModel *m = [QMMFilterCellModel new];
    m.name = @"红娘推荐";
    m.arr = arr;
    m.isLocked = !self.hasBuyMatchMaker;
    m.info = @"去开通";
    
    return m;
}

- (QMMFilterRecordModel *)recordModel {
    if (!_recordModel) {
        _recordModel = [QMMFilterRecordModel new];
    }
    return _recordModel;
}


@end
