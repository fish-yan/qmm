//
//  UIFont+PingFang.m
//  ProjectConfig
//
//  Created by Joseph Koh on 2018/5/23.
//

#import "UIFont+PingFang.h"

@implementation UIFont (PingFang)

+ (instancetype)pingFongFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (instancetype)pingFongLightFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Light" size:size];
}

+ (instancetype)pingFongMediumFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}

+ (instancetype)pingFongBoldFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}

/*
 Font: PingFangSC-Medium
 Font: PingFangSC-Semibold
 Font: PingFangSC-Light
 Font: PingFangSC-Ultralight
 Font: PingFangSC-Regular
 Font: PingFangSC-Thin
 */

@end
