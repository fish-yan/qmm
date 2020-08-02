//
//  NSBundle+YSImage.m
//  Pods
//
//  Created by Joseph Koh on 2018/5/17.
//

#import "NSBundle+YSImage.h"

@implementation NSBundle (YSImage)

+ (UIImage *)imageWithName:(NSString *)name type:(YSImageType)type inBundle:(NSString *)bundleName {
    if (!name.length || !bundleName.length) return nil;
    
    NSBundle *b = [NSBundle bundleForClass:NSClassFromString(bundleName)];
    NSString *path = [NSString stringWithFormat:@"%@/Frameworks/%@.framework/%@.bundle", b.resourcePath, bundleName, bundleName];
    NSBundle *bundle = [NSBundle bundleWithURL:[NSURL fileURLWithPath:path]];
    NSString *imageName = [NSString stringWithFormat:@"%@.%@", name, type == YSImageTypePNG ? @"png" : @"jpeg"];
    UIImage *image = [UIImage imageNamed:imageName
                              inBundle:bundle
         compatibleWithTraitCollection:nil];
    
    return image;
}

@end
