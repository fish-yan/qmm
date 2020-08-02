//
//  UIButton+CountDown.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "UIButton+CountDown.h"

@implementation UIButton (CountDown)

-(void)startCountDownWithLimitedTime:(NSInteger)limitedTime
                         normalTitle:(NSString *)normalTitle
                        waitingTitle:(NSString *)waitingTitle
                       waitingEnable:(BOOL)isWaitingEnable
                        finishAction:(void(^)(void))finishAction {
    __block NSInteger timeOut = limitedTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if(timeOut <= 0){ // 倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:normalTitle forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
                
                if (finishAction) {
                    finishAction();
                }
            });
        }
        else{
            int seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:[NSString stringWithFormat:@"%@%@",strTime, waitingTitle]
                      forState:UIControlStateNormal];
                self.userInteractionEnabled = isWaitingEnable;
            });
            
            timeOut--;
        }
    });
    dispatch_resume(timer);
}

-(void)startCountDownWithLimitedTime:(NSInteger)limitedTime
                         normalTitle:(NSString *)normalTitle
                        waitingTitle:(NSString *)waitingTitle {
    [self startCountDownWithLimitedTime:limitedTime
                            normalTitle:normalTitle
                           waitingTitle:waitingTitle
                          waitingEnable:NO
                           finishAction:NULL];
}

@end
