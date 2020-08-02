//
//  HYContactTitleModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYContactTitleModel.h"

@implementation HYContactTitleModel

+ (instancetype)modelWithTitle:(NSString *)title hasUnread:(BOOL)hasUnread {
    HYContactTitleModel *m = [HYContactTitleModel new];
    m.title                = title;
    m.hasUnread            = hasUnread;

    return m;
}

@end
