//
//  HYOnlinePayHelper.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/27.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYOnlinePayHelper.h"
#import "Order.h"
#import "RSADataSigner.h"
#import "NSString+MD5.h"
#import "NSString+SHA256.h"
#import "MXWechatSignAdaptor.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation HYOnlinePayInfoModel

@end

@interface HYOnlinePayHelper ()<WXApiDelegate>

@property (nonatomic, strong) HYOnlinePayInfoModel *model;
@property (nonatomic, copy) void(^callBack)(id obj, NSError *error);

@end

@implementation HYOnlinePayHelper

+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    static HYOnlinePayHelper *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [HYOnlinePayHelper new];
    });
    return instance;
}

- (void)onlinePay:(OnlinePayType)type
      withPayInfo:(HYOnlinePayInfoModel *)model
           result:(void(^)(id obj, NSError *error))result {
    self.model = model;
    self.callBack = result;
    
    switch (type) {
        case OnlinePayTypeAli:
            [self doAliPayAction];
            break;
        case OnlinePayTypeWeChat:
            [self doWechatPayAction];
            break;
        default:
            break;
    }
}


#pragma mark - Wechat Pay

- (void)doWechatPayAction {
    NSString *timeSp =[NSString stringWithFormat:@"%.0f",[[NSDate date]timeIntervalSince1970]];
    UInt32 timeStamp =[timeSp intValue];
    
    
    PayReq * request =[[PayReq alloc] init];
//    request.openID=WX_APP_ID;
    request.partnerId = self.model.payid;
    request.prepayId= self.model.prepayid;
    request.nonceStr = @"nchaosho1o23h1100200";
    request.timeStamp = timeStamp;
    request.package             = @"Sign=WXPay";
    MXWechatSignAdaptor *md5 = [[MXWechatSignAdaptor alloc] init];
    request.sign=[md5 createMD5SingForPay:request.openID
                                partnerid:request.partnerId
                                 prepayid:request.prepayId
                                  package:request.package
                                 noncestr:request.nonceStr
                                timestamp:request.timeStamp];
    BOOL b = [WXApi sendReq:request];
    NSLog(@"微信支付=%d", b);
}
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    [YSProgressHUD hiddenHUD];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg =[NSString stringWithFormat:@"支付结果"];
        if (resp.errCode == 0) {
            if (self.callBack) {
                self.callBack(@{@"msg": @"支付成功"}, nil);
            }
            return;
        }
        
        
        strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
        NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode, resp.errStr);
        NSError *error = [NSError errorWithDomain:@"com.huayuan.wechat.pay"
                                             code:resp.errCode
                                         userInfo:@{NSLocalizedDescriptionKey: resp.errStr ?: @"支付失败"}];
        if (self.callBack) {
            self.callBack(nil, error);
        }
    }
}


#pragma mark - Ali Pay

