//
//  UIImage+Color.h
//  YSKit
//
//  Created by Joseph Koh on 16/4/24.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

/**
 *  @brief  根据颜色生成纯色图片
 *
 *  @param color 颜色
 *
 *  @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  @brief  取图片某一点的颜色
 *
 *  @param point 某一点
 *
 *  @return 颜色
 */
- (UIColor *)colorAtPoint:(CGPoint )point;

//more accurate method ,colorAtPixel 1x1 pixel
/**
 *  @brief  取某一像素的颜色
 *
 *  @param point 一像素
 *
 *  @return 颜色
 */
- (UIColor *)colorAtPixel:(CGPoint)point;

/**
 *  @brief  返回该图片是否有透明度通道
 *
 *  @return 是否有透明度通道
 */
- (BOOL)hasAlphaChannel;

/**
 *  @brief  获得灰度图
 *
 *  @param sourceImage 图片
 *
 *  @return 获得灰度图片
 */
+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage;



/**
 生成渐变颜色的图片

 @param colors 渐变图片颜色组
 @param locations 渐变色分割点, 取值范围0~1
 @param size 生成的图片尺寸
 @return 渐变色图片
 */
+ (UIImage *)imageOfGradientColorWithColors:(NSArray<UIColor *> *)colors
                                      locations:(NSArray<NSNumber *> *)locations
                                   andImageSize:(CGSize)size;

@end
