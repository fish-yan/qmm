//
//  HYPersonActionView.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYPersonActionView : UIView

@property (nonatomic, strong) UIButton *heartBtn;
@property (nonatomic, strong) UIButton *dateBtn;
@property (nonatomic, strong) UIButton *msgBtn;

+ (instancetype)viewWithHeartClickAction:(void(^)(UIButton *btn))heartAction
                         dateClickAction:(void(^)(UIButton *btn))dateAction
                      messageClickAction:(void(^)(UIButton *btn))messageAction;

@end

NS_ASSUME_NONNULL_END
