//
//  HYDatingLineVM.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/26.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYDatingLineVM.h"
#import "HYDatingLineModel.h"

@implementation HYDatingLineVM

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
        NSDictionary *params = @{@"id": self.dateId ?: @""};
        return [[self requestSignalWithParams:params]
                doNext:^(HYDatingLineModel * _Nullable x) {
                    @strongify(self);
                    
                    self.initiatoravatar = x.initiatoravatar;
                    self.initiatorname = x.initiatorname;
                    self.receiveravatar = x.receiveravatar;
                    self.receivername = x.receivername;
                    self.dataArray = x.routeitems;
                    
                    //self.dataArray = [self testArray];
                }];
    }];
}

- (NSArray *)testArray {
    HYDatingRouteItem *item0 = [HYDatingRouteItem new];
    item0.date = @"2018.03.10 01:10";
    item0.content = @"发起约会";
    item0.type = @1;
    
    
    HYDatingRouteItem *item1 = [HYDatingRouteItem new];
    item1.date = @"2018.03.10 01:10";
    item1.content = @"同意约会";
    item1.type = @2;
    
    HYDatingRouteItem *item2 = [HYDatingRouteItem new];
    item2.date = @"2018.03.10 01:10";
    item2.content = @"赴约签到";
    item2.type = @1;
    
    HYDatingRouteItem *item3 = [HYDatingRouteItem new];
    item3.date = @"2018.03.10 01:10";
    item3.content = @"赴约签到";
    item3.type = @2;
    
    return @[item0, item1, item2, item3];
}

- (RACSignal *)requestSignalWithParams:(NSDictionary *)params {
    return [[YSRequestAdapter requestSignalWithURL:@""
                                            params:[params decodeWithAPI:API_DATING_LINE]
                                       requestType:YSRequestTypePOST
                                      responseType:YSResponseTypeObject
                                     responseClass:[HYDatingLineModel class]]
            map:^id _Nullable(YSResponseModel * _Nullable value) {
                return value.data;
            }] ;
}

@end
