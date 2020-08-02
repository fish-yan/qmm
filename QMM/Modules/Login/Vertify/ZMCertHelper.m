//
//  ZMCertHelper.m
//  QMM
//
//  Created by Joseph Koh on 2018/11/14.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "ZMCertHelper.h"

@implementation ZMCertHelper

+ (instancetype)shareHelper {
    static ZMCertHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZMCertHelper new];
    });
    return instance;
}

- (void)doVerify:(NSString *)urlStr {
    NSString *alipayUrl = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=20000067&url=%@", [self URLEncodedStringWithUrl:urlStr]];
    NSURL *url = [NSURL URLWithString:alipayUrl];
    
    if ([self canOpenAlipay]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"是否下载并安装支付宝完成认证?"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"好的",
                                  nil];
        [alertView show];
    }
}

-(NSString *)URLEncodedStringWithUrl:(NSString *)url {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)url,NULL,(CFStringRef) @"!*'();:@&=+$,%#[]|",kCFStringEncodingUTF8));
    return encodedString;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *appstoreUrl = @"itms-apps://itunes.apple.com/app/id333206289";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl]];
    }
}

- (BOOL)canOpenAlipay {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]];
}

@end
