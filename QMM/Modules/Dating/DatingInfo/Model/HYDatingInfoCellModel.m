//
//  HYDatingInfoCellModel.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "HYDatingInfoCellModel.h"

@implementation HYDatingInfoCellModel

+ (instancetype)modelWithTitle:(NSString *)title info:(NSString *)info infoColor:(UIColor *)infoColor {
    return [self modelWithTitle:title
                           info:info
                      infoColor:infoColor
                       hasArrow:YES
                      canEdited:NO];;
}

+ (instancetype)modelWithTitle:(NSString *)title info:(NSString *)info hasArrow:(BOOL)hasArrow {
    return [self modelWithTitle:title
                           info:info
                       hasArrow:hasArrow
                      canEdited:NO];
}

+ (instancetype)modelWithTitle:(NSString *)title
                          info:(NSString *)info
                      hasArrow:(BOOL)hasArrow
                     canEdited:(BOOL)canEdited {
    return [self modelWithTitle:title
                           info:info
                      infoColor:nil
                       hasArrow:hasArrow
                      canEdited:canEdited];
}


+ (instancetype)modelWithTitle:(NSString *)title
                          info:(NSString *)info
                     infoColor:(UIColor *)infoColor
                      hasArrow:(BOOL)hasArrow
                     canEdited:(BOOL)canEdited {
    HYDatingInfoCellModel *m = [HYDatingInfoCellModel new];
    m.title = title;
    m.info = info;
    m.hasArrow = hasArrow;
    m.canEdited = canEdited;
    m.infoColor = infoColor;
    return m;
}


@end
