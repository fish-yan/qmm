//
//  QMMContactModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMContactModel.h"

@implementation QMMContactModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"heartType": @"beckoningstatus",
        @"mid": @"id"
    };
}

@end
