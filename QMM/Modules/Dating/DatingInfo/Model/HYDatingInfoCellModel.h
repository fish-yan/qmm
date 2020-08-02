//
//  HYDatingInfoCellModel.h
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "YSBaseModel.h"

@interface HYDatingInfoCellModel : YSBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) BOOL hasArrow;
@property (nonatomic, assign) BOOL canEdited;
@property (nonatomic, strong) UIColor *infoColor;

+ (instancetype)modelWithTitle:(NSString *)title info:(NSString *)info infoColor:(UIColor *)infoColor;
+ (instancetype)modelWithTitle:(NSString *)title info:(NSString *)info hasArrow:(BOOL)hasArrow;
+ (instancetype)modelWithTitle:(NSString *)title info:(NSString *)info hasArrow:(BOOL)hasArrow canEdited:(BOOL)canEdited;

@end
