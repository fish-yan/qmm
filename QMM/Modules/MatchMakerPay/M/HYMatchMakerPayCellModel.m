//
//  HYMatchMakerPayCellModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYMatchMakerPayCellModel.h"

@implementation HYMatchMakerPayCellModel

+ (instancetype)modelWithType:(HYMatchMakerPayCellType)type date:(id)date {
    HYMatchMakerPayCellModel *m = [HYMatchMakerPayCellModel new];
    m.type = type;
    m.date = date;
    return m;
}

@end
