//
//  QMMContactContentVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"
#import "HYContactTitleModel.h"
#import "QMMContactCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMContactContentVM : YSBaseViewModel

@property (nonatomic, strong) RACCommand *fetTitleCmd;
@property (nonatomic, strong) NSArray *titleData;

@property(nonatomic ,strong) RACCommand * getAddresslistRaccommand;
@property(nonatomic ,strong) NSArray  * orginDataArray;
@property(nonatomic ,strong) NSArray * convertArray;
@property(nonatomic, assign) int page;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) RACCommand *markCmd;

@end

NS_ASSUME_NONNULL_END
