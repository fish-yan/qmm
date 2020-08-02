//
//  QMMImageUploadHelper.m
//  QMM
//
//  Created by Joseph Koh on 2018/11/8.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMImageUploadHelper.h"
#import "YSRequestManager.h"


@implementation QMMImageUploadHelper


+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static QMMImageUploadHelper *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[QMMImageUploadHelper alloc] init];
    });
    return instance;
}


- (void)uploadImages:(NSArray<UIImage *> *)images
                    withSuccessBlock:(void(^)(YSResponseModel* model))successBlock
                         failreBlock:(void(^)(NSError *error))failureBlock {
    [self uploadImages:images params:@{} ofApi:API_UPLOADAVATAR withSuccessBlock:successBlock failureBlock:failureBlock];
    
}




- (void)uploadIdentifyImages:(NSArray<UIImage *> *)images
                                withSuccessBlock:(void(^)(YSResponseModel* model))successBlock
                                     failreBlock:(void(^)(NSError *error))failureBlock {
    [self uploadImages:images params:@{} ofApi:API_UPLOADIDENTIFYPICTURE withSuccessBlock:successBlock failureBlock:failureBlock];
}



- (void)uploadUserShowPhotos:(NSArray<UIImage *> *)images
                                  withSuccessBlock:(void(^)(YSResponseModel *model))successBlock
                                       failreBlock:(void(^)(NSError *error))failureBlock {
    [self uploadImages:images params:@{} ofApi:API_UPLOADSHOWPHOTOS withSuccessBlock:successBlock failureBlock:failureBlock];
}

- (void)uploadImagesAndReportSignalWithImages:(NSArray<UIImage *> *)images parms:(NSDictionary*)params
                             withSuccessBlock:(void(^)(YSResponseModel *model))successBlock
                                  failreBlock:(void(^)(NSError *error))failureBlock {
    [self uploadImages:images params:params ofApi:API_REPORT withSuccessBlock:successBlock failureBlock:failureBlock];
}

- (void)uploadImages:(NSArray *)images params:(NSDictionary *)params ofApi:(NSString *)api withSuccessBlock:(void(^)(YSResponseModel *model))successBlock
         failureBlock:(void(^)(NSError *error))failureBlock {
    
    [[YSRequestManager shareManager].sessionManager POST:@"" parameters:[params decodeWithAPI:api] constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {

        for (int i = 0; i < images.count; i++) {
            NSData *imagedata          = [self compressImage:[images objectAtIndex:i]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat       = @"yyyyMMddHHmmss";
            NSString *str              = [formatter stringFromDate:[NSDate date]];
            NSString *fileName         = [NSString stringWithFormat:@"%@%d.jpg", str, (arc4random() % 100001) + 500];
            [formData appendPartWithFileData:imagedata name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }


    }
    progress:^(NSProgress *_Nonnull uploadProgress) {

    }
    success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        int code = [responseObject[@"code"] intValue];

        if (code == 0) {
            YSResponseModel *model = [YSResponseModel new];
            model.data             = responseObject[@"data"];
            model.msg              = responseObject[@"msg"];
            model.encode           = responseObject[@"code"];
            successBlock(model);
        } else {
            NSNumber *errorCode = [NSNumber numberWithInt:code];
            NSDictionary *errorInfo =
            @{ NSLocalizedDescriptionKey: responseObject[@"msg"],
               NSLocalizedFailureReasonErrorKey: errorCode };
            NSError *error = [NSError errorWithDomain:APP_ERROR_DOMAIN code:code userInfo:errorInfo];
            if (failureBlock) {
                failureBlock(error);
            }
        }
        NSLog(@"ok");

    }
    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

        failureBlock(error);
        NSLog(@"failed");
    }];
}

- (NSData *)compressImage:(UIImage *)image {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 500 * 1024;
    
    NSData *imageData =  UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    return imageData;
}

@end
