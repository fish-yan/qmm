//
//  UIView+FailureView.h
//  HCDoctor
//
//  Created by Joseph Gao on 2017/6/14.
//  Copyright © 2017年 WondersGroup.com. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, WDFailureViewType) {
    WDFailureViewTypeDefault,          // 默认页面
    WDFailureViewTypeEmpty,            // 展示空页面
    WDFailureViewTypeMessageEmpty,     // 展示暂无聊天消息
    WDFailureViewTypeError,            // 展示错误页面
    WDFailureViewTypeUnreachabel,      // 展示没有网络
    WDFailureViewTypeUnknow            // 未知页面
};

@interface UIView (FailureView)


/**
 根据错误类型显示对应错误页面
 
 @param type 错误类型
 @param clickAction 点击操作
 */
- (void)showFailureViewOfType:(WDFailureViewType)type withClickAction:(void (^)(void))clickAction;

/**
 自定义错误页面
 
 @param image 错误页面图片
 @param tips 错误页面提示
 @param clickAction 点击操作
 */
- (void)showFailureViewWithImage:(UIImage *)image tips:(NSString *)tips  andClickAction:(void (^)(void))clickAction;


/**
 自定义错误页面
 
 @param image 错误页面图片
 @param tips 错误页面提示
 @param handler 点击操作
 */
- (void)showFailureViewWithImage:(UIImage *)image tips:(NSString *)tips andBtnClickHandler:(void(^)(__kindof UIButton *tapBtn))handler;


/**
 隐藏错误页面
 */
- (void)hiddenFailureView;


@end
