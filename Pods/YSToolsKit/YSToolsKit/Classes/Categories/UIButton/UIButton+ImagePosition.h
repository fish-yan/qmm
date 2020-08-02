//
//  UIButton+ImagePosition.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/11.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ImagePositionStyle) {
    ImagePositionStyleLeft = 0,              // 图片在左，文字在右，默认
    ImagePositionStyleRight,                 // 图片在右，文字在左
    ImagePositionStyleTop,                   // 图片在上，文字在下
    ImagePositionStyleBottom,                // 图片在下，文字在上
};

@interface UIButton (ImagePosition)

- (void)setImagePositionStyle:(ImagePositionStyle)postionStyle imageTitleMargin:(CGFloat)space;

@end
