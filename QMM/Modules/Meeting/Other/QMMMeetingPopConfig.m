//
//  QMMMeetingPopConfig.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMMeetingPopConfig.h"

static NSString *const kPopKeySave = @"kPopKeySave";
static NSString *const kPopKeySaveTime = @"kPopKeySaveTime";
static NSString *const kPopKeySavePopTime = @"kPopKeySavePopTime";
static NSString *const kPopKeySaveDate = @"kPopKeySaveDate";

@interface QMMMeetingPopConfig ()

@property (nonatomic, strong) NSDictionary *popInfo;

@end

@implementation QMMMeetingPopConfig


static QMMMeetingPopConfig *config = nil;
+ (instancetype)shareConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [QMMMeetingPopConfig new];
        config.popInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kPopKeySave];
    });
    return config;
}

- (NSString *)today {
    NSDateFormatter *f0rmater = [[NSDateFormatter alloc] init];
    f0rmater.dateFormat = @"yyyy-MM-dd";
    NSString *date = [f0rmater stringFromDate:[NSDate date]];
    return date;
}

- (void)configPopTime:(NSInteger)time {
    if (self.popInfo) {
        NSInteger popTime = [self.popInfo[kPopKeySavePopTime] integerValue];
        NSString *date = self.popInfo[kPopKeySaveDate];
        [self updatePopInfoWithTime:time popTime:popTime date:date ?: [self today]];
        
        return;
    }
    
    self.popInfo = @{
                     kPopKeySaveTime: @(time),
                     kPopKeySavePopTime: @(0),
                     kPopKeySaveDate: [self today]
                     };
    [[NSUserDefaults standardUserDefaults] setObject:self.popInfo forKey:kPopKeySave];
    
}
- (void)popWithActionHandle:(void(^)(NSArray *infos))hander {
    //    [self doPopActionWithHandler:hander];
    //    return;
    
    NSInteger time = [self.popInfo[kPopKeySaveTime] integerValue];
    NSInteger popTime = [self.popInfo[kPopKeySavePopTime] integerValue];
    NSString *date = self.popInfo[kPopKeySaveDate];
    if (![date isEqualToString:[self today]] || popTime < time) {
        [self doPopActionWithHandler:hander];
        [self updatePopInfoWithTime:time popTime:(popTime + 1) date:[self today]];
    }
}

- (void)updatePopInfoWithTime:(NSInteger)time popTime:(NSInteger)popTime date:(NSString *)date {
    self.popInfo = @{
                     kPopKeySaveTime: @(time),
                     kPopKeySavePopTime: @(popTime),
                     kPopKeySaveDate: date
                     };
    [[NSUserDefaults standardUserDefaults] setObject:self.popInfo forKey:kPopKeySave];
}

- (void)doPopActionWithHandler:(void(^)(NSArray *infos))hander {
        [YSMediator presentToViewController:kModuleOneKeyGreetView
                                 withParams:nil
                                   animated:YES
                                   callBack:NULL];
}

@end
