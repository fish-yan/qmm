//
//  QMMGreetUserModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMGreetUserModel.h"

@implementation QMMGreetUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid": @"id"};
}

@end
