//
//  HYDatingListVM.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "HYDatingListVM.h"
#import "HYDatingInfoModel.h"

@implementation HYDatingListVM


- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    @weakify(self);
    self.requestCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        self.flag = @1;
        return [[self requestSignal]
                doNext:^(NSArray *  _Nullable x) {
                    @strongify(self);
                    self.dataArray = x;
                }];
    }];
    
    self.requestMoreCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [[self requestSignal]
                doNext:^(NSArray * _Nullable x) {
                    @strongify(self);
                    self.dataArray = [self.dataArray arrayByAddingObjectsFromArray:x];
                }];
    }];
}

- (RACSignal *)requestSignal {
    NSDictionary *params = @{
                             @"stauts": @(self.status),
                             @"type": @(self.type),
                             @"page": self.flag,
                             @"count": @20,
                             };
    @weakify(self);
    return [[YSRequestAdapter requestSignalWithURL:@""
                                            params:[params decodeWithAPI:API_DATING_LIST]
                                       requestType:YSRequestTypePOST
                                      responseType:YSResponseTypeList
                                     responseClass:[HYDatingInfoModel class]]
            map:^id _Nullable(YSResponseModel * _Nullable value) {
                @strongify(self);
                NSInteger page = [self.flag integerValue];
                self.totalCount = value.total;
                if (page == value.totalpage) {
                    self.hasMore = NO;
                } else {
                    self.flag = @(++page);
                    self.hasMore = YES;
                }
                
                return value.data;
            }] ;
}
@end
