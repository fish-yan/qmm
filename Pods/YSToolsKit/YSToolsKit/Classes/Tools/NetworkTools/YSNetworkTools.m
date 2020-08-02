//
//  YSNetworkTools.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/12.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSNetworkTools.h"
#import "AFNetworkReachabilityManager.h"

#define NETWORK_REACHABILITY_MANAGER [AFNetworkReachabilityManager sharedManager]

@implementation YSNetworkTools

+ (instancetype)shareTools {
    static dispatch_once_t onceToken;
    static YSNetworkTools *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance->_reachable = YES;
    });
    return instance;
}

- (void)startMonitoring {
    [NETWORK_REACHABILITY_MANAGER setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self->_reachable = YES;
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                self->_reachable = NO;
                break;
            default:
                break;
        }
    }];
    
    [NETWORK_REACHABILITY_MANAGER startMonitoring];
}

- (void)stopMonitoring {
    [NETWORK_REACHABILITY_MANAGER stopMonitoring];
}




@end
