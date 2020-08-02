//
//  NSString+Encode.m
//
//  Created by Joseph Koh on 2017/6/28.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (Encode)

- (NSString *)urlEncode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (NSString *)urlDecode {
    NSString *decodeStr = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    decodeStr = [decodeStr stringByRemovingPercentEncoding];
    return decodeStr;
}

@end
