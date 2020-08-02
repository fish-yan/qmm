//
//  WDFailureView.h
//  HCDoctor
//
//  Created by Joseph Gao on 2017/6/14.
//  Copyright © 2017年 WondersGroup.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDFailureView : UIView
@property (nonatomic, strong) UILabel *tipsLabel;
/**
 显示错误页面
 
 @param image 错误页面图片
 @param tips 错误描述
 @param labelClickHandler 描述标签点击操作
 @param handler 底部按钮执行操作, 传NUll会不显示底部按钮
 */
- (void)showFailureViewWithImage:(UIImage *)image
                            tips:(NSString *)tips
               labelClickHandler:(void(^)(void))labelClickHandler
                 btnClickHandler:(void(^)(UIButton *tapBtn))handler;

@end
