//
//  HYTopPayVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "IAPHelperViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYTopPayVM : IAPHelperViewModel

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger itemSelectedIdx;
@property (nonatomic, copy) NSString *tips;

- (NSArray *)updateDataArray:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
