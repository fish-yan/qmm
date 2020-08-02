//
//  UIColor+Config.h
//  youbaner
//
//  Created by luzhongchang on 17/7/29.
//  Copyright © 2017年 luzhongchang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface UIColor (Config)
/// 文字颜色
+(UIColor*)tc0Color;
+(UIColor*)tc3Color;
+(UIColor *)tc2Color;
+(UIColor *)tc1Color;
+(UIColor*)tc7Color;
+(UIColor*)tc8Color;
+(UIColor*)tc5Color;
+(UIColor *)tc4Color;


//背景颜色
+(UIColor*)bg0Color;
+(UIColor*)bg2Color;
+(UIColor *)bg3Color;
+(UIColor *)bg4Color;

+(UIColor*)bg1Color;

//按钮颜色
+(UIColor*)bt0Color;

+(UIColor*)bt1Color;


+(UIColor*)line0Color;

@end
