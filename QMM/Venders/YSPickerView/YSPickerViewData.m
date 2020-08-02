//
//  YSPickerViewData.m
//  EasyAnniversaryBook
//
//  Created by Joseph Koh on 2018/9/11.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSPickerViewData.h"

@implementation YSPickerViewData

+ (instancetype)shareData {
    static dispatch_once_t onceToken;
    static YSPickerViewData *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [YSPickerViewData new];
    });
    return instance;
}


- (NSArray *)places {
    if (_places) {
        return _places;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area.json" ofType:nil];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                                         options:NSJSONReadingMutableLeaves
                                                           error:&error];
    if (error) return nil;
    NSArray *dataArr = dict[@"data"];
    if (dataArr.count == 0) return nil;
    
    NSArray *arr = [self searchData:dataArr level:1 byID:nil];
    _places = arr;
    return arr;
}

- (NSArray *)searchData:(NSArray *)dataArr level:(NSInteger)level byID:(NSNumber *)mid {
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *d in dataArr) {
        @autoreleasepool {
            if ([d[@"level"] integerValue] == level) {
                if (mid == nil || d[@"parent"] == mid) {
                    YSPickerViewModel *m = [YSPickerViewModel modelWithName:d[@"name"] mid:d[@"id"]];
                    
                    NSArray *subArr = nil;
                    if (level < 3) {
                        subArr = [self searchData:dataArr level:level+1 byID:m.mid];
                    }
                    m.subArr = subArr;
                    [arrM addObject:m];
                }
            }
        }
        
    }
    return arrM;
}

- (NSArray *)heightRange {
    if (_heightRange) {
        return _heightRange;
    }
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:50];
    for (NSInteger i = 150; i < 200; i++) {
        YSPickerViewModel *m = [YSPickerViewModel modelWithName:[NSString stringWithFormat:@"%tu cm", i] mid:@(i)];
        [arrM addObject:m];
    }
    
    _heightRange = arrM;
    return arrM;
}

- (NSArray *)degree {
    if (_degree) {
        return _degree;
    }
    
    NSArray *arr = @[
                     [YSPickerViewModel modelWithName:@"小学" mid:@(0)],
                     [YSPickerViewModel modelWithName:@"高中" mid:@(1)],
                     [YSPickerViewModel modelWithName:@"中专" mid:@(2)],
                     [YSPickerViewModel modelWithName:@"本科" mid:@(3)],
                     [YSPickerViewModel modelWithName:@"研究生" mid:@(4)],
                     [YSPickerViewModel modelWithName:@"MBA" mid:@(5)],
                     [YSPickerViewModel modelWithName:@"博士" mid:@(6)],
                     [YSPickerViewModel modelWithName:@"博士后" mid:@(7)],
                     ];
    _degree = arr;
    return arr;
}

- (NSArray *)perfession {
    if (_perfession) {
        return _perfession;
    }
    
    NSArray *arr = @[
                     [YSPickerViewModel modelWithName:@"小学" mid:@(0)],
                     [YSPickerViewModel modelWithName:@"高中" mid:@(1)],
                     [YSPickerViewModel modelWithName:@"中专" mid:@(2)],
                     [YSPickerViewModel modelWithName:@"本科" mid:@(3)],
                     [YSPickerViewModel modelWithName:@"研究生" mid:@(4)],
                     [YSPickerViewModel modelWithName:@"MBA" mid:@(5)],
                     [YSPickerViewModel modelWithName:@"博士" mid:@(6)],
                     [YSPickerViewModel modelWithName:@"博士后" mid:@(7)],
                     ];
    _perfession = arr;
    return arr;
}

- (NSArray *)salary {
    if (_salary) {
        return _salary;
    }
    
    NSArray *arr = @[
                     [YSPickerViewModel modelWithName:@"2k以下" mid:@(0)],
                     [YSPickerViewModel modelWithName:@"2k-5k" mid:@(1)],
                     [YSPickerViewModel modelWithName:@"5k-10k" mid:@(2)],
                     [YSPickerViewModel modelWithName:@"10k-15k" mid:@(3)],
                     [YSPickerViewModel modelWithName:@"15k-25k" mid:@(4)],
                     [YSPickerViewModel modelWithName:@"25k-50k" mid:@(5)],
                     [YSPickerViewModel modelWithName:@"50k-100k" mid:@(6)],
                     [YSPickerViewModel modelWithName:@"100k以上" mid:@(7)],
                     ];
    _salary = arr;
    return arr;
}

