//
//  HYDatingShopInfoVM.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/24.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYDatingShopInfoVM.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "LocationHelper.h"

@interface HYDatingShopInfoVM ()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;
/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
@property (nonatomic, strong) NSDictionary *citiesPingyin;
@property (nonatomic, copy) void(^searchRst)(HYShopInfoModel *infoModel, NSError *error);

@end

@implementation HYDatingShopInfoVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.citiesPingyin = [self loadCitiesPingyin];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

}


- (void)fetchShopInfo:(NSString *)address withResult:(void(^)(HYShopInfoModel *infoModel, NSError *error))rst {
    self.searchRst = rst;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = address;
    [self.search AMapPOIKeywordsSearch:request];
}


/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        if (self.searchRst) {
            NSError *error = [NSError errorWithDomain:@"com.seeyou"
                                                 code:11111
                                             userInfo:@{NSLocalizedDescriptionKey: @"未查到相关信息"}];
            self.searchRst(nil, error);
        }
        return;
    }
    
    
    AMapPOI *obj = [response.pois firstObject];
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
    
    self.infoModel = model;
    if (self.searchRst) {
        self.searchRst(model, nil);
    }
}

- (void)fetchTrainsitionInfo {
    QMMCoordinate *current = [LocationHelper shareHelper].coordinate;
    QMMCoordinate *end = self.infoModel.location.coordinate;
    self.startCoordinate        = CLLocationCoordinate2DMake(current.latitude, current.longitude);
    self.destinationCoordinate  = CLLocationCoordinate2DMake(end.latitude, end.longitude);
    
    [self searchRoutePlanningBus];
}

#pragma mark - do search
- (void)searchRoutePlanningBus {
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.city             = self.infoModel.city ?: @"shanghai";
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapTransitRouteSearch:navi];
}


#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"获取交通指引失败: Error: %@", error);
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    if (response.route == nil) {
        return;
    }
    NSArray *transits = response.route.transits;
    NSMutableArray *transitArrM = [NSMutableArray arrayWithCapacity:transits.count];
    for (AMapTransit *transit in transits) {
        for (AMapSegment *segment in transit.segments) {
            NSString *exitName = segment.exitName;
            
            for (AMapBusLine *busline in segment.buslines) {
                NSMutableDictionary *dict = [NSMutableDictionary new];
                [dict setObject:busline.type forKey:@"type"];
                [dict setObject:busline.name forKey:@"name"];
                [dict setObject:busline.arrivalStop.name ?:@"" forKey:@"arrivalName"];
                [dict setObject:exitName ?:@"" forKey:@"exitName"];
                
                [transitArrM addObject:dict];
            }
        }
    }
    
    NSLog(@"----%@", transitArrM);
    self.trainsitInfo = [self mapTransitData:transitArrM];
}

- (NSString *)mapTransitData:(NSArray *)data {
    NSMutableString *strM = [NSMutableString string];
    for (NSDictionary *dict in data) {
        [strM appendString:[NSString stringWithFormat:@"%@  %@ %@ %@\n\n",
                            dict[@"type"],
                            dict[@"name"],
                            dict[@"arrivalName"],
                            dict[@"exitName"]]];
    }
    return strM.copy;
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
