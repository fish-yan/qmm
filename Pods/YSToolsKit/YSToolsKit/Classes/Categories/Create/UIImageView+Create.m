//
//  UIImageView+Create.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "UIImageView+Create.h"
#import <objc/runtime.h>

static const void * kImageViewPrivateKey = &"kImageViewPrivateKey";

@interface UIImageView()

@property (nonatomic, copy) void(^__actionCaller)(UIImageView *imgView, UIGestureRecognizer *tap);

@end

@implementation UIImageView (Create)

- (void)set__actionCaller:(void (^)(UIImageView *, UIGestureRecognizer *))__actionCaller {
    objc_setAssociatedObject(self, kImageViewPrivateKey, __actionCaller, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIImageView *, UIGestureRecognizer *))__actionCaller {
    return objc_getAssociatedObject(self, kImageViewPrivateKey);
}

+ (instancetype)imageViewWithImageName:(NSString *)imgName
                                inView:(__kindof UIView *)inView {
    UIImageView *imgView = [[UIImageView alloc] init];
    if (imgName && ![imgName isEqualToString:@""]) {
        imgView.image = [UIImage imageNamed:imgName];
    }
    if (inView && [inView isKindOfClass:[UIView class]]) {
        [inView addSubview:imgView];
    }
    return imgView;
}

+ (instancetype)imageViewWithImageName:(NSString *)imgName
                                inView:(__kindof UIView *)inView
                             tapAction:(void(^)(UIImageView *imgView, UIGestureRecognizer *tap))tapAction {
    UIImageView *imgView = [self imageViewWithImageName:imgName inView:inView];
    
    if (tapAction) {
        imgView.userInteractionEnabled = YES;
        imgView.__actionCaller = tapAction;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(__tapAction:)];
        [imgView addGestureRecognizer:tap];
    }
    
    return imgView;
}

+ (void)__tapAction:(UITapGestureRecognizer *)tap {
    UIImageView *imgView = (UIImageView *)tap.view;
    if (imgView.__actionCaller) {
        imgView.__actionCaller(imgView, tap);
    }
}

@end
