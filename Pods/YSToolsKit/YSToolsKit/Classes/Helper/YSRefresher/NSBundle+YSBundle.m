//
//  NSBundle+YSBundle.m
//  YSHelper
//
//  Created by Joseph Koh on 2018/5/14.
//

#import "NSBundle+YSBundle.h"

@implementation NSBundle (YSBundle)

+ (UIImage *)ys_imageNamed:(NSString *)name ofType:(nullable NSString *)type {
    NSBundle *b = [NSBundle bundleForClass:NSClassFromString(@"YSBaseComponent")];
    NSString *path = [NSString stringWithFormat:@"%@/Frameworks/YSBaseComponent.framework/YSBaseComponent.bundle", b.resourcePath];
    NSBundle *bundle = [NSBundle bundleWithURL:[NSURL fileURLWithPath:path]];
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@", name, type]
                              inBundle:bundle
         compatibleWithTraitCollection:nil];
    
    return img;
}

@end
