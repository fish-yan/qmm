//
//  HYAddressTitleModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYAddressTitleModel.h"

@implementation HYAddressTitleModel

+ (instancetype)modelWithTitle:(NSString *)title hasUnread:(BOOL)hasUnread {
    HYAddressTitleModel *m = [HYAddressTitleModel new];
    m.title                = title;
    m.hasUnread            = hasUnread;

    return m;
}

@end
