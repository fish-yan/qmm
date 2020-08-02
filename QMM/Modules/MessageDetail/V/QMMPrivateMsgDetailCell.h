//
//  QMMPrivateMsgDetailCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"

@class QMMPrivateMsgModel;

@interface QMMPrivateMsgDetailCell : YSBaseTableViewCell

@property (nonatomic, strong) QMMPrivateMsgModel *Model;

+ (CGFloat)getheight:(QMMPrivateMsgModel *)model;

@end
