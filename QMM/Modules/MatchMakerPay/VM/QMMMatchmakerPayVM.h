//
//  QMMMatchmakerPayVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"
#import "QMMMatchmakerPayCellModel.h"
#import "IAPHelperViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMMatchmakerPayVM : IAPHelperViewModel

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger itemSelectedIdx;

- (NSArray *)updateDataArray:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
