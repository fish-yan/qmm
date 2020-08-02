//
//  HYAddressSubModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYAddressSubModel.h"

@implementation HYAddressSubModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"userID": @"uid",
        @"userAvatar": @"avatar",
        @"userNickName": @"name",
        @"userAge": @"age",
        @"city": @"workcity",
        @"isheart": @"beckoningstatus",
        @"mid": @"id"
    };
}

@end
