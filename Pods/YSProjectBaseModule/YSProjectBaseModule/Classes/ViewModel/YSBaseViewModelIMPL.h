//
//  YSBaseViewModelIMPL.h
//  MyProject
//
//  Created by Joseph Gao on 2017/5/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YSBaseViewModelIMPL <NSObject>

@optional;

/**
 创建ViewModel工厂方法

 @param obj 模型对象
 @return viewModel实例
 */
+ (instancetype)viewModelWithObj:(id)obj;

/**
 设置viewModel模型对象

 @param obj 模型对象
 */
- (void)setObj:(id)obj;

@end
