//
//  QMMSupplementaryBaseVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewController.h"
#import "QMMSupplementaryVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMSupplementaryBaseVC : YSBaseViewController

@property (nonatomic, strong) UIButton *goBackBtn;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *stepLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) QMMSupplementaryVM *viewModel;

- (void)setupSubviews;
- (void)setupSubviewsLayout;

@end

NS_ASSUME_NONNULL_END
