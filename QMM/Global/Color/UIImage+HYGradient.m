//
//  UIImage+HYGradient.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/22.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "UIImage+HYGradient.h"

@implementation UIImage (HYGradient)

+ (UIImage *)gradientImageOfSize:(CGSize)size {
    CAGradientLayer *layer = [CAGradientLayer layer];
    UIColor *color0 = [UIColor colorWithHexString:@"#FF599E"];
    UIColor *color1 = [UIColor colorWithHexString:@"#FFAB68"];
    layer.colors = @[(id)color0.CGColor,
                     (id)color1.CGColor];
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1, 0.5);
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    //layer.locations = @[@(0.0f), @(1)];
    
    UIGraphicsBeginImageContext(layer.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}

@end
