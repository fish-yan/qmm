//
//  NSString+Mobile.h
//
//  Created by Joseph Koh on 2017/9/8.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Mobile)

/// 格式化手机含空格显示样式
- (NSString *)phoneNumberFormatString;
/// 格式化手机含空**显示样式
- (NSString *)hiddenMiddleStringOfPhoneNumber;

@end
