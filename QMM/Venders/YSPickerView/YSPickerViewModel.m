//
//  YSPickerViewModel.m
//  EasyAnniversaryBook
//
//  Created by Joseph Koh on 2018/9/11.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSPickerViewModel.h"

@implementation YSPickerViewModel

+ (instancetype)modelWithName:(NSString *)name mid:(NSNumber *)mid {
    YSPickerViewModel *m = [YSPickerViewModel new];
    m.name = name;
    m.mid = mid;
    return m;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, name: %@, mid: %@, subArr: %@>",
            NSStringFromClass([self class]),
            self,
            self.name,
            self.mid,
            self.subArr];
}

@end
