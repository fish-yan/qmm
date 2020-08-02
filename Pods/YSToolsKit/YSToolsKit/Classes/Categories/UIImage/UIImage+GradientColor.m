//
//  UIImage+GradientColor.m
//  YSBaseComponent
//
//  Created by Joseph Koh on 2018/5/22.
//

#import "UIImage+GradientColor.h"

@implementation UIImage (GradientColor)

+ (UIImage *)gradientImageOfSize:(CGSize)size
                      withColors:(NSArray<UIColor *> *)colors
                      startPoint:(CGPoint)startPoint
                       locations:(NSArray<NSNumber *> *)locations
                        endPoint:(CGPoint)endPoint {
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    NSMutableArray *map = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [map addObject:(id)color.CGColor];
    }

    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    if (locations) layer.locations = locations;
    
    UIGraphicsBeginImageContext(layer.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
