//
//  QMMMeetingPopConfig.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QMMMeetingPopConfig : NSObject

+ (instancetype)shareConfig;

- (void)configPopTime:(NSInteger)time;
- (void)popWithActionHandle:(void(^)(NSArray *infos))hander;

@end
