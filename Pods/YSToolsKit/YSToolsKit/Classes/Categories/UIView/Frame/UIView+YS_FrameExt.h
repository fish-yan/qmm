//
//  UIView+FrameExt.h
//
//  Created by Joseph on 14/5/26.
//  Copyright (c) 2014年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YS_FrameExt)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat boundsW;
@property (nonatomic, assign) CGFloat boundsH;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@end
