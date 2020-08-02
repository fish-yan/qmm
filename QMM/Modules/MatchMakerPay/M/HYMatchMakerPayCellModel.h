//
//  HYMatchMakerPayCellModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HYMatchMakerPayCellType) {
    HYMatchMakerPayCellTypeIntro,
    HYMatchMakerPayCellTypeItems,
};

@interface HYMatchMakerPayCellModel : YSBaseModel

@property (nonatomic, assign) HYMatchMakerPayCellType type;
@property (nonatomic, strong) id date;

+ (instancetype)modelWithType:(HYMatchMakerPayCellType)type date:(nullable id)date;

@end

NS_ASSUME_NONNULL_END
