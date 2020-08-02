//
//  LocationHelper.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "QMMLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationHelper : NSObject

+ (instancetype)shareHelper;

@property (nonatomic, strong) QMMCoordinate *coordinate;
@property (nonatomic, strong) QMMLocation *location;

- (void)getLocationWithResult:(void(^)(QMMLocation *location, NSError *error))rst;

@end

NS_ASSUME_NONNULL_END
