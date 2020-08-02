//
//  YSSplashView.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/27.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSSplashView : UIView

@property (nonatomic, strong) RACCommand *showCmd;

- (void)bindWithViewModel:(NSObject *)vm;

@end

NS_ASSUME_NONNULL_END
