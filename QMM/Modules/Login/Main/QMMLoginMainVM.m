//
//  QMMLoginMainVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/11/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMLoginMainVM.h"

@implementation QMMLoginMainVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    NSInteger numb = 3;
    NSMutableArray *imagesArrayM = [NSMutableArray arrayWithCapacity:numb];
    for (int i = 1; i <= numb; i++) {
        [imagesArrayM addObject:[NSString stringWithFormat:@"splash0%d.png", i]];
    }
    self.dataArray = imagesArrayM.copy;
}

@end
