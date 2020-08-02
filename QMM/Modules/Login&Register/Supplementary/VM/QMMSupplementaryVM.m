//
//  QMMSupplementaryVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMSupplementaryVM.h"

@implementation QMMSupplementaryVM


- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    @weakify(self);
    self.saveInfoCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        HYUserCenterModel *model = [QMMUserContext shareContext].userModel;
        model.iscomplete = UserInfoTypeNoAvatar;
        [[QMMUserContext shareContext] updateUserInfo:model];        
        
        @strongify(self);
        NSDictionary *dict = @{
                                 @"name": self.nickName ?: @"",
                                 @"sex": self.gender ?: @"",
                                 @"birthday": self.birthday ?: @"",
                                 @"workarea": self.workareaCode ?: @"",
                                 @"salary": self.salary ?: @"",
                                 };
        NSDictionary *params = [dict decodeWithAPI:API_SAVEPARTUSE_DATA];
        return [self saveSignal:params];
    }];
}

- (RACSignal *)saveSignal:(NSDictionary *)params {
    return [YSRequestAdapter requestSignalWithURL:@""
                                           params:params
                                      requestType:YSRequestTypePOST
                                     responseType:YSResponseTypeMessage
                                    responseClass:nil];
}


@end
