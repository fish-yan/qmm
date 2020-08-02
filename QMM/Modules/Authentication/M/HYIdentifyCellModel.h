//
//  HYIdentifyCellModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HYIdentifyCellType) {
    HYIdentifyCellTypeInfo,
    HYIdentifyCellTypeUpIDImage,
};


@interface HYIdentifyCellModel : YSBaseModel

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) HYIdentifyCellType cellType;

+ (instancetype)modelWithCellType:(HYIdentifyCellType)type
                             icon:(NSString *)icon
                            title:(NSString *)title
                             info:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
