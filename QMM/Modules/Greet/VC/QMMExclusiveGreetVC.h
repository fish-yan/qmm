//
//  QMMExclusiveGreetVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMExclusiveGreetVC : YSBaseViewController

@property (nonatomic, copy) void(^cancleClickHandler)(void);
@property (nonatomic, copy) void(^submitClickHandler)(NSString *content);

@end

NS_ASSUME_NONNULL_END
