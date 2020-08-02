//
//  YSRequestEnum.h
//  Pods
//
//  Created by Joseph Koh on 2018/10/10.
//

#ifndef YSRequestEnum_h
#define YSRequestEnum_h


typedef NS_ENUM(NSInteger, YSRequestType) {
    YSRequestTypeGET = 0,   // GET 请求
    YSRequestTypePOST,      // POST 请求
    YSRequestTypeDELETE,    // DELETE 请求
    YSRequestTypePUT,       // PUT 请求
    YSRequestTypeUPLOAD     // 上传数据请求
};

typedef NS_ENUM(NSInteger, YSResponseType) {
    YSResponseTypeOriginal = 0,   // 原始类型,不做转换
    YSResponseTypeObject,         // 请求类型为对象
    YSResponseTypeList,           // 请求类型为列表(列表有固定的接口格式)
    YSResponseTypeMessage,        // 请求类型为消息类型,(返回为Dictionary格式)
};

typedef NS_ENUM(NSInteger, RequestResultType) {
    RequestResultTypeEmpty = 100,    // 空数据
    RequestResultTypeNotReachable,   // 没有网络
    RequestResultTypeError,          // 错误数据
    RequestResultTypeSuccess         // 成功数据
};


typedef NS_ENUM(NSInteger, YSEnvironmentType) {
    YSEnvironmentTypeProduction,
    YSEnvironmentTypePreRelease,
    YSEnvironmentTypeTest,
    YSEnvironmentTypeDevelopment,
    YSEnvironmentTypeOther,
};


#endif /* YSRequestEnum_h */
