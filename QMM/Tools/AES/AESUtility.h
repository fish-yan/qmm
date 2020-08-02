//
//  AESUtility.h
//  AES
//
//  Created by amin on 15/7/17.
//  Copyright (c) 2015年 lzc-yunyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
///////////////aes加密
@interface NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)keyValue;        /*加密方法,参数需要加密的内容*/
- (NSData *)AES256DecryptWithKey :(NSString*)keyValue;        /*解密方法，参数数密文*/

@end

////////////////////////////////////////////////// base64加密解密

#define __BASE64( text )        [CommonFunc base64StringFromText:text]
#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]
@interface MyBase64 : NSObject

/******************************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/******************************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;

+ (NSString *)base64EncodedStringFrom:(NSData *)data;
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

@end

//////////////////////////////////////////////////////
@interface AESUtility : NSObject

+(NSString *)AES256Encrypt:(NSString *) content;
+(NSString *)AES256Decrypt:(NSString *)content;


+(NSString *)AES256EncryptPASSword:(NSString *) content;

+(NSString *)AES256DecryptPASSword:(NSString *)content;
@end
