//
//  HYUpdateUserInfoHelper.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUpdateUserInfoHelper.h"

@implementation HYUpdateUserInfoHelper

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    @weakify(self);
    self.updateCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [[self updateSignalWithParams:input] doNext:^(id  _Nullable x) {
            NSLog(@"--");
        }];
    }];
}

- (RACSignal *)updateSignalWithParams:(NSDictionary *)params {
    return [[YSRequestAdapter requestSignalWithURL:@""
                                            params:[params decodeWithAPI:API_EDITORUSERINFO]
                                       requestType:YSRequestTypePOST
                                      responseType:YSResponseTypeMessage
                                     responseClass:nil]
            map:^id _Nullable(YSResponseModel * _Nullable value) {
                return value.msg;
            }];
}


@end
