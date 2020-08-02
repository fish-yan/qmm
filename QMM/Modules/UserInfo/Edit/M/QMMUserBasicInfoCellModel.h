//
//  QMMUserBasicInfoCellModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

typedef NS_ENUM(NSInteger, BasicInfoCellType) {
    BasicInfoCellTypeName,
    BasicInfoCellTypeWorkPlace,
    BasicInfoCellTypeHome,
    BasicInfoCellTypeBirthday,
    BasicInfoCellTypeHeight,
    BasicInfoCellTypeEdu,
    BasicInfoCellTypeJob,
    BasicInfoCellTypeIncome,
    BasicInfoCellTypeConstellation,
    BasicInfoCellTypeMarryDate,
    BasicInfoCellTypeMarryStatus,
    BasicInfoCellTypeFriendWorkPlace,
    BasicInfoCellTypeFriendHome,
    BasicInfoCellTypeFriendAge,
    BasicInfoCellTypeFriendHeight,
    BasicInfoCellTypeFriendEdu,
    BasicInfoCellTypeFriendIncome,
};

@interface QMMUserBasicInfoCellModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, assign) BasicInfoCellType type;

+ (instancetype)modelWithType:(BasicInfoCellType)type
                         name:(NSString *)name
                         icon:(NSString *)icon
                         info:(NSString *)info;

@end
