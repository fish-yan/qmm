//
//  HYDatingMarginHelper.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/26.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYDatingMarginHelper.h"
#import "QMMPopDataModel.h"

@interface HYDatingMarginHelper ()

@property (nonatomic, copy) NSString *datingId;
@property (nonatomic, copy) void(^result)(NSError *error, HYOrderPayModel *payModel);

@end

@implementation HYDatingMarginHelper

+ (instancetype)handMarginOfDating:(NSString *)datingId
                            result:(void (^)(NSError *error, HYOrderPayModel *payModel))result {
    
    HYDatingMarginHelper *helper = [HYDatingMarginHelper new];
    helper.datingId = datingId;
    helper.result = result;
    
    return helper;
}

- (instancetype)init {
    if (self = [super init]) {
        @weakify(self);
        self.payCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [self orderSignal];
        }];
        
        [self bind];
    }
    
    return self;
}

- (void)bind {
    @weakify(self);
    [[self.payCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.result) {
            self.result(nil, x);
        }
    }];
    [self.payCmd.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        if (self.result) {
            self.result(x, nil);
        }
    }];
    
}

- (RACSignal *)orderSignal {
    NSDictionary *params = @{
                             @"id": self.datingId ?: @""
                             };
    return [[YSRequestAdapter requestSignalWithURL:@""
                                            params:[params decodeWithAPI:API_PREPAYAPPOINMENT]
                                       requestType:YSRequestTypePOST
                                      responseType:YSResponseTypeObject
                                     responseClass:[HYOrderPayModel class]]
            map:^id _Nullable(YSResponseModel * _Nullable value) {
                return value.data;
            }];
}

//- (RACSignal *)marginInfoSignal {
//    NSDictionary *params = @{
//                             @"type": @"5",
//                             @"id": self.datingId ?: @""
//                             };
//    return [[YSRequestAdapter requestSignalWithURL:@""
//                                            params:[NSDictionary convertParams:API_getmemberproduct dic:params]
//                                       requestType:YSRequestTypePOST
//                                      responseType:YSResponseTypeObject
//                                     responseClass:[HYPopDataModel class]]
//            map:^id _Nullable(YSResponseModel * _Nullable value) {
//                return value.data;
//            }];
//}
//
//// 获取余额信息 余额支付
//- (RACSignal *)paySignalOfBalance {
//    NSDictionary *params = @{ @"type": @"3" };
//    return [[YSRequestAdapter requestSignalWithURL:@""
//                                           params:[NSDictionary convertParams:API_PREPAYMENTOEDER dic:params]
//                                      requestType:YSRequestTypePOST
//                                     responseType:YSResponseTypeList
//                                    responseClass:[prepayappointmentModel class]]
//            map:^id _Nullable(YSResponseModel * _Nullable value) {
//                return value.data;
//            }];
//}

@end
