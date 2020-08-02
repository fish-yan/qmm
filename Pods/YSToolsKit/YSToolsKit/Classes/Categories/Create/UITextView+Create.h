//
//  UITextView+Create.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Create)

+ (instancetype)textViewWithText:(NSString *)text
                       textColor:(UIColor *)textColor
                        font:(UIFont *)font
                        delegate:(id<UITextViewDelegate>)delegate
                           inView:(__kindof UIView *)inView;

+ (instancetype)textViewWithText:(NSString *)text
                       textColor:(UIColor *)textColor
                        font:(UIFont *)font
                     placeHolder:(NSString *)placeHolder
                    placeHolderColor:(UIColor *)placeHolderColor
                        delegate:(id<UITextViewDelegate>)delegate
                          inView:(__kindof UIView *)inView;

@end
