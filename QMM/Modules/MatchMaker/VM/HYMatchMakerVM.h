//
//  HYMatchMakerVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYMatchMakerVM : YSBaseViewModel

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSDictionary *callBackParams;

@property (nonatomic, strong) NSNumber *cityID;
@property (nonatomic, strong) NSNumber *agestart;
@property (nonatomic, strong) NSNumber *ageend;

@property (nonatomic, strong) NSNumber *heightstart;
@property (nonatomic, strong) NSNumber *heightend;
@property (nonatomic, strong) NSNumber *degree;
@property (nonatomic, strong) NSNumber *salary;
@property (nonatomic, strong) NSNumber *constellation;
@property (nonatomic, strong) NSNumber *wantmarry;
@property (nonatomic, strong) NSNumber *marry;

@end

NS_ASSUME_NONNULL_END
