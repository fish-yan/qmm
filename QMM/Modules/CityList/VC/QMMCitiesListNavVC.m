//
//  QMMCitiesListNavVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMCitiesListNavVC.h"
#import "QMMCitiesListVC.h"

@interface QMMCitiesListNavVC ()

@end

@implementation QMMCitiesListNavVC

+ (void)load {
    [self mapName:@"kModuleCitiesList" withParams:nil];
}

- (instancetype)init {
    QMMCitiesListVC *vc = [QMMCitiesListVC new];
    if (self = [super initWithRootViewController:vc]) {
        
    }
    return self;
}

@end
