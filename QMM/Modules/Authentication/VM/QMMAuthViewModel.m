//
//  QMMAuthViewModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMAuthViewModel.h"
#import "QMMAuthCellModel.h"

@implementation QMMAuthViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"];
    self.dataArray
    = @[
        [QMMAuthCellModel modelWithCellType:AuthCellTypeInfo
                                          icon:@"ic_auth_why"
                                         title:@"为什么要身份认证"
                                          info:[NSString stringWithFormat:@"%@作为一个真实、严肃的婚恋平台，我们要求用户必须完成身份认证；对于以诚心交友、恋爱、结婚为目的的用户，我们希望提供一个无酒托、婚托的婚恋环境。", appName]],
        [QMMAuthCellModel modelWithCellType:AuthCellTypeInfo
                                          icon:@"ic_auth_sceret"
                                         title:@"关于隐私安全"
                                          info:@"您上传的任何身份证照片等资料，仅供审核使用且 TA人无法查看，敬请放心"],
        [QMMAuthCellModel modelWithCellType:AuthTypeUpIDImage
                                          icon:@"ic_auth_id"
                                         title:@"身份认证"
                                          info:@"（请务必按详例上传照片）"],
        ];
}

@end
