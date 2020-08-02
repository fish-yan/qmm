//
//  UINavigationBar+BottomLineColor.m
//  
//
//  Created by Joseph Koh on 16/5/11.
//
//

#import "UINavigationBar+BottomLineColor.h"
#import <objC/runtime.h>
static const void *kBottomBorderLine = &kBottomBorderLine;

@implementation UINavigationBar (BottomLineColor)

@dynamic bottomBorderLine;

- (UIView *)bottomBorderLine {
    return objc_getAssociatedObject(self, kBottomBorderLine);
}

- (void)setBottomBorderLine:(UIView *)bottomBorderLine {
    return objc_setAssociatedObject(self, kBottomBorderLine, bottomBorderLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height {
    if (!self.bottomBorderLine) {
        CGRect bottomBorderRect = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), height);
        self.bottomBorderLine = [[UIView alloc] initWithFrame:bottomBorderRect];
        [self.bottomBorderLine setBackgroundColor:color];
        [self addSubview:self.bottomBorderLine];
    }

}

@end
