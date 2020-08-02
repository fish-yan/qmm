//
//  UIButton+ImagePosition.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/11.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "UIButton+ImagePosition.h"

@implementation UIButton (ImagePosition)

- (void)setImagePositionStyle:(ImagePositionStyle)postionStyle imageTitleMargin:(CGFloat)margin {
    [self setTitle:self.currentTitle forState:UIControlStateNormal];
    [self setImage:self.currentImage forState:UIControlStateNormal];
    
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat labelWidth = [self textSize].width;
    CGFloat labelHeight = [self textSize].height;
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;
    CGFloat imageOffsetY = imageHeight / 2 + margin / 2;
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;
    CGFloat labelOffsetY = labelHeight / 2 + margin / 2;
    
    CGFloat tempWidth = MAX(labelWidth, imageWidth);
    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + margin - tempHeight;
    
    switch (postionStyle) {
        case ImagePositionStyleLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -margin/2, 0, margin/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, margin/2, 0, -margin/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, margin/2, 0, margin/2);
            break;
            
        case ImagePositionStyleRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + margin/2, 0, -(labelWidth + margin/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + margin/2), 0, imageWidth + margin/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, margin/2, 0, margin/2);
            break;
            
        case ImagePositionStyleTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break;
            
        case ImagePositionStyleBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break;
            
        default:
            break;
    }
    
}

- (CGSize)textSize {
    CGSize size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName: self.titleLabel.font}
                                                     context:nil].size;
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

@end
