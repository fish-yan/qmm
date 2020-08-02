//
//  QMMContactCellViewModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"
#import "QMMContactItemVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMContactCellViewModel : YSBaseViewModel

@property (nonatomic, strong) QMMContactItemVM *leftViewModel;
@property (nonatomic, strong) QMMContactItemVM *rightViewModel;

@end

NS_ASSUME_NONNULL_END
