//
//  HYMatchMakerPayVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYMatchMakerPayVM.h"

@implementation HYMatchMakerPayVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.productIdentifiers = @[@"hongniang003", @"hongniang002", @"hongniang001"];
    self.identifier = self.productIdentifiers[0];
    
    self.dataArray = @[
                       [HYMatchMakerPayCellModel modelWithType:HYMatchMakerPayCellTypeIntro date:nil],
                       [HYMatchMakerPayCellModel modelWithType:HYMatchMakerPayCellTypeItems date:nil]
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
        
        if (i == 0 && [formattedPrice containsString:@"¥"]) {
            formattedPrice = @"¥0.00";
        }
        
        [dataArray addObject:@{
                               @"title": product.localizedTitle ?: @"",
                               @"desc": product.localizedDescription ?: @"",
                               @"price": formattedPrice,
                               @"identifier": product.productIdentifier
                               }];
    }
    
    HYMatchMakerPayCellModel *model = [HYMatchMakerPayCellModel modelWithType:HYMatchMakerPayCellTypeItems date:dataArray];
    NSMutableArray *arrM = self.dataArray.mutableCopy;
    [arrM replaceObjectAtIndex:1 withObject:model];
    
    self.dataArray = arrM.copy;
    
    return self.dataArray;
}


@end
