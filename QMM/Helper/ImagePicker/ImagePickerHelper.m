//
//  ImagePickerHelper.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "ImagePickerHelper.h"
#import <TZImagePickerController/TZImageManager.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ImagePickerHelper ()
<TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, weak) UIViewController *inVC;

@property (nonatomic, copy) void(^uploadResultHandler)(NSArray<UIImage *> *imgs, NSArray *imgURLs, NSError *error);
@property (nonatomic, copy) void(^selectedHandler)(NSArray<UIImage *> *imgs);
@property (nonatomic, assign) BOOL needUpload;

@end


@implementation ImagePickerHelper


#pragma mark - Image

- (void)showImagePickerInVC:(UIViewController *)inVC
            selectedHandler:(void(^)(NSArray<UIImage *> *imgs))selectedHandler {
    self.needUpload = NO;
    self.inVC = inVC;
    self.selectedHandler = selectedHandler;
    [self showAddNewImageSheet];
}

- (void)showImagePickerInVC:(UIViewController *)inVC
              uploadHandler:(void(^)(NSArray<UIImage *> *imgs, NSArray<NSString *> *imgURLs, NSError *error))uploadHandler{
    self.needUpload = YES;
    self.inVC = inVC;
    self.uploadResultHandler = uploadHandler;
    [self showAddNewImageSheet];
}

- (void)showAddNewImageSheet {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:self.tips
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"拍照"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [self takePhoto];
                                             }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"相册"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [self requestPhoto];
                                             }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消"
                                               style:UIAlertActionStyleCancel
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 
                                             }]];
    
    [self.inVC presentViewController:alertC animated:YES completion:NULL];
}


- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)) {
        id cancelBlock = ^() {
            
        };
        id sureBlock = ^() {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        };
        
        
        [YSMediator presentToViewController:@"AlertViewController"
                                 withParams:@{
                                              @"message": @"请在iPhone的\"设置-隐私-相机\"中允许访问相机",
                                              @"type": @2,
                                              @"rightButtonTitle": @"设置",
                                              @"rightTitleColor": [UIColor tc3Color],
                                              @"cancelBlock": cancelBlock,
                                              @"sureBlock": sureBlock
                                              }
                                   animated:YES
                                   callBack:nil];
        
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                     if (granted) {
                                         dispatch_sync(dispatch_get_main_queue(), ^{
                                             [self takePhoto];
                                         });
                                     }
                                 }];
        // 拍照之前还需要检查相册权限
    } else if (authStatus == AVAuthorizationStatusDenied) {    // 已被拒绝，没有相册权限，将无法保存拍的照片
        
        id cancelBlock = ^() {
            
        };
        id sureBlock = ^() {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        };
        
        
        [YSMediator presentToViewController:@"HYAlertViewController"
                                 withParams:@{
                                              @"message": @"请在iPhone的\"设置-隐私-相机\"中允许访问相机",
                                              @"type": @2,
                                              @"rightButtonTitle": @"设置",
                                              @"rightTitleColor": [UIColor tc3Color],
                                              @"cancelBlock": cancelBlock,
                                              @"sureBlock": sureBlock
                                              }
                                   animated:YES
                                   callBack:nil];
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {    // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType    = sourceType;
        self.imagePicker.allowsEditing = YES;
        _imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.inVC presentViewController:self.imagePicker animated:YES completion:nil];
        
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)pushTZImagePickerController {
    /*
     PHAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
     PHAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
     // The user cannot change this application’s status, possibly due to active restrictions
     //   such as parental controls being in place.
     PHAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
     PHAuthorizationStatusAuthorized
     */
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusDenied) {
        id cancelBlock = ^() {
            
        };
        id sureBlock = ^() {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        };
        
        
        [YSMediator presentToViewController:@"AlertViewController"
                                 withParams:@{
                                              @"message": @"请在iPhone的\"设置-隐私-相机\"中允许访问相机",
                                              @"type": @2,
                                              @"rightButtonTitle": @"设置",
                                              @"rightTitleColor": [UIColor tc3Color],
                                              @"cancelBlock": cancelBlock,
                                              @"sureBlock": sureBlock
                                              }
                                   animated:YES
                                   callBack:nil];
        
        
        return;
    } else if (authStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self requestPhoto];
        }];
    } else {
        [self requestPhoto];
    }
}
- (void)requestPhoto {
    // 剩余数量
    NSInteger number = 0;
    NSInteger cnt = 1;
    switch (self.uploadType) {
        case ImageUploadTypeAvatar:
            cnt = 1;
            break;
        case ImageUploadTypeShowPic:
            cnt = number;
            break;
        case ImageUploadTypeIdentify:
            cnt = 1;
            break;
        default:
            break;
    }
    
    TZImagePickerController *imagePickerVc =
    [[TZImagePickerController alloc] initWithMaxImagesCount:cnt
                                               columnNumber:4
                                                   delegate:self
                                          pushPhotoPickerVc:YES];
    
    imagePickerVc.allowTakePicture = NO;
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    imagePickerVc.navigationBar.barTintColor = [UIColor tc3Color];
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    imagePickerVc.oKButtonTitleColorNormal =
    [[UIColor alloc] initWithRed:28 / 255.0 green:170 / 255.0 blue:9 / 255.0 alpha:1];
    imagePickerVc.naviTitleColor = [UIColor whiteColor];
    
    imagePickerVc.barItemTextColor          = [UIColor whiteColor];
    imagePickerVc.navigationBar.translucent = NO;
    //    [imagePickerVc.navigationBar setBackgroundImage:[self barBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    
    
    imagePickerVc.allowPickingImage         = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif           = YES;
    
    imagePickerVc.showSelectBtn      = YES;
    //imagePickerVc.isStatusBarDefault = YES;
    imagePickerVc.allowCrop          = YES;
    CGFloat imgW                     = SCREEN_WIDTH;
    imagePickerVc.cropRect           = CGRectMake((SCREEN_WIDTH - imgW) / 2, (SCREEN_HEIGHT - imgW) / 2, imgW, imgW);
    
    
    @weakify(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        if (!self.needUpload) {
            if (self.selectedHandler) {
                self.selectedHandler(photos);
            }
            return ;
        }
        [self uploadPhotos:photos];
    }];
    
    [self.inVC presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSArray *photos = @[image];
        if (!self.needUpload) {
            if (self.selectedHandler) {
                self.selectedHandler(photos);
            }
            return ;
        }
        
        [self uploadPhotos:photos];
    }
}

- (void)uploadPhotos:(NSArray *)photos {
    @weakify(self);
    [self uploadPhotos:photos withResult:^(NSArray *imgURLs, NSError *error) {
        @strongify(self);
        if (self.uploadResultHandler) {
            self.uploadResultHandler(photos, imgURLs, error);
        }
    }];
    
   
}

- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    // 2.图片位置信息
    //    if (iOS8Later) {
    //        for (PHAsset *phAsset in assets) {
    //            NSLog(@"location:%@", phAsset.location);
    //        }
    //    }
}

- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker               = [[UIImagePickerController alloc] init];
        _imagePicker.delegate      = self;
        _imagePicker.allowsEditing = YES;
        // set appearance / 改变相册选择页的导航栏外观
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem   = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePicker;
}


- (void)uploadPhotos:(NSArray *)photos withResult:(void(^)(NSArray *imgURLs, NSError *error))result {
    [YSProgressHUD showInView:self.inVC.view];
    [[QMMImageUploadHelper shareInstance] uploadImages:photos
                                                     withSuccessBlock:^(YSResponseModel *m) {
                                                         [YSProgressHUD hiddenHUD];
                                                         if (result) {
                                                             result(m.data, nil);
                                                         }
                                                     }
                                                          failreBlock:^(NSError *error) {
                                                              [YSProgressHUD showTips:error.localizedDescription];
                                                              if (result) {
                                                                  result(nil, error);
                                                              }
                                                          }];
    
}
@end
