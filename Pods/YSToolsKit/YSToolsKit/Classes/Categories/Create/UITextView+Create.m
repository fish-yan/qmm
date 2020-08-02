//
//  UITextView+Create.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "UITextView+Create.h"
#import "UITextView+PlaceHolder.h"

@implementation UITextView (Create)

+ (instancetype)textViewWithText:(NSString *)text
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font
                        delegate:(id<UITextViewDelegate>)delegate
                          inView:(__kindof UIView *)inView {
    return [self textViewWithText:text
                        textColor:textColor
                             font:font
                      placeHolder:nil
                 placeHolderColor:nil
                         delegate:delegate
                           inView:inView];
}
+ (instancetype)textViewWithText:(NSString *)text
                       textColor:(UIColor *)textColor
                        font:(UIFont *)font
                     placeHolder:(NSString *)placeHolder
                placeHolderColor:(UIColor *)placeHolderColor
                        delegate:(id<UITextViewDelegate>)delegate
                          inView:(__kindof UIView *)inView {
    UITextView *tv = [[UITextView alloc] init];
    tv.text = text;
    if (font) tv.font = font;
  
    if (textColor) tv.textColor = textColor;
    if (placeHolder) tv.placeholder = placeHolder;
    if (placeHolderColor) tv.placeholderColor = placeHolderColor;
    if (delegate && [delegate conformsToProtocol:@protocol(UITextViewDelegate)]) {
        tv.delegate = delegate;
    }
    if (inView && [inView isKindOfClass:[UIView class]]) {
        [inView addSubview:tv];
    }
    
    return tv;
}

@end
