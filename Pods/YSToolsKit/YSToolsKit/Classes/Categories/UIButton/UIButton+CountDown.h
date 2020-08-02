//
//  UIButton+CountDown.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CountDown)

/// [btn startCountDownWithLimitedTime:10 normalTitle:@"获取验证码" waitingTitle:@"秒后重发"];
-(void)startCountDownWithLimitedTime:(NSInteger)limitedTime
                         normalTitle:(NSString *)normalTitle
                        waitingTitle:(NSString *)waitingTitle;

-(void)startCountDownWithLimitedTime:(NSInteger)limitedTime
                         normalTitle:(NSString *)normalTitle
                        waitingTitle:(NSString *)waitingTitle
                       waitingEnable:(BOOL)isWaitingEnable
                         finishAction:(void(^)(void))finishAction;

@end
