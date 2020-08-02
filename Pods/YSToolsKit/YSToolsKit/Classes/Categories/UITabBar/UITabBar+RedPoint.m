//
//  UITabBar+RedPoint.m
//
//  Created by Joseph Koh on 2017/6/20.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "UITabBar+RedPoint.h"

#define BADGE_VIEW_TAG 200
#define BADGE_WH  6

@implementation UITabBar (RedPoint)

- (void)showBadgeAtIndex:(NSInteger)index {
    if (self.items.count <= 0) return;
    
    NSInteger tag = BADGE_VIEW_TAG + index;
    CGFloat averageW = self.bounds.size.width / self.items.count;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            if (idx == index + 1) {
                UIView *badge = [self viewWithTag:tag];
                
                if (!badge) {
                    badge = [[UIView alloc] init];
                    badge.tag = tag;
                    badge.layer.borderWidth = 0.5;
                    badge.layer.borderColor = [UIColor whiteColor].CGColor;
                    badge.layer.cornerRadius = BADGE_WH / 2;
                    badge.backgroundColor = [UIColor redColor];
                    CGFloat x = averageW * index + averageW * 0.5 + 5;
                    badge.frame = CGRectMake(x, 8, BADGE_WH, BADGE_WH);
                    
                    [self addSubview:badge];
                    [self bringSubviewToFront:badge];
                    
                    *stop = YES;
                }
                
                badge.hidden = NO;
                *stop = YES;
            }
        }

    }];
}

- (void)hideBadgeAtIndex:(NSInteger)index {
    NSInteger tag = BADGE_VIEW_TAG + index;
    UIView *badge = [self viewWithTag:tag];
    badge.hidden = YES;
}

@end
