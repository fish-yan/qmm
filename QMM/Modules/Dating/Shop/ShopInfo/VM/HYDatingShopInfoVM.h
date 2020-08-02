//
//  HYDatingShopInfoVM.h
//  youbaner
//
//  Created by Joseph Koh on 2018/6/24.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseViewModel.h"
#import "HYShopInfoModel.h"

@interface HYDatingShopInfoVM : YSBaseViewModel

@property (nonatomic, copy) NSString *trainsitInfo;
//@property (nonatomic, strong) QMMCoordinate *location;
@property (nonatomic, strong) HYShopInfoModel *infoModel;

- (void)fetchTrainsitionInfo;

- (void)fetchShopInfo:(NSString *)address withResult:(void(^)(HYShopInfoModel *infoModel, NSError *error))rst;

@end
