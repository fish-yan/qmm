//
//  QMMImageUploadHelper.h
//  QMM
//
//  Created by Joseph Koh on 2018/11/8.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMMImageUploadHelper : NSObject

+ (instancetype)shareInstance;


- (void)uploadImagesSignalWithImages:(NSArray<UIImage *> *)images
                    withSuccessBlock:(void(^)(NSArray *imgURLs))successBlock
                         failreBlock:(void(^)(NSError *error))failureBlock;
- (void)uploadImagesSignalWithImagesWithIdentify:(NSArray<UIImage *> *)images
                                withSuccessBlock:(void(^)(YSResponseModel *model))successBlock
                                     failreBlock:(void(^)(NSError *error))failureBlock;


- (void)uploadImagesSignalWithImagesWithShowPhotos:(NSArray<UIImage *> *)images
                                  withSuccessBlock:(void(^)(YSResponseModel *model))successBlock
                                       failreBlock:(void(^)(NSError *error))failureBlock;

- (void)uploadImagesAndReportSignalWithImages:(NSArray<UIImage *> *)images parms:(NSDictionary*)params
                             withSuccessBlock:(void(^)(NSArray *imgURLs))successBlock
                                  failreBlock:(void(^)(NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
