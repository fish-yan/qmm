//
//  YSRefreshNormalHeader.m
//
//  Created by Joseph Koh on 2017/6/8.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSRefreshNormalHeader.h"
#import "NSBundle+YSBundle.h"

@interface YSRefreshNormalHeader ()

@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation YSRefreshNormalHeader

#pragma mark - 重写父类的方法

- (void)prepare {
    [super prepare];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    self.mj_h = 65;
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5 - 20;
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    
    // 文本
    self.stateLabel.mj_x = self.mj_w * 0.5 + 20;
    self.stateLabel.mj_y = self.mj_h * 0.5 + 10;
    self.stateLabel.bounds = CGRectMake(0, 0, 100, 50);
    [self.stateLabel sizeToFit];
    
    // 圈圈
    self.loadingView.center = self.arrowView.center;
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        self.stateLabel.hidden = NO;
        self.stateLabel.text = @"下拉刷新";
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                
                self.arrowView.hidden = NO;
            }];
        }
        else {
            self.arrowView.hidden = NO;
            [self.loadingView stopAnimating];
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
        }
    }
    else if (state == MJRefreshStatePulling) {
        self.stateLabel.hidden = NO;
        self.stateLabel.text = @"释放刷新";
        self.arrowView.hidden = NO;
        [self.loadingView stopAnimating];
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformIdentity;
        }];
    }
    else if (state == MJRefreshStateRefreshing) {
        self.stateLabel.hidden = NO;
        self.stateLabel.text = @"加载中";
        self.arrowView.hidden = YES;
        [self.loadingView startAnimating];
    }
    else if (state == MJRefreshStateNoMoreData) {
        self.stateLabel.hidden = YES;
        self.arrowView.hidden = YES;
        [self.loadingView stopAnimating];
    }
}


#pragma mark - Lazy Loading

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[NSBundle ys_imageNamed:@"ys_arrow" ofType:@"png"]];
        [self addSubview:_arrowView];
    }
    return _arrowView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = [UIColor darkGrayColor];
        _stateLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

@end
