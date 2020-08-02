//
//  HYPrivateListViewModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYPrivateListViewModel.h"
#import "HYPrivateModel.h"
#import "HYPrivateCellViewModel.h"

@implementation HYPrivateListViewModel

- (id)init {
    self = [super init];
    if (self) {
        [self initalize];
        self.page  = 1;
        self.count = 20;
    }
    return self;
}


- (void)initalize {
    @weakify(self);
    self.doCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(id _Nullable input) {
        @strongify(self);
        NSDictionary *dic = @{
            @"page": [NSString stringWithFormat:@"%d", self.page],
            @"count": [NSString stringWithFormat:@"%d", self.count]
        };
        return [[self getlist:[dic decodeWithAPI:API_MESSAGELIST]] doNext:^(YSResponseModel *_Nullable x) {
            if (self.page == 1) {
                self.listArray = nil;
            }
            self.hasMore = self.page < x.totalpage ? YES : NO;
            if (self.hasMore) {
                self.page++;
            }
            [self ModelToViewModel:x.data];
        }];
    }];

    self.dodeleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(NSDictionary *input) {
        @strongify(self);
        return [[self getlist:[input decodeWithAPI:API_DELAETSIGNAL_MESSAGE]] doNext:^(YSResponseModel *_Nullable x){

        }];
    }];
}

- (RACSignal *)getlist:(NSDictionary *)dic {
    return [QMMRequestAdapter requestSignalParams:dic
                                     responseType:YSResponseTypeList
                                    responseClass:[HYPrivateModel class]];
    
    
//    RACSignal *signal = [YSRequestAdapter requestSignalWithURL:@""
//                                                        params:dic
//                                                   requestType:YSRequestTypePOST
//                                                  responseType:YSResponseTypeList
//                                                 responseClass:[HYPrivateModel class]];
//    return signal;
}
- (RACSignal *)delete:(NSDictionary *)dic {
    return [QMMRequestAdapter requestSignalParams:dic
                                     responseType:YSResponseTypeMessage
                                    responseClass:[HYPrivateModel class]];
    
//    RACSignal *signal = [YSRequestAdapter requestSignalWithURL:@""
//                                                        params:dic
//                                                   requestType:YSRequestTypePOST
//                                                  responseType:YSResponseTypeMessage
//                                                 responseClass:[HYPrivateModel class]];
//    return signal;
}


- (void)ModelToViewModel:(NSArray *)array {
    NSMutableArray *temArray = [NSMutableArray new];
    if (self.listArray.count > 0) {
        [temArray addObjectsFromArray:self.listArray];
    }

    for (HYPrivateModel *m in array) {
        [temArray addObject:[HYPrivateCellViewModel viewModelWithObj:m]];
    }

    self.listArray = [temArray copy];
}
@end
