//
//  QMMMatchmakerPayVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMMatchmakerPayVM.h"

@implementation QMMMatchmakerPayVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.productIdentifiers = @[@"momohongniang003", @"momohongniang002", @"momohongniang001"];
    self.identifier = self.productIdentifiers[0];
    
    self.dataArray = @[
                       [QMMMatchmakerPayCellModel modelWithType:HYMatchMakerPayCellTypeIntro date:nil],
                       [QMMMatchmakerPayCellModel modelWithType:HYMatchMakerPayCellTypeItems date:nil]
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
                               @"price": product.price?:@"",
                               @"identifier": product.productIdentifier
                               }];
    }
    
    QMMMatchmakerPayCellModel *model = [QMMMatchmakerPayCellModel modelWithType:HYMatchMakerPayCellTypeItems date:dataArray];
    NSMutableArray *arrM = self.dataArray.mutableCopy;
    [arrM replaceObjectAtIndex:1 withObject:model];
    
    self.dataArray = arrM.copy;
    
    return self.dataArray;
}

- (NSString *)formatPrice:(NSDecimalNumber *)originPrice ofLocal:(NSLocale *)local {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:local];
    NSString *formattedPrice = [numberFormatter stringFromNumber:originPrice];
    return formattedPrice;
}


@end
