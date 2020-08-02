//
//  HYPopDataModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYPopDataModel.h"

@implementation HYPopDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID": @"id" };
}

@end
