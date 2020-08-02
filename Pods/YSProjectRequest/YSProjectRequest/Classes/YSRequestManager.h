//
//  YSRequestManager.h
//  MyProject
//
//  Created by Joseph Gao on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "YSRequestInfoConfig.h"

typedef void(^RequestSuccessBlock)(NSURLSessionDataTask *task, id response);
typedef void(^RequestFailureBlock)(NSURLSessionDataTask *task, NSError *error);
typedef void(^RequestTokenInvalidBlock)(NSURLSessionDataTask *task, id response, NSError *error);

@interface YSRequestManager : NSObject

/// 本地时间和服务器时间差
@property (nonatomic, copy) NSString *time_diff;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

+ (instancetype)shareManager;



/**
 数据请求封装库

 @param url 请求的URL字符串
 @param params 请求参数, 没有传nil
 @param requestType 数据请求类型
 @param invalidToken token过期操作回调
 @param success 请求成功回调
 @param failure 请求失败回调
 @return NSURLSessionDataTask 任务
 */
- (NSURLSessionDataTask *)request:(NSString *)url
                       withParams:(NSDictionary *)params
                      requestType:(YSRequestType)requestType
                        invalidToken:(RequestTokenInvalidBlock)invalidToken
                             success:(RequestSuccessBlock)success
                             failure:(RequestFailureBlock)failure;


/*
 *  上传文件请求
 *
 *  url      : 接口地址
 *  datas    : 上传文件list (PS: 请封装成WDUploadFile的List)
 *  params   : 接口传参
 *  success  : 接口成功的回调
 *  failure  : 接口失败的回调
 *  返回      : NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)requestUploadFile:(NSString *)url
                                      files:(NSArray *)datas
                                 parameters:(NSDictionary *)params
                               invalidToken:(RequestTokenInvalidBlock)invalidToken
                                    success:(RequestSuccessBlock)success
                                    failure:(RequestFailureBlock)failure;

@end
