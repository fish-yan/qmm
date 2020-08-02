//
//  QMMContactItemVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMContactItemVM : YSBaseViewModel

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSURL *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *userAgeAndcity;
@property (nonatomic, strong) NSNumber *heartType;    // 1 表示我喜欢 2.我看过，3，喜欢我 ，4，互相喜欢
@property (nonatomic, strong) RACCommand *heartCmd;
@property (nonatomic, strong) NSNumber *isView;
/// 查看类型(0:我喜欢的 1:看过去我,2:喜欢我,互相喜欢)
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) RACCommand *markCmd;

+ (instancetype)viewModelWithObj:(id)obj;

@end

NS_ASSUME_NONNULL_END
