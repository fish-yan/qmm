//
//  HYUserInfoModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUserInfoModel.h"

@implementation HYUserInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"uid": @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"photos": @"PhotoModel"};
}

@end
