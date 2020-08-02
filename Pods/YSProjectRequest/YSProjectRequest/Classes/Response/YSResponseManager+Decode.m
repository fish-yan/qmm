//
//  YSResponseManager+Decode.m
//  Pods
//
//  Created by Joseph Koh on 2018/7/12.
//

#import "YSResponseManager+Decode.h"
#import "YSRequestInfoConfig.h"
#import "YSToolskit.h"

@implementation YSResponseManager (Decode)


/*
 网络请求解码步骤:
 
 步骤 | 服务端 | 客户端
 ----| --- | ----
 1. | 对json字符进行web编码 |  客户端先对数据用私钥解密;
 2. |  网络请求json数据通过RSA 公钥 分步加密 | 客户端对json字符串web解码
 3. | - | web解码后的json字符串转json
 */
+ (id)decryptResponseData:(NSString *)encryptedStr {
    if (!encryptedStr) return nil;
    
    NSString *decodeJsonStr = [ENRSA decryptString:encryptedStr privateKey:[YSRequestInfoConfig shareConfig].publicKey];
    NSString *encodeJsonStr = [decodeJsonStr urlDecode];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[encodeJsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    if (error) {
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        NSLog(@"               解析响应数据失败             ");
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        NSLog(@"原因: %@", error);
    }
    
    return dict;
}


@end
