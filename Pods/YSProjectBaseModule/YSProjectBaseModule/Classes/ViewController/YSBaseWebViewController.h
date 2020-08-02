//
//  YSBaseWebViewController.h
//
//  Created by Joseph Gao on 2017/5/31.
//  Copyright © 2017年 WondersGroup.com. All rights reserved.
//

#import "YSBaseViewController.h"
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <YSToolsKit/YSToolsKit.h>
//#import <ProjectConfig/ProjectConfig.h>
#import <YSMediator/YSMediator.h>

@interface YSBaseWebViewController : YSBaseViewController <WKUIDelegate, WKNavigationDelegate>

/// webView加载的URL
@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *config;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

- (void)registerJavascriptFunction;
- (void)loadWebView;

@end
