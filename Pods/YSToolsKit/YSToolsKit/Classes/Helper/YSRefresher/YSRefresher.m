//
//  YSRefresher.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/12.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSRefresher.h"

@implementation YSRefresher

#pragma mark - Header Refresh

+ (__kindof MJRefreshHeader *)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    return [YSRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    //return [YSRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
}

+ (__kindof MJRefreshHeader *)headerWithRefreshingBlock:(void(^)(void))refreshingBlock {
    return [YSRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    //return [YSRefreshGifHeader headerWithRefreshingBlock:refreshingBlock];
}


#pragma mark - Footer Refresh

+ (__kindof MJRefreshFooter *)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    return [YSRefreshFooter footerWithRefreshingTarget:target refreshingAction:action];
}

+ (__kindof MJRefreshFooter *)footerWithRefreshingBlock:(void(^)(void))refreshingBlock {
    return [YSRefreshFooter footerWithRefreshingBlock:refreshingBlock];
}



@end
