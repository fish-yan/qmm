//
//  YSBaseViewController.m
//  MyProject
//
//  Created by Joseph Gao on 2017/4/30.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSBaseViewController.h"

@interface YSBaseViewController ()

@end

@implementation YSBaseViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.canBack = YES;
    
}

- (void)setCanBack:(BOOL)canBack {
    _canBack = canBack;
    if (canBack) {
        UIImage *image = [[UIImage imageNamed:@"ic_nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithImage:image
                                                 style:UIBarButtonItemStyleDone
                                                 target:self
                                                 action:@selector(popBack)];;
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)popBack {
    [self.view endEditing:YES];
    
    if (self.presentingViewController) {
        if (self.navigationController && self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
