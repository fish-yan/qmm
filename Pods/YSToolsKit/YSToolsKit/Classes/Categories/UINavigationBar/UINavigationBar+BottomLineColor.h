//
//  UINavigationBar+BottomLineColor.h
//  
//
//  Created by Joseph Koh on 16/5/11.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BottomLineColor)

@property (nonatomic, strong) UIView *bottomBorderLine;

- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height;

@end
