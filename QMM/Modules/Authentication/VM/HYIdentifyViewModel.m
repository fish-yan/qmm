//
//  HYIdentifyViewModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYIdentifyViewModel.h"
#import "HYIdentifyCellModel.h"

@implementation HYIdentifyViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.dataArray
    = @[
        [HYIdentifyCellModel modelWithCellType:HYIdentifyCellTypeInfo
                                          icon:@"identifyicon"
                                         title:@"为什么要身份认证"
                                          info:@"我想见你作为一个真实、严肃的婚恋平台，我们要求用户必须完成身份认证；对于以诚心交友、恋爱、结婚为目的的用户，我们希望提供一个无酒托、婚托的婚恋环境。"],
        [HYIdentifyCellModel modelWithCellType:HYIdentifyCellTypeInfo
                                          icon:@"secrecticon"
                                         title:@"关于隐私安全"
                                          info:@"您上传的任何身份证照片等资料，仅供审核使用且 TA人无法查看，敬请放心"],
        [HYIdentifyCellModel modelWithCellType:HYIdentifyCellTypeUpIDImage
                                          icon:@"identifyicon1"
                                         title:@"身份认证"
                                          info:@"（请务必按详例上传照片）"],
        ];
}

@end
