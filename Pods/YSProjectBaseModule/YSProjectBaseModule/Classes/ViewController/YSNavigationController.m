//
//  YSNavigationController.m
//  MyProject
//
//  Created by Joseph Gao on 2017/4/30.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSNavigationController.h"

@interface YSNavigationController ()

@end

@implementation YSNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        __strong typeof(self) self = weakSelf;
        self.interactivePopGestureRecognizer.delegate = self;

        self.delegate = self;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }

    [super pushViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }

    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }

    return [super popToViewController:viewController animated:animated];
}


#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }

    return YES;
}

- (void)setNavigationBarDefaultAppearance {
    [self.navigationBar setBackgroundImage:[self barBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{
                                                 NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                 NSForegroundColorAttributeName: [UIColor blackColor]
                                                 }];
    [self setBackButtonWithImage];

    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)]) {
        [[UINavigationBar appearance] setShadowImage:[self imageWithColor:[UIColor colorWithHexString:@"#f6f6f6"]
                                                                     size:CGSizeMake(SCREEN_WIDTH, 1)]];
    }
}

- (void)setBackButtonWithImage {
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    UIImage *img                                                  = [UIImage imageNamed:@"ic_nav_back"];
    [UINavigationBar appearance].backIndicatorImage               = img;
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = img;
    [UINavigationBar appearance].tintColor                        = [UIColor colorWithHexString:@"#313131"];
}

- (UIImage *)barBackgroundImage {
    return [UIImage imageOfGradientColorWithColors:@[[UIColor colorWithHexString:@"ffffff"],
                                                     [UIColor colorWithHexString:@"ffffff"]]
                                         locations:@[@0, @1.0]
                                      andImageSize:CGSizeMake(SCREEN_WIDTH, 64)];
}

- (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


@end
