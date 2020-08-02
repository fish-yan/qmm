//
//  YSBaseWebViewController.m
//
//  Created by Joseph Gao on 2017/5/31.
//  Copyright © 2017年 WondersGroup.com. All rights reserved.
//

#import "YSBaseWebViewController.h"

@interface YSBaseWebViewController () 

@property (nonatomic, strong) NSMutableURLRequest *request;

@end

@implementation YSBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self observeValues];
    [self registerJavascriptFunction];
    [self loadWebView];
}

- (void)loadWebView {
    [self.webView loadRequest:self.request];
}


#pragma mark - Observe

- (void)observeValues {
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.webView) {
            WKWebView *webView = (WKWebView *)object;
            [self setProgressViewDisplayWithProgress:webView.estimatedProgress];
        }
        else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.navigationItem.title = self.webView.title;
        }
        else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - WebView Delegate 

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {    
    // self.navigationItem.title = webView.title;
    [webView evaluateJavaScript:@"document.title"
              completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                  if (error == nil && result) {
                      self.navigationItem.title = result;
                  }
              }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {

}


#pragma mark - Action

- (void)hiddenProgressView {
    self.progressView.hidden = YES;
}

- (void)showProgressView {
    self.progressView.hidden = NO;
}

- (void)registerJavascriptFunction {

}


#pragma mark - 初始化WebView

- (void)initialize {
    _config = [[WKWebViewConfiguration alloc] init];
    _config.allowsInlineMediaPlayback = YES;
    if (@available(iOS 9.0, *)) {
        _config.allowsPictureInPictureMediaPlayback = YES;
        _config.allowsAirPlayForMediaPlayback = YES;
    } else {
        // Fallback on earlier versions
    }
    
    WKPreferences *prefrences = [[WKPreferences alloc] init];
    //prefrences.minimumFontSize = 13.0;
    prefrences.javaScriptEnabled = YES;
    prefrences.javaScriptCanOpenWindowsAutomatically = NO;
    
    _config.preferences = prefrences;
    
    //

    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:_config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 初始化bridge
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
}

- (void)setProgressViewDisplayWithProgress:(CGFloat)estimatedProgress {
    CGRect bounds = self.progressView.bounds;
    bounds.size.width = estimatedProgress * [UIScreen mainScreen].bounds.size.width;
    self.progressView.bounds = bounds;
}


#pragma mark - Other

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}


#pragma mark - Lazy Loading

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2)];
        _progressView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}
- (NSMutableURLRequest *)request {
    if (!_request) {
        _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]
                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                       timeoutInterval:60];
    }
    return _request;
}

@end
