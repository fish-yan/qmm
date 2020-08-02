//
//  HYDatingInfoVC.h
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "YSBaseTableViewController.h"

@interface HYDatingInfoVC : YSBaseTableViewController

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *dateID;
@property (nonatomic, strong) NSNumber *appointmentstatus;

@end
