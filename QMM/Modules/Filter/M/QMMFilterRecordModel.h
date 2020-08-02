//
//  QMMFilterRecordModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMFilterRecordModel : YSBaseModel

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

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *ageName;
@property (nonatomic, copy) NSString *heightName;
@property (nonatomic, copy) NSString *degreeName;
@property (nonatomic, copy) NSString *salaryName;
@property (nonatomic, copy) NSString *constellationName;
@property (nonatomic, copy) NSString *wantmarryName;
@property (nonatomic, copy) NSString *marryStatusName;


@end

NS_ASSUME_NONNULL_END
