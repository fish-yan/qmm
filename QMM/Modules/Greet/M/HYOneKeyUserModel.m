//
//  HYOneKeyUserModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYOneKeyUserModel.h"

@implementation HYOneKeyUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid": @"id"};
}

@end
