//
//  IAPHelperViewModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IAPHelperViewModel : NSObject
@property (nonatomic, strong) IAPHelper *iapHelper;

@property (nonatomic, strong) NSArray *productIdentifiers;

@property (nonatomic, copy) NSString *orderid;
@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) RACCommand *checkReceiptCmd;
@property (nonatomic, strong) RACCommand *fetchOrderIDCmd;

- (void)fetchDataWithResult:(void(^)(NSArray *dataArray, NSError *error))result;
- (void)purchaseWithResult:(void(^)(NSString *receipt, NSError *error))result;

@end

NS_ASSUME_NONNULL_END
