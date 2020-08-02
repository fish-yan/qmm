//
//  LocationHelper.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "LocationHelper.h"

@interface LocationHelper ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) void(^callBack)(QMMLocation *location, NSError *error);

@end

@implementation LocationHelper


+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    static LocationHelper *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [LocationHelper new];
        [instance initAmap];
    });
    return instance;
}

- (void)initAmap {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
}
- (void)getLocationWithResult:(void(^)(QMMLocation *location, NSError *error))rst {
    self.callBack = rst;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed) {
                if (self.callBack) {
                    self.callBack(nil, error);
                }
                
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode) {
            NSLog(@"reGeocode:%@", regeocode);
            QMMLocation *loc = [QMMLocation new];
            loc.country = regeocode.country;
            loc.city = regeocode.city;
            loc.district = regeocode.district;
            loc.citycode = regeocode.citycode;
            loc.adcode = regeocode.adcode;
            loc.street = regeocode.street;
            loc.number = regeocode.number;
            loc.POIName = regeocode.POIName;
            loc.AOIName = regeocode.AOIName;
            
            QMMCoordinate *coordinate = [QMMCoordinate new];
            coordinate.latitude = location.coordinate.latitude;
            coordinate.longitude = location.coordinate.longitude;
            
            loc.coordinate = coordinate;
            self.coordinate = coordinate;
            self.location = loc;
            
            if (self.callBack) {
                self.callBack(loc, nil);
            }
        }
    }];
}
//
//
////开始定位
//- (void)startSerialLocation {
//    NSLog(@"============> 开始定位 <============");
//    [self.locationManager startUpdatingLocation];
//}
//
/////停止定位
//- (void)stopSerialLocation {
//    NSLog(@"============> 停止定位 <============");
//    [self.locationManager stopUpdatingLocation];
//}
//
///// 定位错误
//- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"============> 定位失败 <============");
//    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
//    if (self.callBack) {
//        self.callBack(nil, error);
//    }
//    [self stopSerialLocation];
//}
//
/////定位结果
//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
//    NSLog(@"============> 定位成功 <============");
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
//
//    QMMCoordinate *coordinate = [QMMCoordinate new];
//    coordinate.latitude = location.coordinate.latitude;
//    coordinate.longitude = location.coordinate.longitude;
//
//    self.coordinate = coordinate;
//
//    if (self.callBack) {
//        self.callBack(coordinate, nil);
//    }
//    [self stopSerialLocation];
//}

@end
