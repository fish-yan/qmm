//
//  HYPersonActionVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYPersonActionVM : YSBaseViewModel

@property (nonatomic, strong) RACCommand *heartCmd;

@end

NS_ASSUME_NONNULL_END
