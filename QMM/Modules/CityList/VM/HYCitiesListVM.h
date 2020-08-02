//
//  HYCitiesListVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYCitiesListVM : YSBaseViewModel

@property (nonatomic, strong) RACCommand *fetchCitiesCmd;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *indexArr;

@end

NS_ASSUME_NONNULL_END
