//
//  NetMonitor.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetMonitor : NSObject

@property (nonatomic, assign, getter=isReachable) BOOL reachable;

+ (instancetype)shareTools;

- (void)startMonitoring;
- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