- (NSArray *)constellation {
    if (_constellation) {
        return _constellation;
    }
    
    NSArray *arr = @[
                     [YSPickerViewModel modelWithName:@"白羊座" mid:@(0)],
                     [YSPickerViewModel modelWithName:@"金牛座" mid:@(1)],
                     [YSPickerViewModel modelWithName:@"双子座" mid:@(2)],
                     [YSPickerViewModel modelWithName:@"巨蟹座" mid:@(3)],
                     [YSPickerViewModel modelWithName:@"狮子座" mid:@(4)],
                     [YSPickerViewModel modelWithName:@"处女座" mid:@(5)],
                     [YSPickerViewModel modelWithName:@"天秤座" mid:@(6)],
                     [YSPickerViewModel modelWithName:@"天蝎座" mid:@(7)],
                     [YSPickerViewModel modelWithName:@"射手座" mid:@(8)],
                     [YSPickerViewModel modelWithName:@"魔蝎座" mid:@(9)],
                     [YSPickerViewModel modelWithName:@"水瓶座" mid:@(10)],
                     [YSPickerViewModel modelWithName:@"双鱼座" mid:@(11)]
                     ];
    _constellation = arr;
    return arr;
}

- (NSArray *)wantMarrayTime {
    if (_wantMarrayTime) {
        return _wantMarrayTime;
    }
    
    NSArray *arr = @[
                     [YSPickerViewModel modelWithName:@"期望一年内结婚" mid:@(0)],
                     [YSPickerViewModel modelWithName:@"期望二年内结婚" mid:@(1)],
                     [YSPickerViewModel modelWithName:@"期望三年内结婚" mid:@(2)],
                     [YSPickerViewModel modelWithName:@"期望四年内结婚" mid:@(3)],
                     [YSPickerViewModel modelWithName:@"期望五年内结婚" mid:@(4)],
                     [YSPickerViewModel modelWithName:@"时机合适就结婚" mid:@(5)],
                     [YSPickerViewModel modelWithName:@"对的人马上结婚" mid:@(6)],
                     ];
    _wantMarrayTime = arr;
    return arr;
}

- (NSArray *)marryStatus {
    if (_marryStatus) {
        return _marryStatus;
    }
    
    NSArray *arr = @[
                     [YSPickerViewModel modelWithName:@"未婚" mid:@(0)],
                     [YSPickerViewModel modelWithName:@"已婚" mid:@(1)],
                     [YSPickerViewModel modelWithName:@"离异" mid:@(2)],
                     [YSPickerViewModel modelWithName:@"丧偶" mid:@(3)],
                     [YSPickerViewModel modelWithName:@"保密" mid:@(4)],
                     ];
    _marryStatus = arr;
    return arr;
}

- (NSArray *)friendAgeRange {
    if (_friendAgeRange) {
        return _friendAgeRange;
    }
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:63];
    for (int i = 18; i <= 80; i++) {
        YSPickerViewModel *m = [YSPickerViewModel modelWithName:[NSString stringWithFormat:@"%d岁", i] mid:@(i)];
        [arrM addObject:m];
    }
    
    _friendAgeRange = arrM;
    return arrM;
}

- (NSArray *)friendHeightRange {
    if (_friendHeightRange) {
        return _friendHeightRange;
    }
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:63];
    for (int i = 150; i <= 220; i++) {
        YSPickerViewModel *m = [YSPickerViewModel modelWithName:[NSString stringWithFormat:@"%dcm", i] mid:@(i)];
        [arrM addObject:m];
    }
    
    _friendHeightRange = arrM;
    return arrM;
}

- (NSArray *)friendGender {
    if (_friendGender) {
        return _friendGender;
    }
    
    NSArray *arr = @[
                     [YSPickerViewModel modelWithName:@"男" mid:@(0)],
                     [YSPickerViewModel modelWithName:@"女" mid:@(1)],
                     ];
    _friendGender = arr;
    return arr;
}

@end
