//
//  QMMLocation.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMLocation.h"

@implementation QMMCoordinate

@end

@implementation QMMLocation

- (instancetype)init {
    if (self = [super init]) {
        self.coordinate = [QMMCoordinate new];
    }
    return self;
}

@end
