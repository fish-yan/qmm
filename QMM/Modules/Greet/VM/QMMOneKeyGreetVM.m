//
//  QMMOneKeyGreetVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMOneKeyGreetVM.h"

@implementation QMMOneKeyGreetVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.localGreetArr = @[@"你好，很高兴认识你！",
                           @"你好，擦肩即有缘，交个朋友呗！",
                           @"你好，可以交个朋友吗",
                           @"静静地给你打了一个招呼",
                           @"想找个人愉快的聊天",
                           @"你会是我的另一半吗",
                           @"茫茫大海，很高兴认识你",
                           @"想真心谈个朋友，可以认识一下吗"];
    @weakify(self);
    self.requestCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [[[self requestSignal]
                 map:^id _Nullable(YSResponseModel * _Nullable value) {
                     return value.data;
                 }]
                doNext:^(id  _Nullable x) {
                    @strongify(self);
                    self.dataArray = x;
                }] ;
    }];
    
    self.greetCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [self greetSignalWithParams:input];
    }];
}

- (RACSignal *)greetSignalWithParams:(NSDictionary *)params {
    return [QMMRequestAdapter requestSignalParams:[params decodeWithAPI:API_ONE_KEY_GREET]
                                     responseType:YSResponseTypeList
                                    responseClass:[QMMMemberInfoModel class]];
}

- (RACSignal *)requestSignal {
    NSDictionary *params = @{};
    return [QMMRequestAdapter requestSignalParams:[params decodeWithAPI:API_ONE_KEY_GREET_LIST]
                                     responseType:YSResponseTypeList
                                    responseClass:[QMMGreetUserModel class]];
}

@end
