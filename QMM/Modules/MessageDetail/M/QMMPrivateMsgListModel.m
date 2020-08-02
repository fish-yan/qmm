//
//  QMMPrivateMsgListModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMPrivateMsgListModel.h"

@implementation QMMPrivateMsgListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"array": @"QMMPrivateMsgModel" };
}

@end
