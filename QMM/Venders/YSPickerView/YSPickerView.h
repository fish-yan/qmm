//
//  YSPickerView.h
//  EasyAnniversaryBook
//
//  Created by Joseph Koh on 2018/9/11.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSPickerViewModel.h"


typedef NS_ENUM(NSInteger, YSPickerViewType) {
    YSPickerViewTypeSingle = 1,
    YSPickerViewTypeDouble,
    YSPickerViewTypeTriple,
    YSPickerViewTypeDate,
};


@interface YSPickerView : UIView

@property (nonatomic, assign) YSPickerViewType type;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) void(^sureHander)(NSArray<YSPickerViewModel *> *arr);

@property (nonatomic, copy) NSString *tips;


/// DatePicker显示时间,
@property (nonatomic, strong) NSDate *displayDate;
/// DatePicker限制的最小时间
@property (nonatomic, strong) NSDate *minimumDate;
/// DatePicker限制的最大时间
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, assign) BOOL mutilComponentSameData;
@property (nonatomic, assign) BOOL showTime;

+ (instancetype)pickerViewWithType:(YSPickerViewType)type;

/// 如果是时间选择器, dataArray 设置 nil
- (void)showPickerViewWithDataArray:(NSArray<YSPickerViewModel *> *)dataArray
                         sureHandle:(void(^)(NSArray<YSPickerViewModel *> *arr))sureHander;

- (void)showPickerView;


/// 点击后要显示选中的内容, 如果是日期用 yyyy-MM-dd 格式
- (void)selectRowByDisplayName:(NSString *)name;

@end

