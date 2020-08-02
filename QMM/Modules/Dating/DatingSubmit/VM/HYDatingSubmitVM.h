//
//  HYDatingSubmitVM.h
//  SeeYou
//
//  Created by Joseph Koh on 2018/7/11.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseViewModel.h"

@interface HYDatingSubmitVM : YSBaseViewModel

@property (nonatomic, copy) NSString *ruleHtmlString;

@property (nonatomic, strong) RACCommand *requestCmd;
@property (nonatomic, strong) RACCommand *payCmd;

@end
