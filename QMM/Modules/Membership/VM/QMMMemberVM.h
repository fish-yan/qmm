//
//  QMMMemberVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/23.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

@interface QMMMemberVM : YSBaseViewModel

@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, strong) RACCommand *checkReceiptCmd;
@property (nonatomic, strong) RACCommand *fetchOrderInfoCmd;
@property (nonatomic, strong) NSArray *membersIdArr;

@end
