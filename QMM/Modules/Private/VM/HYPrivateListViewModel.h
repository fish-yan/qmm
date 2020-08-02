//
//  HYPrivateListViewModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYPrivateListViewModel : YSBaseViewModel

@property(nonatomic ,strong) RACCommand * doCommand;
@property(nonatomic ,assign) int page;
@property(nonatomic ,assign) int count;

@property(nonatomic ,strong) NSArray * listArray;

@property(nonatomic ,strong) RACCommand * dodeleteCommand;

@end

NS_ASSUME_NONNULL_END
