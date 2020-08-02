//
//  HYAddressListViewModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYAddressListViewModel.h"
#import "HYAddressSubModel.h"

@implementation HYAddressListViewModel

- (id)init {
    self = [super init];
    if (self) {
        [self initalize];
    }
    return self;
}

- (void)convertToViewModelArray:(NSArray *)convertArray {
    NSMutableArray *tem = [NSMutableArray new];
    for (int i = 0; i < convertArray.count; i++) {
        HYAddressCellViewModel *m = [HYAddressCellViewModel new];
        HYAddressSubViewModel *vm = [HYAddressSubViewModel viewModelWithObj:[convertArray objectAtIndex:i]];
        vm.type                   = self.type;
        m.leftViewModel           = vm;

        i++;
        if (i < convertArray.count) {
            HYAddressSubViewModel *vm = [HYAddressSubViewModel viewModelWithObj:[convertArray objectAtIndex:i]];
            vm.type                   = self.type;
            m.rightViewModel          = vm;
        }
        [tem addObject:m];
    }

    self.convertArray = [tem copy];
}

- (void)initalize {
    self.titleData = [self titleInfosWithData:nil];

    @weakify(self);
    self.getAddresslistRaccommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(NSDictionary *_Nullable input) {
        @strongify(self);

        return [[self getlist:[input decodeWithAPI:API_GETADDRESS_API]] doNext:^(YSResponseModel *_Nullable x) {
            if (self.page == 1) {
                self.orginDataArray = @[];
            }
            NSMutableArray *temarray = [NSMutableArray new];
#warning TODO: ---
          //  self.hasMore             = self.page < x.totalpage ? YES : NO;
            if (self.hasMore) {
                self.page++;
            }
            [temarray addObjectsFromArray:self.orginDataArray];
            [temarray addObjectsFromArray:x.data];
            self.orginDataArray = [temarray copy];


            [self convertToViewModelArray:self.orginDataArray];
        }];

    }];

    self.fetTitleCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(id _Nullable input) {
        @strongify(self);
        return [[self fetchTitleSignal] doNext:^(NSDictionary *_Nullable x) {
            @strongify(self);
            self.titleData = [self titleInfosWithData:x];
        }];
    }];
}

- (NSArray *)titleInfosWithData:(NSDictionary *)data {
    return @[
        [HYAddressTitleModel modelWithTitle:@"我喜欢" hasUnread:NO],
        [HYAddressTitleModel modelWithTitle:@"看过我" hasUnread:[data[@"seeme"] boolValue]],
        [HYAddressTitleModel modelWithTitle:@"喜欢我" hasUnread:[data[@"likemestatus"] boolValue]],
        [HYAddressTitleModel modelWithTitle:@"相互喜欢" hasUnread:[data[@"likeeachotherstatus"] boolValue]]
    ];
}
- (RACSignal *)fetchTitleSignal {
    NSDictionary *params = @{};
    return [[YSRequestAdapter requestSignalWithURL:@""
                                            params:[params decodeWithAPI:@"getuseraddressunread"]
                                       requestType:YSRequestTypePOST
                                      responseType:YSResponseTypeMessage
                                     responseClass:nil] map:^id _Nullable(YSResponseModel *_Nullable value) {
        return [value.data lastObject];
    }];
}

- (RACSignal *)getlist:(NSDictionary *)dic {
    RACSignal *signale = [YSRequestAdapter requestSignalWithURL:@""
                                                         params:dic
                                                    requestType:YSRequestTypePOST
                                                   responseType:YSResponseTypeList
                                                  responseClass:[HYAddressSubModel class]];
    return signale;
}

@end