- (void)doAliPayAction {
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2018053160295428";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"";
    NSString *rsaPrivateKey =
    @"MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDP5bcVYjaHPbaI9XYBkyLU+/"
    @"57b7JBaAnOSXMZDw1nUwVb8CVfY5owcbvp0tJxsX7glxtxjKeOaijE/rHb3aYGpFetm0hSTGkPeyo+XBbC2ZvjnkoAugDd2sJUTAiE0KRyNC0B/"
    @"7U2I/O+2LkNhgvfpZH3AnhCq6QJ5AVRnpxZVUVv5X+Yteuo494bL3tvz+w2NSnJlmHx4D7S7JyOrAiF0m971S7QA331As1dW3v3D9YsY/Le9MRc/"
    @"oDyNxqhpN9F6KOb5dbfsiQLcwdWfMJPtF/"
    @"ObK6QWIBC22p6AtoAOvJylxsqiV+47tCBTO2oljXnkciQsmqskDJauhbfBqzfAgMBAAECggEAISmNeNW/yPbpJROyjTHBPqQrxdjdYF2OIt/"
    @"IgljKVI8DrdSywXKL5+pchUHh28zqZjz0XbqIB8mbU0ElceL7VtfkPIcmlCooIBYPeP8Lim1X1okrWM5S0RDSKswuF7GIacc03rrBVy+"
    @"I9ApyClw1jKlGjVZRhKEIe6Npzck1O3J6uDCSatZPGpNBfScO7dLo7s2bxQi5ukq+khPdIk0TjU4DqwxzGYK1tU5tNZ6Rdr6sUNuX4+"
    @"7O8fxq8HQLhIRCXMLtN0yAa3FlgixGUdGTUpU/+WwOtOntpu7WQZqcliat5FuaOGMxmZ18/"
    @"zqjFsjtTmgTPREFZUJJELy4JqllkQKBgQD+066FNAw6cdYY9JnXmlp5B6lORn3koQ00PJk1uS6D3fY5VuSw6pB5BmWm+V5gT8TN/"
    @"QludSSutNuwSItcVUvCvbu+qYeoHiAPIhB6iLgVAp4M8JwXQ+99ldyGa6O08m8xwiWwMiiKnoEbFi3Mo0YBBLNcptYB+"
    @"g5E6wmDiLc7vQKBgQDQ2rngmNqfBevtAe/"
    @"NvG+N4YrEFeo8sNsNaGAOkwYqh5hnfI4xP8Q9yxpFr3eFzWS3+RcCZHUQl76WKd3+cZNfNoACCIMeJ4tMtNapQb9C+"
    @"CXicvKHTvEBFmGMn1IcwhilCoXswhPkBXCh2/jrZ9qDjwlI3g0hFjs/Gp92A/"
    @"FmywKBgHRJf0O0G7x0BGLBBI96Fb1TfLSGwJ6bzB3BZZ05k3uDyAAkohoGAMXp4GuRMrs6y7HAvhQVCxda20IX6NjK59bHpKx+"
    @"SrSygqjFP8XbLD4SQrPe/"
    @"Sw0yU6DG+6PolZJp+qKEY7VZODVMk99EItpGuIOFhe63sBqLybOJzpKImv1AoGAa2BovD4Z+DQ1La8XOTEuMUXJ8DJMMVPD60rER/"
    @"ny6563Dk2NVWixXguzwCwMSTBmHefkmohHX3aEt/"
    @"NifNSrrgH5IhJ6RuCRz6gRzQdObAHkiF4MruA5LBPzpzaqIrrvrLqSTD0juNHLLIxJl83XHFhHr7zqBx7E6xam8Sfpzq0CgYAxTjml82/"
    @"BXKlJvoBheqdAaQQ6Q0b/0yKJ0SHcFJ0zjyN0z33VIL8YVADAGTEbCCxR7HzVPbra9IcHVe7mWH4muYn75MFC1drdQYY8cK9LfrliO+/"
    @"vJlTsP1cMILOilojNcx4OHIfJj6vycNHl70kbvn496jQ/Y/1601copWBf3g==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    // partner和seller获取失败,提示
        if ([appID length] == 0 ||
            ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"缺少appId或者私钥。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = @"RSA2";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = self.model.body;
    order.biz_content.subject = self.model.subject;
    order.biz_content.out_trade_no = self.model.payno; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount =self.model.money; //商品价格
    order.biz_content.seller_id=@"914255445@qq.com";
    order.notify_url = self.model.callbackurl;
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSLog(@"%@",orderInfo);
    
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer =  [[RSADataSigner alloc] initWithPrivateKey:rsaPrivateKey];
    signedString = [signer signString:orderInfo withRSA2:YES];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"com.58cailu.qmm";
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@", orderInfoEncoded, signedString];

        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            /*
             result = {
             "alipay_trade_app_pay_response":
                 {
                 "code":"10000",
                 "msg":"Success",
                 "app_id":"2018053160295428",
                 "auth_app_id":"2018053160295428",
                 "charset":"utf-8",
                 "timestamp":"2018-06-27 13:12:21",
                 "total_amount":"0.03",
                 "trade_no":"2018062721001004090570705884",
                 "seller_id":"2088131320901901",
                 "out_trade_no":"jianni1806271311459881244185367045787"
                 },
             "sign":"szpnpKHj4,
             "sign_type":"RSA2"
             };
             resultStatus = 9000;
             memo = ;
            
             */
            NSInteger status = [[resultDic objectForKey:@"resultStatus"] intValue];
            if(status == 9000) {
                NSString *resultStr = resultDic[@"result"];
                NSDictionary *rst = [NSJSONSerialization
                                     JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding]
                                     options:NSJSONReadingMutableLeaves
                                     error:nil];
                if (self.callBack) {
                    self.callBack(rst, nil);
                }
                
            }
            else {
                NSError *error = [NSError errorWithDomain:@"com.seeyou.error"
                                                     code:[resultDic[@"resultStatus"] integerValue]
                                                 userInfo:@{NSLocalizedDescriptionKey: resultDic[@"memo"] ?: @"支付失败"}];
                if (self.callBack) {
                    self.callBack(resultDic, error);
                }
                
            }
            
        }];
    }
}

@end
