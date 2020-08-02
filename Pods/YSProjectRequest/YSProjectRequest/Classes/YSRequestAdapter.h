//
//  YSRequestAdapter.h
//  MyProject
//
//  Created by Joseph Gao on 2017/5/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSRequestInfoConfig.h"
#import "ReactiveObjC.h"

/// 数据请求信号封装库, 直接调用类方法
@interface YSRequestAdapter : NSObject

/**
 数据请求信号封装库
 
 @param url 请求的URL字符串
 @param params 请求参数, 没有传nil
 @param requestType 数据请求类型, 枚举值
 @param responseType 响应的数据类型, 枚举值
 @param responseClass 响应的数据的类, class类型
 @return 数据请求信号
 */
+ (RACSignal *)requestSignalWithURL:(NSString *)url
                             params:(NSDictionary *)params
                        requestType:(YSRequestType)requestType
                       responseType:(YSResponseType)responseType
                      responseClass:(Class)responseClass;



/**
 上传图片到七牛服务器中

 @param images 图片列表
 @return 上传数据的信号
 */
+ (RACSignal *)uploadImagesSignalWithImages:(NSArray *)images;


/**
 封装SDWebImage下载图片

 @param url 图片地址
 @param key 存储图片的key, 一般用图片的url
 @return 下载操作信号
 */
+ (RACSignal *)downloadImageSignalWithURL:(NSString *)url
                                      key:(NSString *)key;

@end
