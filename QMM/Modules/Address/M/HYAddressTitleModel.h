//
//  HYAddressTitleModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYAddressTitleModel : YSBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL hasUnread;

+ (instancetype)modelWithTitle:(NSString *)title hasUnread:(BOOL)hasUnread;

@end

NS_ASSUME_NONNULL_END
