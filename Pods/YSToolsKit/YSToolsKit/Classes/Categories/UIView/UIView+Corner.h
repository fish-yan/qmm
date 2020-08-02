//
//  UIView+Corner.h
//
//  Created by Joseph Koh on 2016/11/30.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Corner)

-(void)setCornerWithRadius:(CGFloat)radius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor
             clipsToBounds:(BOOL)clipsToBounds;

@end
