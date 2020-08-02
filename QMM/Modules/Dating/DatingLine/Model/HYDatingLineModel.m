//
//  HYDatingLineModel.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/28.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYDatingLineModel.h"

@implementation HYDatingRouteItem

@end

@implementation HYDatingLineModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"routeitems": [HYDatingRouteItem class]
             };
}

@end
