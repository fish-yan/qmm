//
//  QMMIconInputView.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/27.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMMIconInputView : UIView
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) NSString *normalIcon;
@property (nonatomic, copy) NSString *focusIcon;
@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL focus;

+ (instancetype)viewWithNormalIcon:(NSString *)nrmalIcon
                       focusIcon:(NSString *)focusIcon
                       placeHolder:(NSString *)placeHolder;

@end

NS_ASSUME_NONNULL_END
