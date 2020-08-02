//
//  YSBaseViewModel.m
//  MyProject
//
//  Created by Joseph Gao on 2017/4/30.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSBaseViewModel.h"

@implementation YSBaseViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self __initialize];
    }
    return self;
}

- (void)__initialize {
    self.flag = @0;
}

+ (instancetype)viewModel {
    YSBaseViewModel *vm = [[self alloc] init];
    return vm;
}

// 实现的目的是为了避免子类调用 +viewModelWithObj:, 而没有实现导致的crash
+ (instancetype)viewModelWithObj:(id)obj {
    YSBaseViewModel *vm = [[YSBaseViewModel alloc] init];
    [vm setObj:obj];
    return vm;
}

- (void)setObj:(id)obj {
    
}

@end
