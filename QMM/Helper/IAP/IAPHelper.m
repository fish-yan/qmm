//
//  IAPHelper.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "IAPHelper.h"

@interface IAPHelper ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>


@property (nonatomic, strong) NSMutableArray *products;

@property (nonatomic, copy) void(^fetchProductsRst)(NSArray *products, NSError *error);
@property (nonatomic, copy) void(^purchaseResult)(NSString *receipt, NSError *error);


@end

@implementation IAPHelper

+ (instancetype)helper {
    IAPHelper *helper = [IAPHelper new];
    return helper;
}

- (void)fetchIAPProducts:(NSArray<NSString *> *)identifiers
              withResult:(void(^)(NSArray<SKProduct *> *products, NSError *error))result {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    self.fetchProductsRst = result;
    self.identifiers = identifiers.copy;
    
    if (identifiers.count == 0) {
        if (result) {
            result(nil, [self argumentError]);
        }
        return;
    }
    
    
    if ([SKPaymentQueue canMakePayments]) {
        // 请求苹果后台商品
        // 这里的com.czchat.CZChat01就对应着苹果后台的商品ID,他们是通过这个ID进行联系的。
        // 初始化请求, 开始请求
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:identifiers]];
        request.delegate = self;
        [request start];
    }
    else {
        NSError *error = [NSError errorWithDomain:NSArgumentDomain
                                             code:1404
                                         userInfo:@{NSLocalizedDescriptionKey: @"Can not pay"}];
        if (result) {
            result(nil, error);
        }
        return;
    }
}


// 接收到产品的返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    self.products = products.mutableCopy;
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    if (self.fetchProductsRst) {
        self.fetchProductsRst(products, nil);
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"error:%@", error);
    if (self.fetchProductsRst) {
        self.fetchProductsRst(nil, error);
    }
}


//反馈请求的产品信息结束后
- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"信息反馈结束");
}


#pragma mark - Purchase Method

- (void)finishUncomplatePurchase {
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        SKPaymentTransaction* transaction = [transactions firstObject];
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [self completeTransaction:transaction];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }
}

- (void)purchaseIdentrifier:(NSString *)identifier withRestult:(nonnull void (^)(NSString *, NSError *))result {
    self.purchaseResult = result;
    
    if (identifier.length == 0
        || ![self.identifiers containsObject:identifier]) {
        if (result) {
            result(nil, [self argumentError]);
        }
        return;
    }
    
    SKProduct *product = nil;
    
    for (SKProduct *p in self.products) {
        if ([p.productIdentifier isEqualToString:identifier]) {
            product = p;
            break;
        }
    }
    
    if (!product) {
        if (result) {
            result(nil, [self argumentError]);
        }
        return;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}




// 监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction {
    SKPaymentTransaction *tran = transaction.lastObject;
    
    switch (tran.transactionState) {
        case SKPaymentTransactionStatePurchased: {
            [YSProgressHUD hiddenHUD];
            [self completeTransaction:tran];
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            break;
        }
            
        case SKPaymentTransactionStatePurchasing: {
            NSLog(@"Purchasing...");
            break;
        }
        case SKPaymentTransactionStateRestored: {
            NSError *error = [NSError errorWithDomain:tran.error.domain
                                                 code:tran.error.code
                                             userInfo:@{NSLocalizedDescriptionKey: @"已经购买过商品"}];
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            if (self.purchaseResult) {
                self.purchaseResult(nil, error);
            }
            break;
        }
        case SKPaymentTransactionStateFailed: {
            /*
             SKErrorUnknown,
             SKErrorClientInvalid,                                                     // client is not allowed to issue the request, etc.
             SKErrorPaymentCancelled,                                                  // user cancelled the request, etc.
             SKErrorPaymentInvalid,                                                    // purchase identifier was invalid, etc.
             SKErrorPaymentNotAllowed,                                                 // this device is not allowed to make the payment
             SKErrorStoreProductNotAvailable NS_ENUM_AVAILABLE(NA, 3_0),               // Product is not available in the current storefront
             SKErrorCloudServicePermissionDenied NS_ENUM_AVAILABLE(NA, 9_3),           // user has not allowed access to cloud service information
             SKErrorCloudServiceNetworkConnectionFailed NS_ENUM_AVAILABLE(NA, 9_3),    // the device could not connect to the nework
             SKErrorCloudServiceRevoked NS_ENUM_AVAILABLE(NA, 10_3),                   // user has revoked permission to use this cloud service
             */
            NSLog(@"%@", tran.error);
            //                NSString *errorString = @"";
            //                if (tran.error.code != SKErrorPaymentCancelled) {
            //                    NSLog(@"An error encounterd");
            //                    errorString = @"购买失败";
            //                }
            //                else {
            //                    NSLog(@"Cancelled!");
            //                    errorString = @"取消购买";
            //                }
            //                NSError *error = [NSError errorWithDomain:tran.error.domain
            //                                                     code:tran.error.code
            //                                                 userInfo:@{NSLocalizedDescriptionKey: errorString}];
            
            
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            if (self.purchaseResult) {
                self.purchaseResult(nil, tran.error);
            }
            break;
        }
        default:
            break;
    }
}


