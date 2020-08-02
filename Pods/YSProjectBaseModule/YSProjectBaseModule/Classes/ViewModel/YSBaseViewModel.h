//
//  YSBaseViewModel.h
//  MyProject
//
//  Created by Joseph Gao on 2017/4/30.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <YSProjectRequest/YSProjectRequest.h>
#import <YSMediator/YSMediator.h>

#import "YSBaseViewModelIMPL.h"

@interface YSBaseViewModel : NSObject <YSBaseViewModelIMPL>

/// 是否还有更多数据
@property (nonatomic, assign) BOOL hasMore;
/// 是否还有更多数据传给服务器的字典
@property (nonatomic, strong) NSDictionary *moreParams;
/// 分页标志, 来自 列表数据中more_params 的flag
@property (nonatomic, strong) NSNumber *flag;


/**
 工厂方法快速创建viewModel对象

 @return 实例化的viewModel对象
 */
+ (instancetype)viewModel;


@end
