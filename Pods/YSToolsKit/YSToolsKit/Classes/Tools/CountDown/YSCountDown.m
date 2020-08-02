//
//  YSCountDown.m
//  Pods
//
//  Created by Joseph Koh on 2018/5/10.
//

#import "YSCountDown.h"

@interface YSCountDown ()

@property (nonatomic, strong) dispatch_source_t _timer;

@end

@implementation YSCountDown
+ (instancetype)share {
    static dispatch_once_t onceToken;
    static YSCountDown *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)startWithLimitedTime:(NSInteger)limitedTime {
    if (self.countDown > 0) return;
    __block NSInteger timeOut = limitedTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self._timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self._timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self._timer, ^{
        if(timeOut <= 0){
            dispatch_source_cancel(self._timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countDown = 0;
            });
        }
        else{
            int seconds = timeOut % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countDown = seconds;
            });
            timeOut--;
        }
    });
    dispatch_resume(self._timer);
}

- (void)stop {
    dispatch_source_cancel(self._timer);
    self.countDown = 0;
}
@end
