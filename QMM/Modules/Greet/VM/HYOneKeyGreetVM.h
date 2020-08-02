//
//  HYOneKeyGreetVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"
#import "HYOneKeyUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYOneKeyGreetVM : YSBaseViewModel

@property (nonatomic, strong) RACCommand *requestCmd;
@property (nonatomic, strong) RACCommand *greetCmd;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *localGreetArr;

@end

NS_ASSUME_NONNULL_END
