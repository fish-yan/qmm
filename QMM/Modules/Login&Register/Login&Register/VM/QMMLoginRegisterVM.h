//
//  QMMLoginRegisterVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMLoginRegisterVM : YSBaseViewModel

@property (nonatomic, strong) RACCommand *getMobileCodeCmd;
@property (nonatomic, strong) RACCommand *verifyCmd;

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) NSInteger cutdownTime;
@property (nonatomic, assign) BOOL resendEnable;
@property (nonatomic, assign) UserInfoType infoType;

@end

NS_ASSUME_NONNULL_END
