//
//  YSQiniuUploadHelper.h
//
//  Created by Joseph Gao on 2017/6/8.
//  Copyright © 2017年 WondersGroup.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YSQiniuUploadHelper : NSObject

+ (instancetype)shareInstance;

- (void)registerWithFetchAPI:(NSString *)api andToken:(NSString *)token;

/**
 通过本地生成uploadToken的方式上传图片

 @param scope 七牛开发中心 存储空间名称 的名称
 @param accessKey 七牛上传的 accessKey, 在个人面板 > 秘钥管理 里面查看
 @param secretKey 七牛上传的 secretKey, 在个人面板 > 秘钥管理 里面查看
 @param domain 图片绑定绑定的域名
 */
- (void)registerWithScope:(NSString *)scope
                accessKey:(NSString *)accessKey
             andSecretKey:(NSString *)secretKey
                   domain:(NSString *)domain;

- (void)uploadImages:(NSArray<UIImage *> *)images
    withSuccessBlock:(void(^)(NSArray *imgURLs))successBlock
         failreBlock:(void(^)(NSError *error))failureBlock;
@end
