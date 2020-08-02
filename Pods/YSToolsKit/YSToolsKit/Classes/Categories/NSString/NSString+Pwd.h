//
//  NSString+Pwd.h
//  YSKit
//
//  Created by Joseph Koh on 16/4/22.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Pwd)
/*!
 @brief 检查密码安全强度
 @param _password 密码
 @return 安全强度提示字符
 */
+ (NSString *)judgePasswordStrength:(NSString*)_password;

/*!
 @brief 检查密码安全强度
 @return 安全强度提示字符
 */
- (NSString *)judgePasswordStrength;

@end
