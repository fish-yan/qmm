//
//  QMMUserBasicInfoVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UserInfoEditType) {
    UserInfoEditTypeBasic,
    UserInfoEditTypeFriend,
};


@interface QMMUserBasicInfoVM : YSBaseViewModel

@property (nonatomic, strong) HYUserModel *infoModel;
@property (nonatomic, assign) UserInfoEditType type;

@property (nonatomic, strong) NSArray *dataArray;

@end

NS_ASSUME_NONNULL_END
