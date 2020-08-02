//
//  HYUserInfoPhotosCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUserInfoBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYUserInfoPhotosCell : HYUserInfoBaseCell

@property (nonatomic, copy) void(^addBtnClickHandler)(void);
@property (nonatomic, copy) void(^imageBtnClickHandler)(NSArray *images, NSInteger idx);

@property (nonatomic, assign) BOOL isMySelf;

@end

NS_ASSUME_NONNULL_END
