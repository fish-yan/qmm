//
//  QMMLoginRegisterVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMLoginRegisterVM.h"
#import "CountDownHelper.h"

@interface QMMLoginRegisterVM ()

@property (nonatomic, strong) RACCommand *cutdownCmd;

@end

@implementation QMMLoginRegisterVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    @weakify(self);
    self.getMobileCodeCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSDictionary *dic = @{@"smstype": @15,
                              @"mobile": self.mobile ?: @""
                              };
        
        NSDictionary *params = [dic decodeWithAPI:API_VERIFYCODE];
        return [[[self getMobileCodeSignal:params]
                 doNext:^(id  _Nullable x) {
                     [[CountDownHelper shareHelper] startWithCountDownType:CountDownTypeRegister limitedTime:59];
                 }]
                map:^id _Nullable(YSResponseModel * _Nullable value) {
                    return value.msg;
                }];
    }];
    
    // ------------
    self.verifyCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSDictionary *dic = @{@"verifycode": self.code ?: @"",
                              @"mobile": self.mobile ?: @""
                              };
        NSDictionary *params = [dic decodeWithAPI:API_NEW_VERIFY_CODE];
        return [[[self verifySignal:params]
                 doNext:^(YSResponseModel * _Nullable x) {
                     @strongify(self);
                     [[QMMUserContext shareContext] deployLoginActionWithUserModel:x.data action:NULL];
                     self.infoType = [QMMUserContext shareContext].userModel.iscomplete;
                 }]
                map:^id _Nullable(YSResponseModel * _Nullable value) {
                    return value.msg;
                }];
    }];
    
    [[RACObserve([CountDownHelper shareHelper], registerTime) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.cutdownTime = [x integerValue];
        self.resendEnable = [x integerValue] <= 0;
    }];
    
}


- (RACSignal *)verifySignal:(NSDictionary *)params {
    return [YSRequestAdapter requestSignalWithURL:@""
                                           params:params
                                      requestType:YSRequestTypePOST
                                     responseType:YSResponseTypeObject
                                    responseClass:[HYUserCenterModel class]];
}

- (RACSignal *)getMobileCodeSignal:(NSDictionary *)params {
    return [YSRequestAdapter requestSignalWithURL:@""
                                           params:params
                                      requestType:YSRequestTypePOST
                                     responseType:YSResponseTypeMessage
                                    responseClass:nil];
}


@end
