//
//  IAPHelper.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IAPHelper : NSObject
@property (nonatomic, strong) NSArray *identifiers;
+ (instancetype)helper;

- (void)fetchIAPProducts:(NSArray<NSString *> *)identifiers
              withResult:(void(^)(NSArray<SKProduct *> *products, NSError *error))result;

- (void)purchaseIdentrifier:(NSString *)identifier
                withRestult:(void(^)(NSString *receipt, NSError *error))result;

- (void)finishUncomplatePurchase;

@end

NS_ASSUME_NONNULL_END
