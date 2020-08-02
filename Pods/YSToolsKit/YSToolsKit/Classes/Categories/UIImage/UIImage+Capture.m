//
//  UIImage+Capture.m
//  YSKit
//
//  Created by Joseph Koh on 16/4/24.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import "UIImage+Capture.h"

@implementation UIImage (Capture)

+ (UIImage *)imageByCaptureView:(UIView *)aView {
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, aView.opaque, [UIScreen mainScreen].scale);
    // IOS7及其后续版本
    if ([aView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [aView drawViewHierarchyInRect:aView.bounds afterScreenUpdates:NO];
    }
    else { // IOS7之前的版本
        [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}

@end
