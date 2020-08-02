//
//  UIView+Corner.m
//
//  Created by Joseph Koh on 2016/11/30.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

- (void)setCornerWithRadius:(CGFloat)radius
               borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor *)borderColor
              clipsToBounds:(BOOL)clipsToBounds {
    self.layer.cornerRadius = radius;
    if (borderColor) self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.clipsToBounds = clipsToBounds;
}

@end
