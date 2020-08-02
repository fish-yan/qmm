//
//  HYUserInfoVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"
#import "HYUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UserType) {
    UserTypeOther,
    UserTypeSelf,
};

@interface HYUserInfoVM : YSBaseViewModel

@property (nonatomic, strong) RACCommand *requestCmd;
@property (nonatomic, strong) RACCommand *updateCmd;

@property (nonatomic, assign) UserType type;

@property (nonatomic, strong) NSNumber *cityID;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) id infoModel;


@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) BOOL appointmentstatus;
@property (nonatomic, assign) BOOL beckoningstatus;
@property (nonatomic, copy) NSString *dateId;

@end

NS_ASSUME_NONNULL_END
