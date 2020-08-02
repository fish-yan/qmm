//
//  UIColor+Random.m
//  YSKit
//
//  Created by Joseph Koh on 16/4/25.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0
                           green:arc4random_uniform(256)/255.0
                            blue:arc4random_uniform(256)/255.0
                           alpha:1.0];
}

@end
