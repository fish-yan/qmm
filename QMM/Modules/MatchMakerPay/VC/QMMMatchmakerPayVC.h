//
//  QMMMatchmakerPayVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMMatchmakerPayVC : YSBaseTableViewController

@property (nonatomic, copy) void(^payResultHandler)(BOOL isSuccess);

@end

NS_ASSUME_NONNULL_END
