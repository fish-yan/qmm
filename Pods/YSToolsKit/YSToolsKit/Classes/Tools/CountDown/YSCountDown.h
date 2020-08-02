//
//  YSCountDown.h
//  Pods
//
//  Created by Joseph Koh on 2018/5/10.
//

#import <Foundation/Foundation.h>

@interface YSCountDown : NSObject

@property (nonatomic, assign) NSInteger countDown;

+ (instancetype)share;

- (void)startWithLimitedTime:(NSInteger)limitedTime;
- (void)stop;

@end
