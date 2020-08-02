//
//  HYFilterVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"
#import "QMMFilterRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYFilterVM : YSBaseViewModel

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) BOOL hasBuyMatchMaker;

@property (nonatomic, strong) NSMutableDictionary *filterInfo;

@property (nonatomic, strong) QMMFilterRecordModel *recordModel;

@end

NS_ASSUME_NONNULL_END
