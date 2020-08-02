//
//  QMMFilterCellModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FilterCellType) {
    FilterCellTypeLocation,
    FilterCellTypeAge,
    FilterCellTypeHeight,
    FilterCellTypeEdu,
    FilterCellTypeJob,
    FilterCellTypeIncome,
    FilterCellTypeConstellation,
    FilterCellTypeMarryDate,
    FilterCellTypeMarryStatus,
};

@interface QMMFilterCellModel : YSBaseModel

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, assign) FilterCellType type;

+ (instancetype)modelWithType:(FilterCellType)type
                         name:(NSString *)name
                         icon:(NSString *)icon
                         info:(NSString *)info
                     isLocked:(BOOL)isLocked;

@end

NS_ASSUME_NONNULL_END
