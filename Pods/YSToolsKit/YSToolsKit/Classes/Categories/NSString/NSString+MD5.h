//
//  NSString+MD5.h
//  YSToolsKit
//
//  Created by Joseph Koh on 2018/7/5.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

+ (NSString *)md5StringOfString:(NSString *)string;
- (NSString *)md5String;

@end
