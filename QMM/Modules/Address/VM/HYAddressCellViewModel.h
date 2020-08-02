//
//  HYAddressCellViewModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"
#import "HYAddressSubViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYAddressCellViewModel : YSBaseViewModel

@property (nonatomic, strong) HYAddressSubViewModel *leftViewModel;
@property (nonatomic, strong) HYAddressSubViewModel *rightViewModel;

@end

NS_ASSUME_NONNULL_END
