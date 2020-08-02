//
//  HYShopListCell.h
//  youbaner
//
//  Created by Joseph Koh on 2018/6/24.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseTableViewCell.h"
#import "HYShopInfoModel.h"

@interface HYShopListCell : YSBaseTableViewCell

@property (nonatomic, strong) HYShopInfoModel *model;
@property (nonatomic, assign) BOOL isCitySearch;

@end
