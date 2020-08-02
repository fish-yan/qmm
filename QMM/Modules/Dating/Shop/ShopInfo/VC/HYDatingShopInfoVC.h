//
//  HYDatingShopInfoVC.h
//  youbaner
//
//  Created by Joseph Koh on 2018/6/23.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseViewController.h"
#import "HYShopInfoModel.h"


@interface HYDatingShopInfoVC : YSBaseViewController

@property (nonatomic, strong) NSNumber *isSearch;
@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, copy) void(^selected)(NSDictionary *dict);
@property (nonatomic, strong)  HYShopInfoModel *infoModel;

@end
