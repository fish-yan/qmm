//
//  HYMatchMakerPayItemCell.m
//  SeeYou
//
//  Created by Joseph Koh on 2018/8/9.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYMatchMakerPayItemCell.h"
#import "HYPayItemView.h"

@interface HYMatchMakerPayItemCell ()

@property (weak, nonatomic) IBOutlet UIScrollView *itemsContainer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) NSMutableArray *itemsCachePool;
@property (nonatomic, strong) HYPayItemView *selectedItem;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger selectedIdx;
@end

@implementation HYMatchMakerPayItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self bind];
    
    self.dataArray = @[
                       @{@"title": @"3个月", @"price": @"0元试用", @"desc": @"专属推荐服务3个月，更快找到您的另一半"},
                       @{@"title": @"2个月", @"price": @"¥298", @"desc": @"专属推荐服务2个月，更快找到您的另一半"},
                       @{@"title": @"1个月", @"price": @"¥198", @"desc": @"专属推荐服务1个月，更快找到您的另一半"}
                       ];
}

- (void)resetupItems {
    for (HYPayItemView *v in self.itemsCachePool) {
        v.hidden = YES;
        v.frame = CGRectZero;
        v.selected = NO;
    }
    self.itemsContainer.contentSize = CGSizeZero;
}

- (void)layoutItems:(NSArray *)arr {
    if (arr.count == 0) return;
    
    CGFloat padding = 20;
    CGFloat margin = 5;
    CGFloat w = 156;
    
    CGFloat itemTotalW = w * arr.count + margin * (arr.count - 1);  // item + 间距总长度
    CGFloat contentSizeW = padding * 2 + itemTotalW;
    if (contentSizeW < SCREEN_WIDTH) {
        padding = (SCREEN_WIDTH - itemTotalW) * 0.5;
    }
    
    for (NSInteger i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        
        HYPayItemView *v = [self cachedView:i];
        v.titleLabel.text = dict[@"title"];
        v.priceLabel.text = dict[@"price"];
        
        CGFloat offsetX = padding + (w + margin) * i;
        v.frame = CGRectMake(offsetX, 0, w, 85);
        
        if (i == 0) {
            v.selected = YES;
            self.selectedItem = v;
        }
    }
    
    self.itemsContainer.contentSize = CGSizeMake(contentSizeW, 0);
}

- (void)bind {
    @weakify(self);
    [RACObserve(self, dataArray) subscribeNext:^(NSArray * _Nullable x) {
        @strongify(self);
        [self resetupItems];
        [self layoutItems:x];
    }];

}

- (void)changeSelectedItem:(HYPayItemView *)item {
    if (self.selectedItem.tag == item.tag) {
        return;
    }
    
    self.selectedItem.selected = NO;
    item.selected = YES;
    self.selectedItem = item;
    self.selectedIdx = item.tag - 100;
}

- (void)changeDisplayInfo {
    NSDictionary *dict = self.dataArray[self.selectedIdx];
    if (self.selectedIdx == 0) {
        self.titleLabel.text = @"免费试用 3 天（限前 10 万名）";
        self.priceLabel.text = @"原价¥298";
    }
    else {
        self.titleLabel.text = dict[@"desc"];
        self.priceLabel.text = dict[@"price"];
    }
}

- (HYPayItemView *)cachedView:(NSInteger)idx {
    HYPayItemView *v = nil;
    if (self.itemsCachePool.count == 0 || (self.itemsCachePool.count && idx >= self.itemsCachePool.count)) {
        v = [HYPayItemView itemWithTitle:nil price:nil];
        v.tag = idx + 100;
        
        @weakify(self);
        v.tapAction = ^(HYPayItemView *item) {
            @strongify(self);
            [self changeSelectedItem:item];
            [self changeDisplayInfo];
            
            
            if (self.selectedHandler) {
                self.selectedHandler(self.selectedIdx);
            }
        };
        
        [self.itemsContainer addSubview:v];
        [self.itemsCachePool addObject:v];
    }
    else {
        v = self.itemsCachePool[idx];
        v.hidden = NO;
    }
    return v;
}

- (NSMutableArray *)itemsCachePool {
    if (!_itemsCachePool) {
        _itemsCachePool = [NSMutableArray arrayWithCapacity:3];
    }
    return _itemsCachePool;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.protocalView setContentOffset:CGPointZero animated:NO];
}
@end
