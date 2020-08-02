//
//  AlertViewController.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/30.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    HYALERTYPETONE =1,
    HYALERTTYPETWO =2,
} HYAlertType;

@interface AlertAnimator :NSObject<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

@end


typedef void(^CancelBlock)(void);
typedef void(^SureBlock)(void);

@interface AlertViewController : UIViewController


@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) HYAlertType type;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, copy) NSString *leftButtonTitle;
@property (nonatomic, strong) UIColor *leftTitleColor;
@property (nonatomic, strong) UIColor *leftBackgroundColor;

@property (nonatomic, copy) NSString *rightButtonTitle;
@property (nonatomic, strong) UIColor *rightTitleColor;
@property (nonatomic, strong) UIColor *rightBackgroundColor;

@property (nonatomic, assign) int fontsize;

@property(nonatomic,copy) CancelBlock cancelBlock;
@property(nonatomic,copy) SureBlock   sureBlock;


@property (nonatomic, strong) UIView *alertView;

+ (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font;

@end
