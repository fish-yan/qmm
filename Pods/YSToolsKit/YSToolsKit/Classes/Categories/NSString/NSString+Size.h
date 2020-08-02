//
//  NSString+Size.h
//  YSKit
//
//  Created by Joseph Koh on 16/4/21.
//  Copyright © 2016年 Joseph. All rights reserved.
//

/*!
 @brief 计算文字尺寸
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Size)

/*!
 @brief 计算字符串的高度
 @param fontSize 文字大小
 @return 字符串的高度
 */
- (CGFloat)heightWithFontSize:(CGFloat)fontSize;

/*!
 @brief 计算字符串的宽度
 @param fontSize 文字大小
 @return 字符串的宽度
 */
- (CGFloat)widthWithFontSize:(CGFloat)fontSize;

/*!
 @brief 计算字符串的尺寸
 @param fontSize 文字大小
 @return 字符串的尺寸
 */
- (CGSize)sizeWithFontSize:(CGFloat)fontSize;


/**
 *  返回label的size
 *
 *  @param input 内容
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return size
 */
+(CGSize)getStringSize:(NSString*)input font:(UIFont*)font width:(CGFloat)width;
/**
 根据指定的字体，和宽度计算字符串的高度
 @param input 字符串
 @param font  使用的字体
 @param width 宽度
 */
+(CGFloat)getStringHight:(NSString*)input font:(UIFont*)font width:(CGFloat)width;

/**
 根据指定的字体，和高度计算字符串的宽度
 @param input 字符串
 @param font  使用的字体
 @param height 高度
 */
+(CGFloat)getStringWidth:(NSString*)input font:(UIFont*)font height:(CGFloat)height;


@end
