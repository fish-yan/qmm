//
//  YSRequestInfoConfig.h
//  MyProject
//
//  Created by Joseph Gao on 2017/5/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSRequestEnum.h"
#import "YSRequestHeaderManager.h"

@interface YSRequestInfoConfig : NSObject

/// 服务器Base URL
@property (nonatomic, copy) NSString *baseURL;
/// H5页面BaseURL
@property (nonatomic, copy) NSString *BaseWebURL;
/// 服务器url路径
@property (nonatomic, copy) NSString *urlPath;


/// 生产环境IP
@property (nonatomic, copy) NSString *productionIP;
/// 预发布环境IP
@property (nonatomic, copy) NSString *preReleaseIP;
/// 测试环境IP
@property (nonatomic, copy) NSString *testIP;
/// 开发环境IP
@property (nonatomic, copy) NSString *developmentIP;
/// 自定义环境IP
@property (nonatomic, copy) NSString *customIP;

/// 设置contentType, 默认是 application/json;charset=UTF-8
@property (nonatomic, copy) NSString *contentType;

/// 设置默认使用的环境
@property (nonatomic, assign) YSEnvironmentType defaultEnviroment;

@property (nonatomic, strong) YSRequestHeaderManager *headerMgr;

/// 接口请求cer证书路径
@property (nonatomic, strong, nullable) NSArray *cerPaths;


/// 请求的公钥
@property (nonatomic, copy) NSString *publicKey;
/// 响应数据解密私钥
@property (nonatomic, copy) NSString *privateKey;

+ (instancetype)shareConfig;

+ (void)configServices:(void(^)(YSRequestInfoConfig *config))services;

- (void)updateEnvironment:(YSEnvironmentType)enviromentType;

/// 当前使用的服务ip地址
@property (nonatomic, copy, readonly) NSString *serverIP;



@end
