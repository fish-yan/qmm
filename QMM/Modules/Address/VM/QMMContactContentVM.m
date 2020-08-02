//
//  QMMContactContentVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMContactContentVM.h"
#import "QMMContactModel.h"

@implementation QMMContactContentVM

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
        QMMContactCellViewModel *m = [QMMContactCellViewModel new];
        QMMContactItemVM *vm = [QMMContactItemVM viewModelWithObj:[convertArray objectAtIndex:i]];
        vm.type                   = self.type;
        m.leftViewModel           = vm;

        i++;
        if (i < convertArray.count) {
            QMMContactItemVM *vm = [QMMContactItemVM viewModelWithObj:[convertArray objectAtIndex:i]];
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

            self.hasMore = self.page < x.totalpage ? YES : NO;
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
        [HYContactTitleModel modelWithTitle:@"我喜欢" hasUnread:NO],
        [HYContactTitleModel modelWithTitle:@"看过我" hasUnread:[data[@"seeme"] boolValue]],
        [HYContactTitleModel modelWithTitle:@"喜欢我" hasUnread:[data[@"likemestatus"] boolValue]],
        [HYContactTitleModel modelWithTitle:@"相互喜欢" hasUnread:[data[@"likeeachotherstatus"] boolValue]]
    ];
}
- (RACSignal *)fetchTitleSignal {
    NSDictionary *params = @{};
    
    return [[QMMRequestAdapter requestSignalParams:[params decodeWithAPI:@"getuseraddressunread"]
                                      responseType:YSResponseTypeMessage
                                     responseClass:nil]
            map:^id _Nullable(YSResponseModel *_Nullable value) {
                return [value.data lastObject];
            }];
}

- (RACSignal *)getlist:(NSDictionary *)dic {
    return [QMMRequestAdapter requestSignalParams:dic
                                     responseType:YSResponseTypeList
                                    responseClass:[QMMContactModel class]];
    
//    RACSignal *signale = [YSRequestAdapter requestSignalWithURL:@""
//                                                         params:dic
//                                                    requestType:YSRequestTypePOST
//                                                   responseType:YSResponseTypeList
//                                                  responseClass:[QMMContactModel class]];
//    return signale;
}

@end
