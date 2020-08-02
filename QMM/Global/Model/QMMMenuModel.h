//
//  QMMMenuModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMMMenuModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *menuId;
@property (nonatomic, strong) UIViewController *contentVC;


+ (instancetype)modelWithTitle:(NSString *)title contentVC:(UIViewController *)contentVC andID:(NSString *)mId;

@end

NS_ASSUME_NONNULL_END
