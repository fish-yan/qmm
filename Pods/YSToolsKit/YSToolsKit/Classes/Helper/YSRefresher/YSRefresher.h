//
//  YSRefresher.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/12.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSRefreshNormalHeader.h"
#import "YSRefreshGifHeader.h"
#import "YSRefreshFooter.h"

/**
 项目上拉刷新和下拉加载更多封装类,
 对MJRefresh二次封装
 */
@interface YSRefresher : NSObject

+ (__kindof MJRefreshHeader *)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
+ (__kindof MJRefreshHeader *)headerWithRefreshingBlock:(void(^)(void))refreshingBlock;

+ (__kindof MJRefreshFooter *)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
+ (__kindof MJRefreshFooter *)footerWithRefreshingBlock:(void(^)(void))refreshingBlock;

@end
