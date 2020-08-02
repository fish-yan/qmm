//
//  QMMLocation.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMMCoordinate : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end

@interface QMMLocation : NSObject

@property (nonatomic, strong) QMMCoordinate *coordinate;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *citycode;
@property (nonatomic, copy) NSString *adcode;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *POIName;
@property (nonatomic, copy) NSString *AOIName;

@end

NS_ASSUME_NONNULL_END
