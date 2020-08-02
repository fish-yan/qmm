//
//  HYShopListVM.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/24.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYShopListVM.h"
#import "HYShopInfoModel.h"
#import "LocationHelper.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>


@implementation SCMenuItem

- (NSString *)navigationTitle {
    return self.title ?: @"";
}

- (NSString *)menuTitle {
    return self.title ?: @"";
}

@end



@interface HYShopListVM ()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, copy) void(^successHandler)(NSArray *arr);
@property (nonatomic, copy) void(^failureHandler)(NSError *error);
@property (nonatomic, strong) NSDictionary *citiesPingyin;

@property (nonatomic, assign) NSInteger totalCount;

@end

@implementation HYShopListVM

- (void)setObj:(id)obj {
    
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self initAmap];
    self.citiesPingyin = [self loadCitiesPingyin];
    if ([LocationHelper shareHelper].coordinate) {
        self.cityName = [LocationHelper shareHelper].location.city;
    }
}

- (NSDictionary *)loadCitiesPingyin {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city_pingyin.json"
                                                                                  ofType:nil]];
    NSError *error = nil;
    NSDictionary *dist = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableLeaves
                                                           error:&error];
    if (error) {
        NSLog(@"获取城市拼音字典失败: %@", error);
        return nil;
    }
    return dist;
}

- (void)initAmap {
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)requestDataWithSuccessHandler:(void(^)(NSArray *arr))success failure:(void(^)(NSError *error))failure {
    self.flag = @1;
    @weakify(self);
    [self fetchDataWithSuccessHandler:^(NSArray *arr) {
        @strongify(self);
        self.dataArray = arr;
        self.hasMore = (arr.count < self.totalCount);
        
        if (success) {
            success(self.dataArray);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



- (void)requestMoreDataWithSuccessHandler:(void(^)(NSArray *arr))success failure:(void(^)(NSError *error))failure {
    NSInteger page = [self.flag integerValue] + 1;
    self.flag = @(page);
    
    @weakify(self);
    [self fetchDataWithSuccessHandler:^(NSArray *arr) {
        @strongify(self);
        NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.dataArray];
        [arrM addObjectsFromArray:arr];
        
        self.dataArray = arrM.copy;
        self.hasMore = ([self.flag integerValue] <= self.totalCount);
        
        if (success) {
            success(self.dataArray);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)fetchDataWithSuccessHandler:(void(^)(NSArray *arr))success failure:(void(^)(NSError *error))failure {
    self.successHandler = success;
    self.failureHandler = failure;
    
    // 如果选择的城市是当前所在城市, 则以定位周围搜索
    // 如果是其他城市, 以其他城市名搜索
    @weakify(self);
    [[LocationHelper shareHelper] getLocationWithResult:^(QMMLocation *location, NSError *error) {
        @strongify(self);
        if (error) {
            [YSProgressHUD showTips:@"获取定位失败"];
            if (self.failureHandler) {
                self.failureHandler(error);
            }
            return;
        }
        
        [self searchPoi];
    }];
    
    
}


#pragma mark - AMap

- (void)searchPoi {
    if (self.cityName == nil || [[LocationHelper shareHelper].location.city containsString:self.cityName]) {
        self.isSearchByCity = NO;
        [self startSearchPoiAround];
    }
    else {
        self.isSearchByCity = YES;
        [self startSearchPoiKeyword];
    }
}

// 在指定的范围内搜索POI
- (void)startSearchPoiAround {
    QMMLocation *location = [LocationHelper shareHelper].location;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];

    request.location =
    [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];

    request.keywords         = @"餐饮服务";
    request.sortrule         = 0;    //按照距离排序.
    request.requireExtension = YES;
    request.radius           = 50000;
    request.page             = [self.flag integerValue];
    request.offset           = 20;    // 每页20条
    
    [self.search AMapPOIAroundSearch:request];
}

// 关键字搜索poi
- (void)startSearchPoiKeyword {
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = @"餐饮服务";
    request.city                = self.cityName ?: @"上海";
    request.types               = @"餐饮服务";
    request.requireExtension    = YES;
    request.page                = [self.flag integerValue];
    request.offset              = 20;    // 每页20条
//    request.cityLimit           = YES;
//    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
}


#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    if (error) {
        if (self.failureHandler) {
            self.failureHandler(error);
        }
        return;
    }

}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    self.totalCount = response.count;
    
    if (response.pois.count == 0) {
        if (self.successHandler) {
            self.successHandler(self.dataArray);
        }
        return;
    }
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            HYShopInfoModel *model = [HYShopInfoModel new];
            model.name = obj.name;
            model.address = obj.address;
            model.businessArea = obj.district;
            model.tel = obj.tel;
            model.type = [self covertedType:obj.type];
            model.images = [self covertedImages:obj.images];
            model.city = [self pingyinOfString:obj.city];
            model.price = obj.extensionInfo.cost;
            model.range = obj.distance;
            
            QMMLocation *location = [QMMLocation new];
            QMMCoordinate *coordinate = [QMMCoordinate new];
            coordinate.latitude = obj.location.latitude;
            coordinate.longitude = obj.location.longitude;
            location.coordinate = coordinate;
            model.location = location;
            
            [arrM addObject:model];
        }
       
    }];
    

    if (self.successHandler) {
        self.successHandler(arrM.copy);
    }
}

- (NSString *)pingyinOfString:(NSString *)city {
    NSString *zhongwen = city.mutableCopy;
    if ([city containsString:@"市"]) {
        zhongwen = [city substringToIndex:(city.length - 1)];
    }
    
    return self.citiesPingyin[zhongwen];
}

- (NSString *)covertedType:(NSString *)type {
    NSArray *arr = [type componentsSeparatedByString:@";"];
    return arr.lastObject;
}

- (NSArray *)covertedImages:(NSArray<AMapImage *> *)mapImages {
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:mapImages.count];
    [mapImages enumerateObjectsUsingBlock:^(AMapImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrM addObject:obj.url ?: @""];
    }];
    return arrM.copy;
}

@end
