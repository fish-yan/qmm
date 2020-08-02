//
//  QMMSupplementaryVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMSupplementaryVM : YSBaseViewModel

@property (nonatomic, copy) NSString *gender;
@property (nonatomic, assign) BOOL isMale;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, strong) NSNumber *workareaCode;
@property (nonatomic, copy) NSString *salary;

@property (nonatomic, strong) RACCommand *saveInfoCmd;

@end

NS_ASSUME_NONNULL_END
