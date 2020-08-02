//
//  QMMLoginRegisterBaseVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewController.h"
#import "QMMLoginRegisterVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMLoginRegisterBaseVC : YSBaseViewController

@property (nonatomic, strong) QMMLoginRegisterVM *viewModel;
@property (nonatomic, strong) UIButton *goBackBtn;

@end

NS_ASSUME_NONNULL_END
