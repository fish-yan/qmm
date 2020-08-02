//
//  YSRefreshGifHeader.m
//
//  Created by Joseph Koh on 2017/6/8.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSRefreshGifHeader.h"

@implementation YSRefreshGifHeader

#pragma mark - 重写方法
#pragma mark 基本设置

- (void)prepare {
    [super prepare];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 1; i < 7 ; i++) {
        NSString *imageString = [NSString stringWithFormat:@"下拉加载%d",i];
        UIImage *image = [UIImage imageNamed:imageString];
        if (image) {
            [images addObject:image];
        }
    }
    if (images.count <= 0) return;
    
    // 设置普通状态
    [self setImages:@[images[0]] forState:MJRefreshStateIdle];
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态
    [self setImages:images forState:MJRefreshStatePulling];
    [self setImages:images duration:0.6 forState:MJRefreshStatePulling];
    [self setTitle:@"松开后刷新" forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:images forState:MJRefreshStateRefreshing];
    [self setImages:images duration:0.5 forState:MJRefreshStateRefreshing];
    [self setTitle:@"正在刷新中..." forState:MJRefreshStateRefreshing];
    
    // 设置字体和颜色
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:10];
    self.stateLabel.textColor = [UIColor blueColor];
    self.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    
    // 设置自动切换透明度,下拉时alpha属性从0-1
    self.automaticallyChangeAlpha = YES;

    
}

- (void)placeSubviews {
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    }
    else {
        self.gifView.contentMode = UIViewContentModeRight;
        
        CGFloat stateWidth = self.stateLabel.mj_textWith;
        CGFloat timeWidth = 0.0;
        if (!self.lastUpdatedTimeLabel.hidden) {
            timeWidth = self.lastUpdatedTimeLabel.mj_textWith;
        }
        CGFloat textWidth = MAX(stateWidth, timeWidth);
        [self.stateLabel setMj_x:textWidth/2 -self.labelLeftInset/2];
        [self.lastUpdatedTimeLabel setMj_x:textWidth/2-self.labelLeftInset/2];
        
        //75 为gif图片的宽度
        float scale = [UIScreen mainScreen].bounds.size.width/320.0;
        self.gifView.mj_x = self.lastUpdatedTimeLabel.mj_x -(75*scale + textWidth +50);
    }
}
@end
