//
//  QMMUserInfoVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewController.h"
#import "QMMUserInfoVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMUserInfoVC : YSBaseTableViewController

@property (nonatomic, assign) UserType type;
@property (nonatomic, copy) NSString *uid;

@end

NS_ASSUME_NONNULL_END
