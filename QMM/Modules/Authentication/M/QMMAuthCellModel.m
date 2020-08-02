//
//  QMMAuthCellModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMAuthCellModel.h"

@implementation QMMAuthCellModel

+ (instancetype)modelWithCellType:(AuthCellType)type
                             icon:(NSString *)icon
                            title:(NSString *)title
                             info:(NSString *)info {
    QMMAuthCellModel *m = [QMMAuthCellModel new];
    m.cellType = type;
    m.icon = icon;
    m.title = title;
    m.info = info;
    return m;
}

@end
