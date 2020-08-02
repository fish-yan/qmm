//
//  QMMContactModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMContactModel : YSBaseModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *workcity;
/// 1 表示我喜欢 2.我看过，3，喜欢我 ，4，互相喜欢
@property (nonatomic, strong) NSNumber *isheart;
@property (nonatomic, strong) NSNumber *isview;
@property (nonatomic, copy) NSString *mid;

@end

NS_ASSUME_NONNULL_END
