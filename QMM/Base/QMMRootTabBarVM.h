//
//  QMMRootTabBarVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <YSProjectBaseModule/YSProjectBaseModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMMRootTabBarVM : YSBaseViewModel

@property(nonatomic,strong) RACSignal *configVCSignal;

@end

NS_ASSUME_NONNULL_END
