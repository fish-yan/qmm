//
//  IAPHelperViewModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "IAPHelperViewModel.h"
#import "IAPHelper.h"

@interface IAPHelperViewModel ()



@end

@implementation IAPHelperViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self __initialize];
    }
    return self;
}

- (void)__initialize {
    self.iapHelper = [IAPHelper helper];
    
    @weakify(self);
    self.checkReceiptCmd =[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *  _Nullable receipt) {
        @strongify(self);
        NSDictionary *params = @{@"receipt_data": receipt ?: @"",
                                 @"id": self.orderid ?: @""};
        return [self checkReceiptSignal:[params decodeWithAPI:API_CHECK_APPLE]];
    }];
    
    self.fetchOrderIDCmd =[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        
        [self.iapHelper finishUncomplatePurchase];
        NSDictionary *params = @{@"no": self.identifier ?: @""};
        return [[self fetchOrderIDSignal:[params decodeWithAPI:API_GETORDERID]]
                doNext:^(YSResponseModel *  _Nullable x) {
                    @strongify(self);
                    self.orderid = x.extra;
                }];
    }];
}

- (void)fetchDataWithResult:(void(^)(NSArray *dataArray, NSError *error))result {
    if (!self.productIdentifiers || self.productIdentifiers.count == 0) {
        NSError *error = [NSError errorWithDomain:NSArgumentDomain
                                             code:1004
                                         userInfo:@{NSLocalizedDescriptionKey: @"参数错误"}];
        if (result) {
            result(nil, error);
        }
        return;
    }
    [self.iapHelper fetchIAPProducts:self.productIdentifiers
                          withResult:^(NSArray<SKProduct *> * _Nonnull products, NSError * _Nonnull error) {
                              if (error) {
                                  if (result) {
                                      result(products, error);
                                  }
                                  return;
                              }
                              if ([products count] == 0) {
                                  NSError *emptyError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                                            code:1001
                                                                        userInfo:@{NSLocalizedDescriptionKey: @"暂无商品可以销售"}];
                                  if (result) {
                                      result(products, emptyError);
                                  }
                                  return;
                              }
                              
                              if (result) {
                                  result(products, nil);
                              }
                          }];
    
}

- (void)purchaseWithResult:(void(^)(NSString *receipt, NSError *error))result {
    [self.iapHelper purchaseIdentrifier:self.identifier withRestult:result];
}


-(RACSignal *)checkReceiptSignal:(NSDictionary*)dic {
    return [QMMRequestAdapter requestSignalParams:dic
                                     responseType:YSResponseTypeMessage
                                    responseClass:nil];
    
    
//    RACSignal *signal =[YSRequestAdapter requestSignalWithURL:@""
//                                                       params:dic
//                                                  requestType:YSRequestTypePOST
//                                                 responseType:YSResponseTypeMessage
//                                                responseClass:nil];
//    return signal;
}

-(RACSignal *)fetchOrderIDSignal:(NSDictionary*)dic {
    return [QMMRequestAdapter requestSignalParams:dic
                                     responseType:YSResponseTypeOriginal
                                    responseClass:nil];
}


@end

