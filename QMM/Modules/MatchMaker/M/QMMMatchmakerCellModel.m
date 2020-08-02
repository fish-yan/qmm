//
//  QMMMatchmakerCellModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMMatchmakerCellModel.h"

@implementation QMMMatchmakerCellModel

+ (instancetype)modelWithType:(FilterCellType)type
                         name:(NSString *)name
                         icon:(NSString *)icon
                         info:(NSString *)info
                     isLocked:(BOOL)isLocked {
    QMMMatchmakerCellModel *model = [QMMMatchmakerCellModel new];
    model.name = name;
    model.icon = icon;
    model.info = info;
    model.isLocked = isLocked;
    model.type = type;
    return model;
}

@end
