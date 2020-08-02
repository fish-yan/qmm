//
//  HYMapInnerOpenHelper.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/25.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYMapInnerOpenHelper.h"

@implementation HYMapInnerOpenHelper

+ (void)showMapSelectorInVC:(UIViewController *)inVC
      withCurrentCoordinate:(QMMCoordinate *)current
              endCoordinate:(QMMCoordinate *)end
                    endName:(NSString *)endName {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    //检查百度
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        UIAlertAction *baiduMapAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *baiduParameterFormat = @"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving";
            NSString *urlString = [[NSString stringWithFormat:
                                    baiduParameterFormat,
                                    current.latitude,
                                    current.longitude,
                                    end.latitude,
                                    end.longitude]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [alertController addAction:baiduMapAction];
    }
    
    //检查高德
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://map/"]]){
//        UIAlertAction *gaodeMap = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            // 起点为“我的位置”，终点为后台返回的address
//            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=%@&did=BGVIS2&dname=%@&dev=0&t=0", self.currentAddress, address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//        }];
//        [alertController addAction:gaodeMap];
//    }
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        UIAlertAction *gaodeMap = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = [[NSString stringWithFormat:
                                    @"iosamap://navi?sourceApplication=%@&poiname=%@&lat=%lf&lon=%lf&dev=1&style=2",@"我想见你",
                                    endName,
                                    end.latitude,
                                    end.longitude]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
            
        [alertController addAction:gaodeMap];
    }
    
    //苹果自带地图
    UIAlertAction *iphoneMap = [UIAlertAction actionWithTitle:@"苹果自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //起点
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        
        //终点
        CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(end.latitude, end.longitude);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate2D addressDictionary:nil];
        MKMapItem *endLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
        
        NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,  MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]};
        
        [MKMapItem openMapsWithItems:@[currentLocation, endLocation] launchOptions:options];
        
    }];
    [alertController addAction:iphoneMap];
    
    
    // 取消
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                   }];
    [alertController addAction:cancel];
    
    
    // 展示
    [inVC presentViewController:alertController animated:YES completion:NULL];
}
@end
