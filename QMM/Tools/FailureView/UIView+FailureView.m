//
//  UIView+FailureView.m
//  HCDoctor
//
//  Created by Joseph Gao on 2017/6/14.
//  Copyright © 2017年 WondersGroup.com. All rights reserved.
//

#import "UIView+FailureView.h"
#import "WDFailureView.h"
#import "NetMonitor.h"

#define FAILURE_VIEW_TAG 10010
#define TABLE_VIEW_BACK_VIEW_TAG 0x99009


@implementation UIView (FailureView)

#pragma mark - Public Method

- (void)showFailureViewOfType:(WDFailureViewType)type withClickAction:(void (^)(void))clickAction {
    if (![NetMonitor shareTools].isReachable) {
        type = WDFailureViewTypeUnreachabel;
    }

    UIImage *image   = [self imageOfType:type];
    NSString *tips   = [self tipsOfType:type];
    UIView *backView = [self backView];

    [self showFailureViewWithImage:image
                              tips:tips
                              type:type
                     clickedAction:clickAction
                   btnClickHandler:NULL
                        inBackView:backView];

    [self filterScrollActionWithFailureView];
}

- (void)showFailureViewWithImage:(UIImage *)image tips:(NSString *)tips andClickAction:(void (^)(void))clickAction {
    UIView *backView = [self backView];

    [self showFailureViewWithImage:image
                              tips:tips
                              type:WDFailureViewTypeUnknow
                     clickedAction:clickAction
                   btnClickHandler:NULL
                        inBackView:backView];
    [self filterScrollActionWithFailureView];
}

- (void)showFailureViewWithImage:(UIImage *)image
                            tips:(NSString *)tips
              andBtnClickHandler:(void (^)(__kindof UIButton *tapBtn))handler {
    UIView *backView = [self backView];

    [self showFailureViewWithImage:image
                              tips:tips
                              type:WDFailureViewTypeUnknow
                     clickedAction:NULL
                   btnClickHandler:handler
                        inBackView:backView];
    [self filterScrollActionWithFailureView];
}

- (void)hiddenFailureView {
    if ([self viewWithTag:FAILURE_VIEW_TAG]) {
        [[self viewWithTag:FAILURE_VIEW_TAG] setHidden:YES];
    } else if ([[self backView] viewWithTag:FAILURE_VIEW_TAG]) {
        [[[self backView] viewWithTag:FAILURE_VIEW_TAG] setHidden:YES];
    }

    if ([self.superview viewWithTag:TABLE_VIEW_BACK_VIEW_TAG]) {
        [[self.superview viewWithTag:TABLE_VIEW_BACK_VIEW_TAG] setHidden:YES];
        [self.superview bringSubviewToFront:self];
    }

    [self replyScrollActionWithFailureView];
}


#pragma mark - Private Method

- (void)showFailureViewWithImage:(UIImage *)image
                            tips:(NSString *)tips
                            type:(WDFailureViewType)type
                   clickedAction:(void (^)(void))clickedAction
                 btnClickHandler:(void (^)(__kindof UIButton *tapBtn))handler
                      inBackView:(UIView *)backView {
    UIView *sView = self;
    if (backView) {
        sView = backView;
    }

    WDFailureView *failureView = [sView viewWithTag:FAILURE_VIEW_TAG];
    if (!failureView) {
        failureView                 = [[WDFailureView alloc] initWithFrame:sView.bounds];
        failureView.backgroundColor = self.backgroundColor;
        failureView.tag             = FAILURE_VIEW_TAG;
        [sView addSubview:failureView];

        [failureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(sView);
        }];
    }
    failureView.hidden = NO;
    [failureView showFailureViewWithImage:image tips:tips labelClickHandler:clickedAction btnClickHandler:handler];

    [sView bringSubviewToFront:failureView];

    if (type == WDFailureViewTypeUnreachabel) {
        UILabel *l = [[UILabel alloc] init];
        l.text = @"重新加载";
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor tc1Color];
        l.font = [UIFont systemFontOfSize:16];
        [failureView addSubview:l];

        l.layer.masksToBounds = YES;
        [l.layer setBorderWidth:0.5];
        [l.layer setBorderColor:[UIColor tc1Color].CGColor];
        
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(failureView.tipsLabel.mas_bottom).offset(15);
            make.centerX.equalTo(failureView.tipsLabel.mas_centerX);
            make.height.equalTo(@44);
            make.width.equalTo(@150);
        }];
    }
}

/// 过滤失败页面的滑动事件
- (void)filterScrollActionWithFailureView {
    if ([self isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView *) self).scrollEnabled = NO;
        ((UIScrollView *) self).contentOffset = CGPointMake(0, 0);
    }
}

/// 恢复失败页面的滑动事件
- (void)replyScrollActionWithFailureView {
    if ([self isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView *) self).scrollEnabled = YES;
    }
}

- (UIImage *)imageOfType:(WDFailureViewType)type {
    switch (type) {
        case WDFailureViewTypeDefault:
            return nil;
            break;
        case WDFailureViewTypeEmpty:
            return [UIImage imageNamed:@"nodata"];
            break;
        case WDFailureViewTypeUnreachabel:
            return [UIImage imageNamed:@"nowifi"];
            break;
        case WDFailureViewTypeMessageEmpty:
            return [UIImage imageNamed:@"nomessage"];
        case WDFailureViewTypeError:
        case WDFailureViewTypeUnknow:
            return [UIImage imageNamed:@"error"];
            break;
        default:
            break;
    }
}

- (NSString *)tipsOfType:(WDFailureViewType)type {
    switch (type) {
        case WDFailureViewTypeDefault:
            return @"";
            break;
        case WDFailureViewTypeEmpty:
            return @"暂无数据";
            break;
        case WDFailureViewTypeUnreachabel:
            return @"网络好像有问题哦";
            break;
        case WDFailureViewTypeError:
            return @"请求出错,点击重试";
            break;
        case WDFailureViewTypeMessageEmpty:
            return @"你还没有收到任何私信哦";
        case WDFailureViewTypeUnknow:
            return @"未知错误,点击重试";
            break;
        default:
            break;
    }
}

- (UIView *)backView {
    UIView *backView = nil;

    if ([self isKindOfClass:[UITableView class]]) {
        backView = [self.superview viewWithTag:TABLE_VIEW_BACK_VIEW_TAG];

        if (!backView) {
            backView                 = [[UIView alloc] init];
            backView.backgroundColor = [UIColor clearColor];
            backView.tag             = TABLE_VIEW_BACK_VIEW_TAG;
            [self.superview addSubview:backView];

            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }

        backView.hidden = NO;
        [self.superview bringSubviewToFront:backView];
    }
    return backView;
}

@end
