//
//  YSRequestManager.m
//  MyProject
//
//  Created by Joseph Gao on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSRequestManager.h"
#import "AFNetworking.h"
#import "HappyDNS.h"
#import "YSSecurityPolicy.h"
#import "YSRequestHeaderManager.h"
#import "YSResponseManager+Check.h"


@implementation YSRequestManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static YSRequestManager *shareMgr = nil;
    dispatch_once(&onceToken, ^{
        shareMgr = [[YSRequestManager alloc] init];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // request
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
       
        YSRequestInfoConfig *requestConfig = [YSRequestInfoConfig shareConfig];
        shareMgr.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:requestConfig.baseURL]
                                                           sessionConfiguration:configuration];
        
        
        shareMgr.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //shareMgr.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        shareMgr.sessionManager.requestSerializer.timeoutInterval = 30.0; // 设置超时时间为30秒
        
        if (requestConfig.contentType.length) {
            [shareMgr.sessionManager.requestSerializer setValue:requestConfig.contentType
                                             forHTTPHeaderField:@"Content-Type"];
        }
        else {
            [shareMgr.sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
        }

        [shareMgr.sessionManager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
        
        // security
        shareMgr.sessionManager.securityPolicy = [YSSecurityPolicy securityPolicyWithCertificatesPath:requestConfig.cerPaths];
        
        // response
        [shareMgr.sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:
                                                                               @"application/json",
                                                                               @"charset=UTF-8",
                                                                               @"text/plain",
                                                                               @"text/javascript",
                                                                               @"text/html",
                                                                               @"image/*",
                                                                               nil]];
    });

    return shareMgr;
}




- (NSURLSessionDataTask *)request:(NSString *)url
                       withParams:(NSDictionary *)params
                      requestType:(YSRequestType)requestType
                     invalidToken:(RequestTokenInvalidBlock)invalidToken
                          success:(RequestSuccessBlock)success
                          failure:(RequestFailureBlock)failure {
    NSLog(@"Request_POST:\nURL: %@\nParams: %@", url, params);
    
    __weak typeof(self) weakSelf = self;
    RequestSuccessBlock successBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        __strong typeof(self) self = weakSelf;        
        [self responseComplete:responseObject
                      dataTask:task
                  invalidToken:invalidToken
                       success:success
                       failure:failure];
    };
    
    RequestFailureBlock failureBlock = ^(NSURLSessionDataTask *task, NSError *error){
        if (failure) {
            failure(task, error);
        }
    };
    
    RequestTokenInvalidBlock tokenInvalidBlock = ^(NSURLSessionDataTask *task, id response, NSError *error){
        if (invalidToken) {
            invalidToken(task, response, error);
        }
    };
    
    switch (requestType) {
        case YSRequestTypeGET: {
            return [self requestGET:url
                             params:params
                       invalidToken:tokenInvalidBlock
                            success:successBlock
                            failure:failureBlock];
            break;
        }
        case YSRequestTypePOST: {
            return [self requestPOST:url
                              params:params
                        invalidToken:tokenInvalidBlock
                             success:successBlock
                             failure:failureBlock];
            break;
        }
        case YSRequestTypeDELETE: {
            return [self requestDELETE:url
                                params:params
                          invalidToken:tokenInvalidBlock
                               success:successBlock
                               failure:failureBlock];
            break;
        }
        case YSRequestTypePUT: {
            return [self requestPUT:url
                              params:params
                        invalidToken:tokenInvalidBlock
                             success:successBlock
                             failure:failureBlock];
            break;
        }
        default:
            break;
    }
    
    return nil;
}


#pragma mark - 处理请求

