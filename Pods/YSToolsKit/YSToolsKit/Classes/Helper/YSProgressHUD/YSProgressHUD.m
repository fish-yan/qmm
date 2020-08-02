//
//  YSProgressHUD.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/11.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSProgressHUD.h"
#import "MBProgressHUD.h"

#define TIPS_DURATION 1.5

@interface YSProgressHUD ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation YSProgressHUD

+ (instancetype)shareHUD {
    static dispatch_once_t onceToken;
    static YSProgressHUD *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[YSProgressHUD alloc] init];
    });
    return instance;
}

+ (void)showTips:(NSString *)tips {
    YSProgressHUD *obj = [YSProgressHUD shareHUD];
    [obj.hud hideAnimated:YES];
    
    obj.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    obj.hud.label.text = tips;
    obj.hud.mode = MBProgressHUDModeText;
    obj.hud.contentColor = [UIColor whiteColor];
    obj.hud.bezelView.color = [UIColor colorWithWhite:0.0 alpha:0.6];
    obj.hud.margin = 10.0;
    obj.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIPS_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [obj.hud hideAnimated:YES];
    });
}

+ (void)showInView:(UIView *)inView {
    if (!inView) {
        inView = [UIApplication sharedApplication].keyWindow;
    }
    return [self showInView:inView withTitle:@"努力加载中..."];
}

+ (void)showInView:(UIView *)inView withTitle:(NSString *)title {
    YSProgressHUD *obj = [YSProgressHUD shareHUD];    
    [obj.hud hideAnimated:YES];
    
    obj.hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    obj.hud.animationType = MBProgressHUDAnimationFade;
    obj.hud.mode = MBProgressHUDModeCustomView;
//    obj.hud.bezelView.color = [UIColor clearColor];
    obj.hud.contentColor = [UIColor whiteColor];
    obj.hud.bezelView.color = [UIColor colorWithWhite:0.0 alpha:0.6];
    obj.hud.margin = 10.0;
    obj.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    if (title) {
        obj.hud.label.text = title;
        obj.hud.label.font = [UIFont systemFontOfSize:14.];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *imageView = [[UIImageView alloc] init];

        NSArray *animationImages = [self animationImages];
        imageView.animationImages = animationImages;
        imageView.animationDuration = 0.12 * animationImages.count;
        imageView.animationRepeatCount = 0;
        [imageView startAnimating];
        
        obj.hud.customView = imageView;
    });
}

+ (NSArray *)animationImages {
    NSMutableArray *imgs = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i < 8; i++) {
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d", i+1]];
        if (img) [imgs addObject:img];
    }
    
    return imgs;
}

+ (void)hiddenHUD {
    YSProgressHUD *obj = [YSProgressHUD shareHUD];
    [obj.hud hideAnimated:YES];
}

+ (void)showIndeterminate {
    [self showIndeterminateWithTitle:nil];
}

+ (void)showIndeterminateWithTitle:(NSString *)title {
    YSProgressHUD *obj = [YSProgressHUD shareHUD];
    [obj.hud hideAnimated:YES];

    
    obj.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    obj.hud.animationType = MBProgressHUDAnimationFade;
    obj.hud.label.font = [UIFont systemFontOfSize:14.];
    obj.hud.contentColor = [UIColor whiteColor];
    obj.hud.bezelView.color = [UIColor colorWithWhite:0.0 alpha:0.6];
    obj.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    obj.hud.margin = 10.0;
    if (title) obj.hud.label.text = title;
}

@end
