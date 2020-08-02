//
//  YSPickerViewData.h
//  EasyAnniversaryBook
//
//  Created by Joseph Koh on 2018/9/11.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSPickerViewModel.h"


@interface YSPickerViewData : NSObject

@property (nonatomic, strong) NSArray<YSPickerViewModel *> *places;
@property (nonatomic, strong) NSArray<YSPickerViewModel *> *heightRange;
@property (nonatomic, strong) NSArray<YSPickerViewModel *> *degree;
@property (nonatomic, strong) NSArray<YSPickerViewModel *> *perfession;
@property (nonatomic, strong) NSArray<YSPickerViewModel *> *salary;
@property (nonatomic, strong) NSArray<YSPickerViewModel *> *constellation;
@property (nonatomic, strong) NSArray<YSPickerViewModel *> *wantMarrayTime;
@property (nonatomic, strong) NSArray<YSPickerViewModel *> *marryStatus;
@property (nonatomic, strong) NSArray<YSPickerViewModel *> *friendAgeRange;
@property (nonatomic, strong) NSArray<YSPickerViewModel *> *friendHeightRange;
@property (nonatomic, strong) NSArray<YSPickerViewModel *> *friendGender;

+ (instancetype)shareData;

@end
