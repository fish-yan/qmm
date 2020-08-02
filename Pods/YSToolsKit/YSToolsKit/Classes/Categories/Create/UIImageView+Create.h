//
//  UIImageView+Create.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Create)

+ (instancetype)imageViewWithImageName:(NSString *)imgName
                                inView:(__kindof UIView *)inView;

+ (instancetype)imageViewWithImageName:(NSString *)imgName
                                inView:(__kindof UIView *)inView
                             tapAction:(void(^)(UIImageView *imgView, UIGestureRecognizer *tap))tapAction;
@end
