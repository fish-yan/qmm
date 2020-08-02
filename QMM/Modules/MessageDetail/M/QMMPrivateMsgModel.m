//
//  QMMPrivateMsgModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMPrivateMsgModel.h"

@implementation QMMPrivateMsgModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"messageId": @"id",
        @"messageContent": @"content",
        @"time": @"senddate2",
        @"useravatar": @"avatar",
    };
}

@end
