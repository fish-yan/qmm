//
//  NSString+Encode.h
//
//  Created by Joseph Koh on 2017/6/28.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>

/// url字符编码和解码工具分类
@interface NSString (Encode)

/**
 url字符编码
 
 @return 编码后的字符串
 */
- (NSString *)urlEncode;

/**
 url字符解码
 
 @return 解码后的字符串
 */
- (NSString *)urlDecode;

@end
