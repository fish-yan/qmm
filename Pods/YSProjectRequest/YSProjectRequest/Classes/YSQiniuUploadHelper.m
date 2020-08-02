//
//  YSQiniuUploadHelper.m
//
//  Created by Joseph Gao on 2017/6/8.
//  Copyright © 2017年 WondersGroup.com. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "QiniuSDK.h"
#import "QNUrlSafeBase64.h"
#import "QN_GTM_Base64.h"

#import "YSQiniuUploadHelper.h"
#import "YSRequestAdapter.h"
#import "YSResponseModel.h"
#import "ReactiveObjC.h"

typedef NS_ENUM(NSInteger, YSQiniuUploadType) {
    YSQiniuUploadTypeToken,
    YSQiniuUploadTypeKey,
};


@interface YSQiniuUploadHelper (CreateToken)

- (NSString *)createToken;

@end


@interface YSQiniuUploadHelper ()

@property (nonatomic, copy) void(^singleSuccessBlock)(NSString *imgURL);
@property (nonatomic, copy) void(^singleFailureBlock)(NSError *error);

@property (nonatomic, copy) NSString *uploadToken;
/// 获取七牛Token
@property (nonatomic, copy) NSString *fetchAPI;
@property (nonatomic, copy) NSString *fetchToken;

@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *accessKey;
@property (nonatomic, copy) NSString *secretKey;
@property (nonatomic, copy) NSString *domain;
/// liveTime则是token的有效时间，以天为单位, 默认30天
@property (nonatomic, assign) NSInteger liveTime;

@property (nonatomic, assign) YSQiniuUploadType uploadType;

@end

@implementation YSQiniuUploadHelper

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static YSQiniuUploadHelper *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[YSQiniuUploadHelper alloc] init];
        instance.liveTime = 30;
    });
    return instance;
}

- (void)registerWithScope:(NSString *)scope
                accessKey:(NSString *)accessKey
             andSecretKey:(NSString *)secretKey
                   domain:(NSString *)domain {
    NSAssert(scope.length != 0 && accessKey.length != 0 && secretKey.length != 0 && domain.length != 0, @"参数不能为空");
    
    self.scope = scope;
    self.accessKey = accessKey;
    self.secretKey = secretKey;
    self.domain = domain;
    self.uploadType = YSQiniuUploadTypeKey;
}

- (void)registerWithFetchAPI:(NSString *)api andToken:(NSString *)token {
    NSAssert(api.length != 0 && token.length != 0, @"参数不能为空");
    
    self.fetchAPI = api;
    self.fetchToken = token;
    self.uploadType = YSQiniuUploadTypeToken;
}