- (void)responseComplete:(id)response
                dataTask:(NSURLSessionDataTask *)task
            invalidToken:(RequestTokenInvalidBlock)invalid
                 success:(RequestSuccessBlock)success
                 failure:(RequestFailureBlock)failure {
    // 检查请求是否失败
    // 如果 响应的code == 0 就表示响应成功
    // 如果 响应失败 则自定义错误信息
    NSError *error = [YSResponseManager checkResponseObject:response];
    if (error) {
        // 检查请求时 token 是否已经过期
        if ([YSResponseManager isInvalidToken:error] ) {
            if (invalid) {
                invalid(task, response, error);
            }
        }
        else {  // 接口请求失败
            if (failure) {
                // 本地时间和服务器时间差超过10分钟
                if ((int)error.code == 16 && response[@"time_diff"]) {
                    self.time_diff = [NSString stringWithFormat:@"%@", response[@"time_diff"]];
                }
                if (failure) {
                    failure(task, error);
                }
            }
        }
    }
    else {
        if (success) {
            success(task, response);
        }
    }
}


#pragma mark - GET请求

- (NSURLSessionDataTask *)requestGET:(NSString *)url
                              params:(NSDictionary *)params
                        invalidToken:(RequestTokenInvalidBlock)invalidToken
                             success:(RequestSuccessBlock)success
                             failure:(RequestFailureBlock)failure {
    // 添加请求头信息
    [[YSRequestInfoConfig shareConfig].headerMgr addHeader:self.sessionManager.requestSerializer
                                                    params:params
                                                    method:YSRequestTypeGET
                                                       url:url
                                           isURLHaveAPITag:YES];
    return [self.sessionManager GET:url parameters:params progress:NULL success:success failure:failure];
}


#pragma mark - POST请求

- (NSURLSessionDataTask *)requestPOST:(NSString *)url
                               params:(NSDictionary *)params
                         invalidToken:(RequestTokenInvalidBlock)invalidToken
                              success:(RequestSuccessBlock)success
                              failure:(RequestFailureBlock)failure {
    // 添加请求头信息
    [[YSRequestInfoConfig shareConfig].headerMgr addHeader:self.sessionManager.requestSerializer
                                                    params:params
                                                    method:YSRequestTypePOST
                                                       url:url
                                           isURLHaveAPITag:YES];
    
    return [self.sessionManager POST:url parameters:params progress:NULL success:success failure:failure];
}


#pragma mark - DELETE请求

- (NSURLSessionDataTask *)requestDELETE:(NSString *)url
                                 params:(NSDictionary *)params
                           invalidToken:(RequestTokenInvalidBlock)invalidToken
                                success:(RequestSuccessBlock)success
                                failure:(RequestFailureBlock)failure {
    // 添加请求头信息
    [[YSRequestInfoConfig shareConfig].headerMgr addHeader:self.sessionManager.requestSerializer
                                                    params:params
                                                    method:YSRequestTypeDELETE
                                                       url:url
                                           isURLHaveAPITag:YES];

    return [self.sessionManager DELETE:url parameters:params success:success failure:false];
}


#pragma mark - PUT请求

- (NSURLSessionDataTask *)requestPUT:(NSString *)url
                              params:(NSDictionary *)params
                        invalidToken:(RequestTokenInvalidBlock)invalidToken
                             success:(RequestSuccessBlock)success
                             failure:(RequestFailureBlock)failure {
    // 添加请求头信息
    [[YSRequestInfoConfig shareConfig].headerMgr addHeader:self.sessionManager.requestSerializer
                                                    params:params
                                                    method:YSRequestTypePUT
                                                       url:url
                                           isURLHaveAPITag:YES];

    return [self.sessionManager PUT:url parameters:params success:success failure:failure];
}


#pragma mark - 上传文件

- (NSURLSessionDataTask *)requestUploadFile:(NSString *)url
                                      files:(NSArray *)datas
                                 parameters:(NSDictionary *)params
                               invalidToken:(RequestTokenInvalidBlock)invalidToken
                                    success:(RequestSuccessBlock)success
                                    failure:(RequestFailureBlock)failure {
    return nil;
}


@end
