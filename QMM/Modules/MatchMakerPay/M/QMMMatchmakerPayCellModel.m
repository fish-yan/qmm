//
//  QMMMatchmakerPayCellModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMMatchmakerPayCellModel.h"

@implementation QMMMatchmakerPayCellModel

+ (instancetype)modelWithType:(HYMatchMakerPayCellType)type date:(id)date {
    QMMMatchmakerPayCellModel *m = [QMMMatchmakerPayCellModel new];
    m.type = type;
    m.date = date;
    return m;
}

@end
