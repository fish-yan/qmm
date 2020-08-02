//
//  HYAddressSubViewModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYAddressSubViewModel.h"
#import "HYAddressSubModel.h"

@implementation HYAddressSubViewModel


- (id)init {
    if (self = [super init]) {
        [self initalize];
    }
    return self;
}
- (void)initalize {
    @weakify(self);
    self.heartCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(id _Nullable input) {
        @strongify(self);
        return [self heartSignalWithParams:input];
    }];

    self.markCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(id _Nullable input) {
        @strongify(self);
        return [[[self markSignalWithInput:input] doNext:^(id _Nullable x) {
            @strongify(self);
            self.isview = @(YES);
        }] doError:^(NSError *_Nonnull error) {
            NSLog(@"----%@", error);
        }];
    }];
}


- (RACSignal *)markSignalWithInput:(NSNumber *)input {
    NSDictionary *params = @{ @"id": self.mid ?: @"", @"type": @(self.type) };
    return [[YSRequestAdapter requestSignalWithURL:@""
                                            params:[params decodeWithAPI:@"viewuseraddress"]
                                       requestType:YSRequestTypePOST
                                      responseType:YSResponseTypeMessage
                                     responseClass:nil] map:^id _Nullable(YSResponseModel *_Nullable value) {
        return [value.data lastObject];
    }];
}

- (RACSignal *)heartSignalWithParams:(NSDictionary *)params {
    return [[YSRequestAdapter requestSignalWithURL:@""
                                            params:[params decodeWithAPI:API_ISBEMOVED]
                                       requestType:YSRequestTypePOST
                                      responseType:YSResponseTypeObject
                                     responseClass:[HYObjectListModel class]] map:^id _Nullable(YSResponseModel *_Nullable value) {
        return value.data;
    }];
}

+ (instancetype)viewModelWithObj:(id)obj {
    HYAddressSubViewModel *vm = [HYAddressSubViewModel new];
    [vm setObj:obj];
    return vm;
}

- (void)setObj:(HYAddressSubModel *)obj {
    self.userID         = obj.userID;
    self.userAvatar     = [NSURL URLWithString:obj.userAvatar];
    self.userNickName   = obj.userNickName;
    self.userAge        = obj.userAge;
    self.city           = obj.city;
    self.userAgeAndcity = [NSString stringWithFormat:@"%@岁 * %@", self.userAge, self.city];
    self.isheart        = obj.isheart;
    self.isview         = obj.isview;
    self.mid            = obj.mid;
}


@end
