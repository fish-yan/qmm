//
//  HYAddressListModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"
#import "HYAddressSubModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYAddressListModel : YSBaseModel

@property (nonatomic, strong) HYAddressSubModel *leftModel;
@property (nonatomic, strong) HYAddressSubModel *rightModel;

@end

NS_ASSUME_NONNULL_END
