//
//  YSRequestHeaderManager.h
//  MyProject
//
//  Created by Joseph Gao on 2017/5/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//
/**
    Request的Header、签名类
 */
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "YSRequestEnum.h"


@interface YSRequestHeaderManager : NSObject

/// 接口请求头入参,
@property (nonatomic, strong, nullable) NSDictionary *headerDict;

/**
 *  为接口请求、WebView的Request添加Header
 *
 *  @param  request : 所要添加Header的Request
 *  @param  params  : request传参，生成签名的时候需要用到
 *  @param  method  : request方法，如果是POST方法，生成签名的时候需要把Params转成JSONString，反之，签名的时候直接拼接
 *  @param  url     : 请求路径
 *  @param  isURLHaveAPITag   : 是否是后台接口请求
 */
- (void)addHeader:(id)requestSerializer
           params:(NSDictionary *)params
           method:(YSRequestType)requestType
              url:(NSString *)url
  isURLHaveAPITag:(BOOL)isURLHaveAPITag;

@end
