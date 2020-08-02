//
//  HYDatingMarginHelper.h
//  youbaner
//
//  Created by Joseph Koh on 2018/6/26.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYOrderPayModel.h"

@interface HYDatingMarginHelper : NSObject

+ (instancetype)handMarginOfDating:(NSString *)datingId result:(void (^)(NSError *error, HYOrderPayModel *payModel))result;
@property (nonatomic, strong) RACCommand *payCmd;

@end
