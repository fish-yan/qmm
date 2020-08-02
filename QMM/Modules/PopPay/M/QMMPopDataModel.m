//
//  QMMPopDataModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMPopDataModel.h"

@implementation QMMPopDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID": @"id" };
}

@end
