//
//  QMMCityModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMCityModel : YSBaseModel

@property (nonatomic, copy) NSString *initchar;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, copy) NSString *platDelivermode3;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *platDelivermode1;
@property (nonatomic, strong) NSNumber *isfarzone;
@property (nonatomic, strong) NSNumber *active;
@property (nonatomic, copy) NSString *platDeliverstatus;
@property (nonatomic, strong) NSNumber *iscity;
@property (nonatomic, copy) NSString *alias;
@property (nonatomic, copy) NSString *supplyOpstatus;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *parent;
@property (nonatomic, copy) NSString *abbrev;
@property (nonatomic, copy) NSString *platDelivermode4;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) NSNumber *isprovince;
@property (nonatomic, copy) NSString *platDelivermode2;
@property (nonatomic, strong) NSNumber *isleaf;
@property (nonatomic, strong) NSNumber *opweight;
@property (nonatomic, strong) NSNumber *opstatus;
@property (nonatomic, copy) NSString *platDelivermode5;

@end

NS_ASSUME_NONNULL_END