// 交易结束,当交易结束后服务器验证去appstore上验证支付信息是否都正确,
// 只有所有都正确后,我们就可以给用户方法我们的虚拟物品了。
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSString *str = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSString *receiptStr = [self encodeString:str];
    
    if (receiptStr.length > 0) {
        if (self.purchaseResult) {
            self.purchaseResult(receiptStr, nil);
        }
        return;
    }
    
    NSError *error = [NSError errorWithDomain:NSGlobalDomain
                                         code:1400
                                     userInfo:@{NSLocalizedDescriptionKey: @"Unknow Error"}];
    self.purchaseResult(nil, error);
}

/* str=@"%7B%0A%09%22signature%22%20%3D%20%22A1tXwl4BAxi5aknGHoTEi6yihgmXRAr8V5lpAgkBsp9CZ7%2BVn%2BC4HWkEMCC58zHmAnH20bJhELz58KcqAWbYdc3iz%2Foy1tc7Dn2KvKR%2BCIc44VeaCpyuTgztt4ZDpf99xFSMAbSpfaBkCQuV3wWpTEGr7Kd943Q8MpQjf9NXAWSO%2BDnnU2zbekcEj5KUvAu03KxY2yAShIvnw4T4X7IVo%2BvbdzkfZ1wrUin5A4P%2FD1AasTjLOBVA6YYke%2FS2qFWr%2FEA4qKOT6fWtMVnr3SLPxsr6Y07%2FNU%2BEGolygwWYYigSSxGO2EUwJRO04hLbVk7IgE1tsIMQT8A9dzZJ5ZvC%2BHkAAAWAMIIFfDCCBGSgAwIBAgIIDutXh%2BeeCY0wDQYJKoZIhvcNAQEFBQAwgZYxCzAJBgNVBAYTAlVTMRMwEQYDVQQKDApBcHBsZSBJbmMuMSwwKgYDVQQLDCNBcHBsZSBXb3JsZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9uczFEMEIGA1UEAww7QXBwbGUgV29ybGR3aWRlIERldmVsb3BlciBSZWxhdGlvbnMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTUxMTEzMDIxNTA5WhcNMjMwMjA3MjE0ODQ3WjCBiTE3MDUGA1UEAwwuTWFjIEFwcCBTdG9yZSBhbmQgaVR1bmVzIFN0b3JlIFJlY2VpcHQgU2lnbmluZzEsMCoGA1UECwwjQXBwbGUgV29ybGR3aWRlIERldmVsb3BlciBSZWxhdGlvbnMxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApc%2BB%2FSWigVvWh%2B0j2jMcjuIjwKXEJss9xp%2FsSg1Vhv%2BkAteXyjlUbX1%2FslQYncQsUnGOZHuCzom6SdYI5bSIcc8%2FW0YuxsQduAOpWKIEPiF41du30I4SjYNMWypoN5PC8r0exNKhDEpYUqsS4%2B3dH5gVkDUtwswSyo1IgfdYeFRr6IwxNh9KBgxHVPM3kLiykol9X6SFSuHAnOC6pLuCl2P0K5PB%2FT5vysH1PKmPUhrAJQp2Dt7%2Bmf7%2Fwmv1W16sc1FJCFaJzEOQzI6BAtCgl7ZcsaFpaYeQEGgmJjm4HRBzsApdxXPQ33Y72C3ZiB7j7AfP4o7Q0%2FomVYHv4gNJIwIDAQABo4IB1zCCAdMwPwYIKwYBBQUHAQEEMzAxMC8GCCsGAQUFBzABhiNodHRwOi8vb2NzcC5hcHBsZS5jb20vb2NzcDAzLXd3ZHIwNDAdBgNVHQ4EFgQUkaSc%2FMR2t5%2BgivRN9Y82Xe0rBIUwDAYDVR0TAQH%2FBAIwADAfBgNVHSMEGDAWgBSIJxcJqbYYYIvs67r2R1nFUlSjtzCCAR4GA1UdIASCARUwggERMIIBDQYKKoZIhvdjZAUGATCB%2FjCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjA2BggrBgEFBQcCARYqaHR0cDovL3d3dy5hcHBsZS5jb20vY2VydGlmaWNhdGVhdXRob3JpdHkvMA4GA1UdDwEB%2FwQEAwIHgDAQBgoqhkiG92NkBgsBBAIFADANBgkqhkiG9w0BAQUFAAOCAQEADaYb0y4941srB25ClmzT6IxDMIJf4FzRjb69D70a%2FCWS24yFw4BZ3%2BPi1y4FFKwN27a4%2Fvw1LnzLrRdrjn8f5He5sWeVtBNephmGdvhaIJXnY4wPc%2Fzo7cYfrpn4ZUhcoOAoOsAQNy25oAQ5H3O5yAX98t5%2FGioqbisB%2FKAgXNnrfSemM%2Fj1mOC%2BRNuxTGf8bgpPyeIGqNKX86eOa1GiWoR1ZdEWBGLjwV%2F1CKnPaNmSAMnBjLP4jQBkulhgwHyvj3XKablbKtYdaG6YQvVMpzcZm8w7HHoZQ%2FOjbb9IYAYMNpIr7N4YtRHaLSPQjvygaZwXG56AezlHRTBhL8cTqA%3D%3D%22%3B%0A%09%22purchase-info%22%20%3D%20%22ewoJIm9yaWdpbmFsLXB1cmNoYXNlLWRhdGUtcHN0IiA9ICIyMDE4LTA2LTI0IDAyOjE4OjU1IEFtZXJpY2EvTG9zX0FuZ2VsZXMiOwoJInF1YW50aXR5IiA9ICIxIjsKCSJ1bmlxdWUtdmVuZG9yLWlkZW50aWZpZXIiID0gIjdGNzAzOUI3LUQxRTctNEI0RS1BQzNCLUEyRkE4NEU5RDI0MyI7Cgkib3JpZ2luYWwtcHVyY2hhc2UtZGF0ZS1tcyIgPSAiMTUyOTgzMTkzNTAwMCI7CgkiZXhwaXJlcy1kYXRlLWZvcm1hdHRlZCIgPSAiMjAxOC0wNi0yNCAwOTo0ODo1NCBFdGMvR01UIjsKCSJpcy1pbi1pbnRyby1vZmZlci1wZXJpb2QiID0gImZhbHNlIjsKCSJwdXJjaGFzZS1kYXRlLW1zIiA9ICIxNTI5ODMxOTM0MDAwIjsKCSJleHBpcmVzLWRhdGUtZm9ybWF0dGVkLXBzdCIgPSAiMjAxOC0wNi0yNCAwMjo0ODo1NCBBbWVyaWNhL0xvc19BbmdlbGVzIjsKCSJpcy10cmlhbC1wZXJpb2QiID0gImZhbHNlIjsKCSJpdGVtLWlkIiA9ICIxNDAxMTgyODI4IjsKCSJ1bmlxdWUtaWRlbnRpZmllciIgPSAiNDZmYjdiZjI2NjNjYTBjN2M4MzJmMDI2OWZhYjJmNjc5YTI5MjdiMiI7Cgkib3JpZ2luYWwtdHJhbnNhY3Rpb24taWQiID0gIjEwMDAwMDA0MTA0MDQ2NzYiOwoJImV4cGlyZXMtZGF0ZSIgPSAiMTUyOTgzMzczNDAwMCI7CgkidHJhbnNhY3Rpb24taWQiID0gIjEwMDAwMDA0MTA0MDUyODgiOwoJImJ2cnMiID0gIjUiOwoJIndlYi1vcmRlci1saW5lLWl0ZW0taWQiID0gIjEwMDAwMDAwMzkyMzAyMzEiOwoJInZlcnNpb24tZXh0ZXJuYWwtaWRlbnRpZmllciIgPSAiMCI7CgkiYmlkIiA9ICJjb20udG0uSXdhbnRZb3UiOwoJInByb2R1Y3QtaWQiID0gImltaXNzeW91MDAzIjsKCSJwdXJjaGFzZS1kYXRlIiA9ICIyMDE4LTA2LTI0IDA5OjE4OjU0IEV0Yy9HTVQiOwoJInB1cmNoYXNlLWRhdGUtcHN0IiA9ICIyMDE4LTA2LTI0IDAyOjE4OjU0IEFtZXJpY2EvTG9zX0FuZ2VsZXMiOwoJIm9yaWdpbmFsLXB1cmNoYXNlLWRhdGUiID0gIjIwMTgtMDYtMjQgMDk6MTg6NTUgRXRjL0dNVCI7Cn0%3D%22%3B%0A%09%22environment%22%20%3D%20%22Sandbox%22%3B%0A%09%22pod%22%20%3D%20%22100%22%3B%0A%09%22signing-status%22%20%3D%20%220%22%3B%0A%7D";
 */
- (NSString *)encodeString:(NSString *)unencodedString {
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                     kCFAllocatorDefault, (CFStringRef) unencodedString, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    return encodedString;
}

- (NSError *)argumentError {
    NSError *error = [NSError errorWithDomain:NSArgumentDomain
                                         code:1404
                                     userInfo:@{
                                                NSLocalizedDescriptionKey: @"Error Argument"
                                                }];
    return error;
}


- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
