//
//  UIColor+Hex.h
//  Jikeyi
//
//  Created by zhengpeng on 14-4-8.
//  Copyright (c) 2014年 zhengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString*)hexString;
+ (UIColor *)colorWithHexString:(NSString*)hexString alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(uint)hex;
+ (UIColor *)colorWithHex:(uint)hex alpha:(CGFloat)alpha;

@end
