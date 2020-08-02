//
//  QMMLoginVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/11/8.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMLoginVM : YSBaseViewModel

@property (nonatomic, strong) RACCommand *getMobileCodeCmd;
@property (nonatomic, strong) RACCommand *loginCmd;

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) NSInteger cutdownTime;
@property (nonatomic, assign) BOOL resendEnable;
@property (nonatomic, assign) UserInfoType infoType;
@property (nonatomic, assign) BOOL notNeedCertify;

@end

NS_ASSUME_NONNULL_END
