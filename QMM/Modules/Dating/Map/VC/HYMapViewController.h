//
//  HYMapViewController.h
//  youbaner
//
//  Created by Joseph Koh on 2018/6/23.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseViewController.h"

@interface HYMapViewController : YSBaseViewController

@property (nonatomic, strong) QMMCoordinate *endLocation;
@property (nonatomic, strong) QMMCoordinate *currentLocation;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *range;

@end
