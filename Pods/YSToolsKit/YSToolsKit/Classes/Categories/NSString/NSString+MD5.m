//
//  NSString+MD5.m
//  YSToolsKit
//
//  Created by Joseph Koh on 2018/7/5.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (MD5)

+ (NSString *)md5StringOfString:(NSString *)string {
    return [string md5String];
}
- (NSString *)md5String {
    return [self generateMD5:self];
}

- (NSString *)generateMD5:(NSString *)string{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
