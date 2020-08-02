//
//  YSBaseViewIMPL.h
//  MyProject
//
//  Created by Joseph Gao on 2017/5/3.
//  Copyright © 2017年 Joseph. All rights reserved.
//

/// 提供视图 bind viewModel接口
@protocol YSBaseViewIMPL <NSObject>

@optional;

/**
 view绑定ViewModel

 @param vm 要绑定的viewModel对象, 需要继承自 WDBaseViewModel
 */
- (void)bindWithViewModel:(id)vm;

@end
