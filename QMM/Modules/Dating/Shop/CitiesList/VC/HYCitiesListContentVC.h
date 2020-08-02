//
//  HYCitiesListContentVC.h
//  SeeYou
//
//  Created by Joseph Koh on 2018/7/7.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseTableViewController.h"

@interface HYCitiesListContentVC : YSBaseTableViewController

@property (nonatomic, copy) void(^callBack)(NSDictionary *info);

@end
