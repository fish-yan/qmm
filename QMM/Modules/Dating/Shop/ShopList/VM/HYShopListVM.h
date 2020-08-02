//
//  HYShopListVM.h
//  youbaner
//
//  Created by Joseph Koh on 2018/6/24.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseViewModel.h"
#import "SCNavigationMenuView.h"

@interface SCMenuItem : NSObject <SCNavigationMenuItemProtocol>

@property (nonatomic, strong) NSString *title;

@end


@interface HYShopListVM : YSBaseViewModel

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray<SCMenuItem *> *menuItems;

@property (nonatomic, assign) BOOL isSearchByCity;
@property (nonatomic, copy) NSString *cityName;

- (void)requestDataWithSuccessHandler:(void(^)(NSArray *arr))success failure:(void(^)(NSError *error))failure;
- (void)requestMoreDataWithSuccessHandler:(void(^)(NSArray *arr))success failure:(void(^)(NSError *error))failure;
@end
