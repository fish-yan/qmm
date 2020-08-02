//
//  YSSplashVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/27.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSSplashVM.h"

@implementation YSSplashVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    NSInteger numb = 4;
    NSMutableArray *imagesArrayM = [NSMutableArray arrayWithCapacity:numb];
    for (int i = 0; i < numb; i++) {
        [imagesArrayM addObject:[NSString stringWithFormat:@"Image-%d.png", i+1]];
    }
    self.imagesArray = imagesArrayM.copy;
}

@end
