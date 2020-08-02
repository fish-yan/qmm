//
//  QMMUserInfoCellModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

typedef NS_ENUM(NSInteger, UserInfoCellType) {
    UserInfoCellTypeHeader,
    UserInfoCellTypeInfo,
    UserInfoCellTypePhotos,
    UserInfoCellTypeList,
    UserInfoCellTypeDesc,
    UserInfoCellTypeTags,
};


@interface QMMUserInfoCellModel : YSBaseModel

@property (nonatomic, strong) id value;
@property (nonatomic, assign) UserInfoCellType cellType;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)modelWithType:(UserInfoCellType)cellType
                        value:(id)values
                        title:(NSString *)title
                         desc:(NSString *)desc;

@end
