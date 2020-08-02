//
//  QMMMeetingContentVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewController.h"
#import "QMMMeetingVM.h"

@interface QMMMeetingContentVC : YSBaseTableViewController

@property (nonatomic, assign) ContentType type;

- (void)updataWithFilterInfos:(QMMFilterRecordModel *)filterInfos;

@end
