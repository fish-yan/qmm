//
//  QMMAuthCellModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AuthCellType) {
    AuthCellTypeInfo,
    AuthTypeUpIDImage,
};


@interface QMMAuthCellModel : YSBaseModel

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) AuthCellType cellType;

+ (instancetype)modelWithCellType:(AuthCellType)type
                             icon:(NSString *)icon
                            title:(NSString *)title
                             info:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
