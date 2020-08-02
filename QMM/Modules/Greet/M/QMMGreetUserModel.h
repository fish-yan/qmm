//
//  QMMGreetUserModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMGreetUserModel : YSBaseModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *height;

@end

NS_ASSUME_NONNULL_END
