//
//  QMMImageUploadHelper.h
//  QMM
//
//  Created by Joseph Koh on 2018/11/8.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMMImageUploadHelper : NSObject

+ (instancetype)shareInstance;


- (void)uploadImages:(NSArray<UIImage *> *)images
    withSuccessBlock:(void(^)(YSResponseModel *model))successBlock
         failreBlock:(void(^)(NSError *error))failureBlock;

- (void)uploadIdentifyImages:(NSArray<UIImage *> *)images
            withSuccessBlock:(void(^)(YSResponseModel *model))successBlock
                 failreBlock:(void(^)(NSError *error))failureBlock;


- (void)uploadUserShowPhotos:(NSArray<UIImage *> *)images
            withSuccessBlock:(void(^)(YSResponseModel *model))successBlock
                 failreBlock:(void(^)(NSError *error))failureBlock;

- (void)uploadImagesAndReportSignalWithImages:(NSArray<UIImage *> *)images
                                        parms:(NSDictionary*)params
                             withSuccessBlock:(void(^)(YSResponseModel *model))successBlock
                                  failreBlock:(void(^)(NSError *error))failureBlock;

@end
