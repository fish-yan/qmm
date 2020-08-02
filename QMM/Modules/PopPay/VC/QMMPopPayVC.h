//
//  QMMPopPayVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewController.h"
#import "QMMPopPayVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMPopPayVC : YSBaseViewController

@property (nonatomic, copy) void(^payResult)(BOOL isSuccess);

@end

NS_ASSUME_NONNULL_END
