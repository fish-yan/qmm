//
//  HYTopPayVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYTopPayVM.h"
#import "HYPopDataModel.h"
#import <StoreKit/StoreKit.h>

@implementation HYTopPayVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.tips = @"开通后，【遇见】页面置顶显示您的排名，海量异性消息，收到你手软。";
    self.productIdentifiers = @[@"zhiding0003", @"zhiding0002", @"zhiding0001"];
    self.identifier = self.productIdentifiers[0];
    self.dataArray = @[
                       @{@"title": @"首页置顶7天", @"price": @"¥588.00", @"desc": @"首页置顶7天，增加您的曝光度"},
                       @{@"title": @"首页置顶3天", @"price": @"¥268.00", @"desc": @"首页置顶3天，增加您的曝光度"},
                       @{@"title": @"首页置顶1天", @"price": @"¥98.00", @"desc": @"首页置顶1天，增加您的曝光度"},
                       ];
    
}

- (void)setItemSelectedIdx:(NSInteger)itemSelectedIdx {
    _itemSelectedIdx = itemSelectedIdx;
    
    self.identifier = self.productIdentifiers[itemSelectedIdx];
}

- (NSArray *)sortPrice:(NSArray<SKProduct *> *)products {
    NSArray *arr = [products sortedArrayUsingComparator:^NSComparisonResult(SKProduct * _Nonnull obj1, SKProduct * _Nonnull obj2) {
        return [obj2.price compare:obj1.price];
    }];
    return arr;
}


- (NSArray *)updateDataArray:(NSArray *)dataList {
    NSMutableArray *dataArray = [NSMutableArray array];
    NSArray *data = [self sortPrice:dataList];
    for (NSInteger i = 0; i < data.count; i++) {
        SKProduct *product = data[i];
        
        NSLog(@"SKProduct id：%@\t产品标题：%@\t描述信息：%@ \t价格：%@",
              product.productIdentifier,
              product.localizedTitle,
              product.localizedDescription,
              product.price);
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
        
        [dataArray addObject:@{
                               @"title": product.localizedTitle ?: @"",
                               @"desc": product.localizedDescription ?: @"",
                               @"price": formattedPrice,
                               @"identifier": product.productIdentifier
                               }];
    }
    
    self.dataArray = dataArray.copy;
    
    return self.dataArray;
}

@end
