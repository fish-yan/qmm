//
//  HYUserBasicInfoCellModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUserBasicInfoCellModel.h"

@implementation HYUserBasicInfoCellModel

+ (instancetype)modelWithType:(BasicInfoCellType)type
                         name:(NSString *)name
                         icon:(NSString *)icon
                         info:(NSString *)info {
    HYUserBasicInfoCellModel *model = [HYUserBasicInfoCellModel new];
    model.name = name;
    model.icon = icon;
    model.info = info;
    model.type = type;
    return model;
}


@end
