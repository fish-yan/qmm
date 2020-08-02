//
//  HYOrderPayModel.h
//  SeeYou
//
//  Created by Joseph Koh on 2018/7/13.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseModel.h"

@interface HYOrderPayModel : YSBaseModel

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *payamount;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *orderid;

@end
