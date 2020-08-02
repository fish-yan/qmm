//
//  UIView+AddLine.m
//
//  Created by Joseph Koh on 2017/5/19.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "UIView+AddLine.h"

@implementation UIView (AddLine)

- (UIView *)addLineWithColor:(UIColor *)lineColor width:(CGFloat)width height:(CGFloat)height {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    line.backgroundColor = lineColor ?: [UIColor grayColor];
    
    [self addSubview:line];
    
    return line;
}

+ (UIView *)lineViewWithColor:(UIColor *)lineColor
                        width:(CGFloat)width
                       height:(CGFloat)height
                       inView:(UIView *)inView {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    line.backgroundColor = lineColor ?: [UIColor grayColor];
    
    if (inView && [inView isKindOfClass:[UIView class]]) {
        [inView addSubview:line];
    }
    
    return line;
}

/**
 添加下划线
 
 @param lineColor 线条颜色
 @param height 高度
 */
- (void)addUnderLineWithColor:(UIColor *)lineColor height:(CGFloat)height {
    UIView *line = [UIView new];
    line.backgroundColor = lineColor ?: [UIColor grayColor];
    
    [self addSubview:line];
    
    [line setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:height]];

}

@end
