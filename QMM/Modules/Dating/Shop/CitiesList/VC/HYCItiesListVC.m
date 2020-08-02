//
//  HYCItiesListVC.m
//  SeeYou
//
//  Created by Joseph Koh on 2018/7/7.
//  Copyright © 2018 luzhongchang. All rights reserved.
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"---%@", self.topViewController);
}

@end
