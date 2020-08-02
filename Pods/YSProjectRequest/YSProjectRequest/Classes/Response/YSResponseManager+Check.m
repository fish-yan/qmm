//
//  YSResponseManager+Check.m
//  Pods
//
//  Created by Joseph Koh on 2018/7/12.
//

#import "YSResponseManager+Check.h"

@implementation YSResponseManager (Check)


/// 检查response结果是否成功，成功返回nil， 失败返回自己组装的Error（PS：Message为接口返回）
+ (NSError *)checkResponseObject:(id)response {
    int code = [response[@"code"] intValue];
    
    // code为0，表示成功
    if (code != 0) {
        NSString *msg = response[@"msg"];
        NSLog(@"错误代码: %d \n错误信息: %@", code, msg);
        
        if (msg && [msg isKindOfClass:[NSString class]] ) { // 业务模块错误代码
            return [self publicErrorWithCode:code message:msg];
        }
        else {  // 公共错误
            return [self businessErrorWithCode:code message:@"连接失败"];
        }
    }
    
    return nil;
}


/// 接口调用失败，把返回的Error转为我们自己的格式
+ (NSError *)checkResponseError:(NSError *)error {
    return [self publicErrorWithCode:(int)(error.code) message:@"网络出错，点击重试"];
}


/// 公共错误
+ (NSError *)publicErrorWithCode:(int)errorCode message:(NSString *)msg {
    switch (errorCode) {
        case 1:
            msg = [msg length] ? msg : @"缺少版本号version";
            break;
        case 2:
            msg = [msg length] ? msg : @"缺少设备号device";
            break;
        case 3:
            msg = [msg length] ? msg : @"缺少渠道号channel";
            break;
        case 4:
            msg = [msg length] ? msg : @"缺少手机类型platform";
            break;
        case 5:
            msg = [msg length] ? msg : @"缺少手机型号model";
            break;
        case 6:
            msg = [msg length] ? msg : @"缺少手机系统版本os-version";
            break;
        case 7:
            msg = [msg length] ? msg : @"缺少手机屏幕分辨率screen-width或screen-height";
            break;
        case 10:
            msg = [msg length] ? msg : @"缺少令牌access-token";
            break;
        case 11:
            msg = [msg length] ? msg : @"令牌access-token过期";
            break;
        case 12:
            msg = [msg length] ? msg : @"令牌access-token无效";
            break;
        case 13:
            msg = [msg length] ? msg : @"账户在其他设备登录, access-token无效";
            break;
        case 20:
            msg = [msg length] ? msg : @"缺少签名signature";
            break;
        case 21:
            msg = [msg length] ? msg : @"签名signature验证错误";
            break;
        case 40:
            msg = [msg length] ? msg : @"客户端输入参数缺失";
            break;
        case 41:
            msg = [msg length] ? msg : @"客户端输入参数格式错误";
            break;
        default:
            msg = [msg length] ? msg : @"连接失败";
            break;
    }
    
    NSError *error = [self businessErrorWithCode:errorCode message:msg];
    return error;
}


/// 业务模块错误代码
+ (NSError *)businessErrorWithCode:(int)errorCode message:(NSString *)msg {
    NSNumber *c = [NSNumber numberWithInt:errorCode];
    NSDictionary *errorInfo = @{
                                NSLocalizedDescriptionKey : msg,
                                NSLocalizedFailureReasonErrorKey : c
                                };
    NSError *error = [NSError errorWithDomain:@"com.fullway.error" code:errorCode userInfo:errorInfo];
    return error;
}


/**
 @desc 检查ErrorCode是否是用户登录过期
 
 "40001","请求中无token信息,请先获取再请求数据。"
 "40002","token无效,不合法，请重新获取。"
 "40003","token已过期，请重新获取。"
 */
+ (BOOL)isInvalidToken: (NSError *)error {
    if (error.code == 40001
        || error.code == 40002
        || error.code == 40003) {
        return YES;
    }
    
    return NO;
}


@end
