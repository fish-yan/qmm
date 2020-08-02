//
//  HYCItiesListVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYCItiesListVC.h"
#import "HYCitiesListContentVC.h"

@interface HYCItiesListVC ()

@end

@implementation HYCItiesListVC

+ (void)load {
    [self mapName:@"kModuleCitiesList" withParams:nil];
}

- (instancetype)init {
    HYCitiesListContentVC *vc = [HYCitiesListContentVC new];
    if (self = [super initWithRootViewController:vc]) {
        
    }
    return self;
}

@end
