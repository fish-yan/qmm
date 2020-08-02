//
//  QMMRootTabBarVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMRootTabBarVM.h"

@implementation QMMRootTabBarVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    @weakify(self);
    self.configVCSignal = [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber> _Nonnull subscriber) {
        @strongify(self);
        [subscriber sendNext:[self configControllers]];
        [subscriber sendCompleted];
        return nil;
    }];
}
//QMMCompleteInfoVC
//QMMMeetingVC
- (NSArray *)configInfo {
    return @[@{
                 @"title": @"遇见",
                 @"img": @"tabBar_1",
                 @"vcName": @"QMMMeetingVC"
                 },
             @{
                 @"title": @"私信",
                 @"img": @"tabBar_2",
                 @"vcName": @"HYPrivateListViewController"
                 },
             @{
                 @"title": @"约会",
                 @"img": @"tabBar_3",
                 @"vcName": @"HYDatingViewController"
                 },
             @{
                 @"title": @"通讯录",
                 @"img": @"tabBar_4",
                 @"vcName": @"QMMContactContainerVC"
                 },
             @{
                 @"title": @"我",
                 @"img": @"tabBar_5",
                 @"vcName": @"QMMProfileVC"
                 },
             ];
}

- (NSArray *)configControllers {
    NSArray *array = [self configInfo];
    __block NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        UIImage *normalImage   = [UIImage imageNamed:[NSString stringWithFormat:@"%@_n", obj[@"img"]]];
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_s", obj[@"img"]]];
        UIViewController *vc   = [self viewControllerWithControllerClassString:obj[@"vcName"]
                                                                       title:obj[@"title"]
                                                       tabBarItemNormalImage:normalImage
                                                               selectedImage:selectedImage];
        vc.view.tag = idx + 88;
        [controllers addObject:vc];
    }];
    return controllers;
}


- (__kindof UIViewController *)viewControllerWithControllerClassString:(NSString *)classStr
                                                                 title:(NSString *)title
                                                 tabBarItemNormalImage:(UIImage *)normalImage
                                                         selectedImage:(UIImage *)selectedImage {
    UIViewController *vc                   = [[NSClassFromString(classStr) alloc] init];
    vc.title                               = title;
    YSNavigationController *nav            = [[YSNavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 100);
    nav.tabBarItem.imageInsets             = UIEdgeInsetsMake(8, 0, -8, 0);
    [nav.tabBarItem setSelectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nav.tabBarItem setImage:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [nav.tabBarItem setBadgeValue:nil];
    if (@available(iOS 10.0, *)) {
        [nav.tabBarItem setBadgeTextAttributes:@{
                                                 NSFontAttributeName: [UIFont systemFontOfSize:5]
                                                 }
                                      forState:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
    }
    return nav;
}


@end
