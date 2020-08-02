//
//  HYFilterCellModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYFilterCellModel.h"

@implementation HYFilterCellModel

+ (instancetype)modelWithType:(FilterCellType)type
                         name:(NSString *)name
                         icon:(NSString *)icon
                         info:(NSString *)info
                     isLocked:(BOOL)isLocked {
    HYFilterCellModel *model = [HYFilterCellModel new];
    model.name = name;
    model.icon = icon;
    model.info = info;
    model.isLocked = isLocked;
    model.type = type;
    return model;
}

@end
