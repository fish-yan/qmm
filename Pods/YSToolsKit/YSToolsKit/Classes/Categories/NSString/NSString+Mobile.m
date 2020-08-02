//
//  NSString+Mobile.m
//
//  Created by Joseph on 2017/9/8.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "NSString+Mobile.h"

@implementation NSString (Mobile)

/// 格式化手机显示样式
- (NSString *)phoneNumberFormatString {
    NSMutableString * str = [NSMutableString stringWithString:self];
    if(str.length >3){
        [str insertString:@" " atIndex:3];
    }
    if (str.length > 8) {
        [str insertString:@" " atIndex:8];
    }
    return [NSString stringWithString:str];
}

-(NSString *)hiddenMiddleStringOfPhoneNumber {
    if (self.length < 11) return self;
    
    NSMutableString *str = [NSMutableString stringWithString:self];
    [str replaceCharactersInRange:NSMakeRange(3, self.length - 7) withString:@"****"];
    
    return str;
}
@end
