//
//  YSNetworkTools.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/12.
//  Copyright © 2017年 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSNetworkTools : NSObject

@property (nonatomic, assign, getter=isReachable) BOOL reachable;

+ (instancetype)shareTools;

- (void)startMonitoring;
- (void)stopMonitoring;

@end
