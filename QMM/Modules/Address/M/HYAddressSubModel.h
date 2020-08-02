//
//  HYAddressSubModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYAddressSubModel : YSBaseModel

@property(nonatomic ,copy) NSString * userID;
@property(nonatomic ,copy) NSString * userAvatar;
@property(nonatomic ,copy) NSString * userNickName;
@property(nonatomic ,copy) NSString * userAge;
@property(nonatomic ,copy) NSString * city;
@property(nonatomic ,strong) NSNumber * isheart;//1 表示我喜欢 2.我看过，3，喜欢我 ，4，互相喜欢
@property(nonatomic ,strong) NSNumber *isview;
@property (nonatomic, copy) NSString *mid;

@end

NS_ASSUME_NONNULL_END
