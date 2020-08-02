//
//  QMMPopPayVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMPopPayVM.h"
#import "QMMPopDataModel.h"
#import <StoreKit/StoreKit.h>

@implementation QMMPopPayVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.tips = @"开通后，【遇见】页面置顶显示您的排名，海量异性消息，收到你手软。";
    self.productIdentifiers = @[@"momozhiding0003", @"momozhiding0002", @"momozhiding0001"];
    self.identifier = self.productIdentifiers[0];
    self.dataArray = @[
                       @{@"title": @"", @"price": @"¥0.00", @"desc": @""},
                       @{@"title": @"", @"price": @"¥0.00", @"desc": @""},
                       @{@"title": @"", @"price": @"¥0.00", @"desc": @""},
                       ];
    
}

- (void)setItemSelectedIdx:(NSInteger)itemSelectedIdx {
    _itemSelectedIdx = itemSelectedIdx;
    
    self.identifier = self.productIdentifiers[itemSelectedIdx];
}

- (NSArray *)sortPrice:(NSArray<FYProduct *> *)products {
    NSArray *arr = [products sortedArrayUsingComparator:^NSComparisonResult(FYProduct * _Nonnull obj1, FYProduct * _Nonnull obj2) {
        return [obj2.price compare:obj1.price];
    }];
    return arr;
}


- (NSArray *)updateDataArray:(NSArray *)dataList {
    NSMutableArray *dataArray = [NSMutableArray array];
    NSArray *data = dataList;
    for (NSInteger i = 0; i < data.count; i++) {
        FYProduct *product = data[i];
        
        NSLog(@"FYProduct id：%@\t产品标题：%@\t描述信息：%@ \t价格：%@",
              product.productIdentifier,
              product.localizedTitle,
              product.localizedDescription,
              product.price);

        [dataArray addObject:@{
                               @"title": product.localizedTitle ?: @"",
                               @"desc": product.localizedDescription ?: @"",
                               @"price": product.price,
                               @"identifier": product.productIdentifier
                               }];
    }
    
    self.dataArray = dataArray.copy;
    
    return self.dataArray;
}

@end
