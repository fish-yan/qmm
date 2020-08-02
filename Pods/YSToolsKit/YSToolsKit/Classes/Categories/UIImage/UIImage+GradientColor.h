//
//  UIImage+GradientColor.h
//  YSBaseComponent
//
//  Created by Joseph Koh on 2018/5/22.
//

#import <UIKit/UIKit.h>

@interface UIImage (GradientColor)

+ (UIImage *)gradientImageOfSize:(CGSize)size
                      withColors:(NSArray<UIColor *> *)colors
                      startPoint:(CGPoint)startPoint
                       locations:(NSArray<NSNumber *> *)locations
                        endPoint:(CGPoint)endPoint;

@end
