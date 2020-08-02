//
//  HYMembershipVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/23.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYMembershipVM.h"

@implementation HYMembershipVM

- (id)init {
    self = [super init];
    if (self) {
        [self initalize];
    }
    return self;
}

- (void)initalize {
    @weakify(self);
    self.doRaccommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(NSDictionary *_Nullable input) {
        @strongify(self);
        NSDictionary *params = input ?: @{};
        params = [params decodeWithAPI:API_CHECK_APPLE];
        return [[self checkInfo:params] doNext:^(YSResponseModel *_Nullable x){
        }];
    }];

    self.getOrderid = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(id _Nullable input) {
        @strongify(self);
        NSDictionary *params = input ?: @{};
        params = [params decodeWithAPI:API_CHECK_APPLE];
        return [[self getorderid:params] doNext:^(YSResponseModel *_Nullable x) {
            @strongify(self);
            self.orderid = x.extra;
        }];
    }];
}
- (RACSignal *)checkInfo:(NSDictionary *)dic {
    RACSignal *signal = [YSRequestAdapter requestSignalWithURL:@""
                                                        params:dic
                                                   requestType:YSRequestTypePOST
                                                  responseType:YSResponseTypeMessage
                                                 responseClass:nil];
    return signal;
}

- (RACSignal *)getorderid:(NSDictionary *)dic {
    RACSignal *signal = [YSRequestAdapter requestSignalWithURL:@""
                                                        params:dic
                                                   requestType:YSRequestTypePOST
                                                  responseType:YSResponseTypeObject
                                                 responseClass:[NSString class]];
    return signal;
}

@end
