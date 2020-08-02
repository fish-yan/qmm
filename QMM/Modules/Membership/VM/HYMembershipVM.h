//
//  HYMembershipVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/23.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYMembershipVM : YSBaseViewModel

@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, strong) RACCommand *doRaccommand;
@property (nonatomic, strong) RACCommand *getOrderid;

@end

NS_ASSUME_NONNULL_END
