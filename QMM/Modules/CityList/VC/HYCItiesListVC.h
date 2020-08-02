//
//  HYCItiesListVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYCItiesListVC : YSNavigationController

@property (nonatomic, copy) void(^callBack)(NSDictionary *info);

@end

NS_ASSUME_NONNULL_END
