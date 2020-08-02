//
//  NSString+CheckEmpty.m
//  YSKit
//
//  Created by Joseph Koh on 16/4/22.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import "NSString+CheckEmpty.h"

@implementation NSString (CheckEmpty)

- (BOOL)isEmpty {
    NSString *str = self;
    if (str == nil
        || [str isEqual:[NSNull null]]
        || ![str isKindOfClass:[NSString class]]
        || ![[str stringByTrimmingWhitespace] length]) {
        return YES;
    }
//    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return NO;
}

- (NSString *)stringByTrimmingWhitespace {
    NSString *replaceStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return  replaceStr;
}

- (NSString *)delMiddleSapce {
    return  [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
