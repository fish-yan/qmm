//
//  HYMatchMakerVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYMatchMakerVM.h"
#import "QMMFilterCellModel.h"

@implementation HYMatchMakerVM

- (instancetype)init {
    if (self = [super init]) {
        [self combineDataArray];
    }
    return self;
}

- (void)combineDataArray {
    self.dataArray = @[[self matchMakerDataModel]];
}

- (QMMFilterCellModel *)matchMakerDataModel {
    NSArray *arr =
    @[
      [QMMFilterCellModel modelWithType:FilterCellTypeHeight name:@"身高范围" icon:@"filter_man" info:@"不限" isLocked:NO],
      [QMMFilterCellModel modelWithType:FilterCellTypeEdu name:@"最高学历" icon:@"filter_book" info:@"不限" isLocked:NO],
      [QMMFilterCellModel modelWithType:FilterCellTypeIncome name:@"月收入" icon:@"filter_wallet" info:@"不限" isLocked:NO],
      [QMMFilterCellModel modelWithType:FilterCellTypeConstellation name:@"星座" icon:@"filter_constella" info:@"不限" isLocked:NO],
      [QMMFilterCellModel modelWithType:FilterCellTypeMarryDate name:@"期望结婚时间" icon:@"filter_heart" info:@"不限" isLocked:NO],
      [QMMFilterCellModel modelWithType:FilterCellTypeMarryStatus name:@"目前婚姻状况" icon:@"filter_now" info:@"不限" isLocked:NO]
      ];
    
    QMMFilterCellModel *m = [QMMFilterCellModel new];
    m.name = @"红娘推荐";
    m.arr = arr;
    m.isLocked = NO;
    m.info = @"去开通";
    
    return m;
}

- (NSDictionary *)callBackParams {
    return @{
             @"city": self.cityID ?: @"",
             @"agestart": self.agestart ?: @"",
             @"ageend": self.ageend ?: @"",
             @"heightstart": self.heightstart ?: @"",
             @"heightend": self.heightend ?: @"",
             @"degree": self.degree ?: @"",
             @"salary": self.salary ?: @"",
             @"constellation": self.constellation ?: @"",
             @"wantmarry": self.wantmarry ?: @"",
             @"marry": self.marry ?: @"",
             @"title": @"红娘推荐"
             };
}

@end
