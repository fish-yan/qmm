//
//  HYPrivateModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYPrivateModel.h"

@implementation HYPrivateModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"messageID": @"id",
        @"userId": @"fromuid",
        @"picUrl": @"fromavatar",
        @"nickname": @"fromname",
        @"reciveTime": @"lastdate2",
        @"lastContent": @"lastmsg",
        @"isRead": @"newcount",
        @"salary": @"msalary"
    };
}

@end