- (void)uploadImages:(NSArray<UIImage *> *)images
    withSuccessBlock:(void(^)(NSArray *imgURLs))successBlock
         failreBlock:(void(^)(NSError *error))failureBlock {
    
    @weakify(self);
    switch (self.uploadType) {
        case YSQiniuUploadTypeToken: {
            [[self fetchUploadTokenSignal] subscribeNext:^(NSDictionary * _Nullable info) {
                @strongify(self);
                self.uploadToken = info[@"token"];
                self.domain = info[@"domain"];
                [self uploadImages:images
                   withUploadToken:self.uploadToken
                     successHandle:successBlock
                     failureHandle:failureBlock];
                
            } error:^(NSError * _Nullable error) {
                NSLog(@"======> 获取七牛token失败!!!");
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
            break;
        }
        case YSQiniuUploadTypeKey: {
            if (!self.uploadToken.length) {
                self.uploadToken = [self createToken];                
            }
            [self uploadImages:images
               withUploadToken:self.uploadToken
                 successHandle:successBlock
                 failureHandle:failureBlock];
            break;
        }
        default:
            break;
    }
    
}


#pragma mark - Pirvate Method
#pragma mark Fetch Token Type

- (void)uploadImages:(NSArray<UIImage *> *)images
     withUploadToken:(NSString *)token
       successHandle:(void(^)(NSArray<NSString *> *imgURLs))successHandler
       failureHandle:(void(^)(NSError *error))failureHandler {
    if (!images || images.count == 0) return;
    
    __block NSMutableArray *imageURLs = [NSMutableArray arrayWithCapacity:images.count];
    __block NSInteger idx = 0;
    
    self.singleFailureBlock = ^(NSError *error) {
        if (failureHandler) {
            failureHandler(error);
        }
        return;
    };
    
    @weakify(self);
    self.singleSuccessBlock = ^(NSString *imgURL) {
        @strongify(self);
        [imageURLs addObject:imgURL];
        idx++;
        
        if (imageURLs.count == images.count) {
            if (successHandler) {
                successHandler(imageURLs);
            }
            return ;
        }
        else {
            [self uploadSingleImage:images[idx]
                     withUploadToke:token
                      successHandle:self.singleSuccessBlock
                      failureHandle:self.singleFailureBlock];
        }
        return;
    };
    
    [self uploadSingleImage:images[0]
             withUploadToke:token
              successHandle:self.singleSuccessBlock
              failureHandle:self.singleFailureBlock];
}

- (void)uploadSingleImage:(UIImage *)img
           withUploadToke:(NSString *)token
            successHandle:(void(^)(NSString *imgURL))successHandler
            failureHandle:(void(^)(NSError *error))failureHandler {
    @weakify(self);
    QNUploadManager *mgr = [[QNUploadManager alloc] init];
    NSString *key = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    [mgr putData:[self compressImage:img]
             key:key
           token:token
        complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            @strongify(self);
            if (resp) {
                NSString *imgURL =  [NSString stringWithFormat: @"http://%@/%@", self.domain, key];
                if (successHandler) {
                    successHandler(imgURL);
                }
            }
            else {
                NSNumber *errorCode = [NSNumber numberWithInt: info.statusCode];
                NSDictionary *errorInfo = @{
                                            NSLocalizedDescriptionKey: @"上传图片失败",
                                            NSLocalizedFailureReasonErrorKey : errorCode
                                            };
                NSError *error = [NSError errorWithDomain:@"com.byterigel.error" code:info.statusCode userInfo:errorInfo];
                if (failureHandler) {
                    failureHandler(error);
                }
            }
            
        }
          option:nil];
}

- (NSData *)compressImage:(UIImage *)image {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 500 * 1024;   // 500kb
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    return imageData;
}


/**
 获取七牛token信号
 
 expires = 3600;
 token = kUCOKS5T5i6ygr-5i7MoqimI-EDl5OegkKwkxctw:egDsAUdaQ7SyTchsLxJ9cNfUUz8=:eyJzY29wZSI6ImhlYWx0aGNsb3VkMiIsImRlYWRsaW5lIjoxNDk2OTI4OTg2fQ==;
 domain = img.wdjky.com;
 */
- (RACSignal *)fetchUploadTokenSignal {
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [[YSRequestAdapter requestSignalWithURL:self.fetchAPI
                                         params:nil
                                    requestType:YSRequestTypeGET
                                   responseType:YSResponseTypeObject
                                  responseClass:nil]
         subscribeNext:^(YSResponseModel * _Nullable x) {
             if (!x.data[@"token"]) {
                 NSError *error = [NSError errorWithDomain:@"com.ipeanut.error"
                                                      code:2345
                                                  userInfo:@{NSLocalizedDescriptionKey : @"获取七牛token为空"}];
                 [subscriber sendError:error];
                 return;
             }
             NSDictionary *info = @{
                                    @"token" : x.data[@"token"] ?: @"",
                                    @"domain" : x.data[@"domain"] ?: @""
                                    };
             [subscriber sendNext:info];
             [subscriber sendCompleted];
         }
         error:^(NSError * _Nullable error) {
             [subscriber sendError:error];
         }];
        
        return nil;
    }];
    
    return signal;
}


- (void)checkTokenHasExpired:(NSString *)token {
    
}

@end




@implementation YSQiniuUploadHelper (CreateToken)

- (NSString *)createToken {
    if (!self.scope.length || !self.accessKey.length || !self.secretKey.length) return nil;
    
    // 将上传策略中的scrop和deadline序列化成json格式
    NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
    [authInfo setObject:self.scope forKey:@"scope"];
    [authInfo setObject:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] + self.liveTime * 24 * 3600]
                 forKey:@"deadline"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    // 对json序列化后的上传策略进行URL安全的base64编码
    NSString *encodedString = [self urlSafeBase64Encode:jsonData];
    // 用secretKey对编码后的上传策略进行HMAC-SHA1加密，并且做安全的base64编码，得到encoded_signed
    NSString *encodedSignedString = [self HMACSHA1:self.secretKey text:encodedString];
    // 将accessKey、encodedSignedString和encodedString拼接，中间用：分开，就是上传的token
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@", self.accessKey, encodedSignedString, encodedString];
    
    return token;
}

- (NSString *)urlSafeBase64Encode:(NSData *)text {
    NSString *base64 = [[NSString alloc] initWithData:[QN_GTM_Base64 encodeData:text] encoding:NSUTF8StringEncoding];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return base64;
}

- (NSString *)HMACSHA1:(NSString *)key text:(NSString *)text {
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [self urlSafeBase64Encode:HMAC];
    
    return hash;
}


@end
