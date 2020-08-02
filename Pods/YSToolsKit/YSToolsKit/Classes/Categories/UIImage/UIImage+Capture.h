//
//  UIImage+Capture.h
//  YSKit
//
//  Created by Joseph Koh on 16/4/24.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Capture)

/*!
 @brief 对一个view截屏,获取快照
 @param aView 要截屏的view
 @return 截屏图片
 */
+ (UIImage *)imageByCaptureView:(UIView *)aView;

@end
