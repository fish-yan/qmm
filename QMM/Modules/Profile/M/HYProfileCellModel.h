//
//  HYProfileCellModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ProfileCellType) {
    ProfileCellTypeNull,
    ProfileCellTypeInfo,
    ProfileCellTypeMenu,
    ProfileCellTypeList,
};


@interface HYProfileCellModel : YSBaseModel

@property (nonatomic, assign) ProfileCellType type;
@property (nonatomic, strong) id value;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *mapStr;

+ (instancetype)modelWithType:(ProfileCellType)type
                        title:(NSString *)title
                         desc:(NSString *)desc
                       mapStr:(NSString *)mapStr
                        value:(id)value;

+ (instancetype)modelWithTitle:(NSString *)title
                          desc:(NSString *)desc
                        mapStr:(NSString *)mapStr
                         value:(id)valu;

@end

NS_ASSUME_NONNULL_END
