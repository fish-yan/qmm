//
//  NSBundle+YSImage.h
//  Pods
//
//  Created by Joseph Koh on 2018/5/17.
//

#import <UIKit/UIKit.h>

@interface NSBundle (YSImage)

typedef NS_ENUM(NSInteger, YSImageType) {
    YSImageTypePNG,
    YSImageTypeJPEG,
};


/**
 从bundle中获取图片,组件化后图片不存在mainBundle中, 不能直接通过 +imageName: 获得

 @param name 图片名字字符串, 不能为空
 @param type 图片类型,png 还是jpeg
 @param bundleName bundle名称,组件的话一般是组件类的名称
 @return 图片, 可能为空
 */
+ (UIImage *)imageWithName:(NSString *)name type:(YSImageType)type inBundle:(NSString *)bundleName;

@end
