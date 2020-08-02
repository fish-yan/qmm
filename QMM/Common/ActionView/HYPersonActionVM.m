//
//  QMMBottomActionVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMBottomActionVM.h"

@implementation QMMBottomActionVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    @weakify(self);
    self.heartCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [self heartSignalWithParams:input];
    }];
}


- (RACSignal *)heartSignalWithParams:(NSDictionary *)params {
    return [[QMMRequestAdapter requestSignalParams:[params decodeWithAPI:API_ISBEMOVED]
                                     responseType:YSResponseTypeMessage
                                    responseClass:nil]
            map:^id _Nullable(YSResponseModel * _Nullable value) {
                return value.msg;
            }];
}

@end
