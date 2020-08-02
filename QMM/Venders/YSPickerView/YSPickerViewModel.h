//
//  YSPickerViewModel.h
//  EasyAnniversaryBook
//
//  Created by Joseph Koh on 2018/9/11.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YSPickerViewModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *mid;
@property (nonatomic, strong) NSArray *subArr;

+ (instancetype)modelWithName:(NSString *)name mid:(NSNumber *)mid;

@end
