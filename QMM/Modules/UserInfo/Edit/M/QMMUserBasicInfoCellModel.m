//
//  QMMUserBasicInfoCellModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMUserBasicInfoCellModel.h"

@implementation QMMUserBasicInfoCellModel

+ (instancetype)modelWithType:(BasicInfoCellType)type
                         name:(NSString *)name
                         icon:(NSString *)icon
                         info:(NSString *)info {
    QMMUserBasicInfoCellModel *model = [QMMUserBasicInfoCellModel new];
    model.name = name;
    model.icon = icon;
    model.info = info;
    model.type = type;
    return model;
}


@end
