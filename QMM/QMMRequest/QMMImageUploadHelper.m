//
//  QMMImageUploadHelper.m
//  QMM
//
//  Created by Joseph Koh on 2018/11/8.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMImageUploadHelper.h"
#import "YSRequestManager.h"

@interface QMMImageUploadHelper ()

@property (nonatomic, copy) void(^singleSuccessBlock)(NSString *imgURL);
@property (nonatomic, copy) void(^singleFailureBlock)(NSError *error);

@end

@implementation QMMImageUploadHelper


+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static QMMImageUploadHelper *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[QMMImageUploadHelper alloc] init];
    });
    return instance;
}


- (void)uploadImagesSignalWithImages:(NSArray<UIImage *> *)images
                    withSuccessBlock:(void(^)(NSArray *imgURLs))successBlock
                         failreBlock:(void(^)(NSError *error))failureBlock {
    
    [[YSRequestManager shareManager].sessionManager POST:@""
                                              parameters:[@{} decodeWithAPI:API_UPLOADAVATAR]
                               constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                   
                                   for (int i=0; i< images.count; i++)
                                   {
                                       
                                       NSData *imagedata = [self compressImage:[images objectAtIndex:i]];
                                       NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                       formatter.dateFormat =@"yyyyMMddHHmmss";
                                       NSString *str = [formatter stringFromDate:[NSDate date]];
                                       NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str,(arc4random() % 100001) + 500 ];
                                       [formData appendPartWithFileData:imagedata
                                                                   name:@"file"
                                                               fileName:fileName
                                                               mimeType:@"image/jpeg"];
                                   }
                                   
                                   
                               } progress:^(NSProgress * _Nonnull uploadProgress) {
                                   
                               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   
                                   
                                   int code  = [responseObject[@"code"] intValue];
                                   if(code==0)
                                   {
                                       successBlock(responseObject[@"data"]);
                                       NSLog(@"ok");
                                   }
                                   else
                                   {
                                       
                                       NSNumber *errorCode = [NSNumber numberWithInt: code];
                                       NSDictionary *errorInfo = @{
                                                                   NSLocalizedDescriptionKey: responseObject[@"msg"],
                                                                   NSLocalizedFailureReasonErrorKey : errorCode
                                                                   };
                                       NSError *error = [NSError errorWithDomain:APP_ERROR_DOMAIN code:code userInfo:errorInfo];
                                       if (failureBlock) {
                                           failureBlock(error);
                                       }
                                   }
                                   
                                   
                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                   
                                   failureBlock(error);
                                   NSLog(@"failed");
                               }];
    
    
    
    
}




- (void)uploadImagesSignalWithImagesWithIdentify:(NSArray<UIImage *> *)images
                                withSuccessBlock:(void(^)(YSResponseModel* model))successBlock
                                     failreBlock:(void(^)(NSError *error))failureBlock
{
    
    
    [[YSRequestManager shareManager].sessionManager POST:@""
                                              parameters:[@{} decodeWithAPI:API_UPLOADIDENTIFYPICTURE]
                               constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i=0; i< images.count; i++)
        {
            
            NSData *imagedata = [self compressImage:[images objectAtIndex:i]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str,(arc4random() % 100001) + 500 ];
            [formData appendPartWithFileData:imagedata
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        int code = [responseObject[@"code"] intValue];
        if(code ==0)
        {
            YSResponseModel * model =[YSResponseModel new];
            model.data = responseObject[@"data"];
            model.msg =responseObject[@"msg"];
            model.encode = responseObject[@"code"];
            successBlock(model);
        }
        else
        {
            
            NSNumber *errorCode = [NSNumber numberWithInt: code];
            NSDictionary *errorInfo = @{
                                        NSLocalizedDescriptionKey: responseObject[@"msg"],
                                        NSLocalizedFailureReasonErrorKey : errorCode
                                        };
            NSError *error = [NSError errorWithDomain:APP_ERROR_DOMAIN code:code userInfo:errorInfo];
            if (failureBlock) {
                failureBlock(error);
            }
        }
        NSLog(@"ok");
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error);
        NSLog(@"failed");
    }];
    
    
    
    
}



- (void)uploadImagesSignalWithImagesWithShowPhotos:(NSArray<UIImage *> *)images
                                  withSuccessBlock:(void(^)(YSResponseModel *model))successBlock
                                       failreBlock:(void(^)(NSError *error))failureBlock
{
    
    
    [[YSRequestManager shareManager].sessionManager POST:@""
                                              parameters:[@{} decodeWithAPI:API_UPLOADSHOWPHOTOS]
                               constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i=0; i< images.count; i++)
        {
            
            NSData *imagedata = [self compressImage:[images objectAtIndex:i]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str,(arc4random() % 100001) + 500 ];
            [formData appendPartWithFileData:imagedata
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        int code = [responseObject[@"code"] intValue];
        if(code ==0)
        {
            YSResponseModel * model =[YSResponseModel new];
            model.data = responseObject[@"data"];
            model.msg =responseObject[@"msg"];
            model.encode = responseObject[@"code"];
            successBlock(model);
        }
        else
        {
            
            NSNumber *errorCode = [NSNumber numberWithInt: code];
            NSDictionary *errorInfo = @{
                                        NSLocalizedDescriptionKey: responseObject[@"msg"],
                                        NSLocalizedFailureReasonErrorKey : errorCode
                                        };
            NSError *error = [NSError errorWithDomain:APP_ERROR_DOMAIN code:code userInfo:errorInfo];
            if (failureBlock) {
                failureBlock(error);
            }
        }
        NSLog(@"ok");
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
- (void)uploadImagesAndReportSignalWithImages:(NSArray<UIImage *> *)images parms:(NSDictionary*)params
                             withSuccessBlock:(void(^)(NSArray *imgURLs))successBlock
                                  failreBlock:(void(^)(NSError *error))failureBlock
{
    
    
    [[YSRequestManager shareManager].sessionManager POST:@""
                                              parameters:[params decodeWithAPI:API_REPORT]
                               constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i=0; i< images.count; i++)
        {
            
            NSData *imagedata = [self compressImage:[images objectAtIndex:i]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str,(arc4random() % 100001) + 500 ];
            [formData appendPartWithFileData:imagedata
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        int code  = [responseObject[@"code"] intValue];
        if(code==0)
        {
            successBlock(responseObject[@"data"]);
            NSLog(@"ok");
        }
        else
        {
            
            NSNumber *errorCode = [NSNumber numberWithInt: code];
            NSDictionary *errorInfo = @{
                                        NSLocalizedDescriptionKey: responseObject[@"msg"],
                                        NSLocalizedFailureReasonErrorKey : errorCode
                                        };
            NSError *error = [NSError errorWithDomain:APP_ERROR_DOMAIN code:code userInfo:errorInfo];
            if (failureBlock) {
                failureBlock(error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error);
        NSLog(@"failed");
    }];
    
    
    
    
}



@end
