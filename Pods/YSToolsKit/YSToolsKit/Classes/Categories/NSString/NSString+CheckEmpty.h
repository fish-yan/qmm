//
//  NSString+CheckEmpty.h
//  YSKit
//
//  Created by Joseph Koh on 16/4/22.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CheckEmpty)

/*!
 @brief 检查字符是否是空
 @return YES:空字符, NO:非空
 */
- (BOOL)isEmpty;
/*!
 @brief 删除空格
 */
- (NSString *)stringByTrimmingWhitespace;

/*!
 @brief 删除中间空格
 */
- (NSString *)delMiddleSapce;

@end
