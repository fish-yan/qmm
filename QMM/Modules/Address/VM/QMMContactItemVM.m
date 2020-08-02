//
//  QMMContactItemVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMContactItemVM.h"
#import "QMMContactModel.h"

@implementation QMMContactItemVM


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
        return [[self markSignalWithInput:input] doNext:^(id _Nullable x) {
            @strongify(self);
            self.isView = @(YES);
        }];
    }];
}


- (RACSignal *)markSignalWithInput:(NSNumber *)input {
    NSDictionary *params = @{ @"id": self.mid ?: @"", @"type": @(self.type) };
    
    return [[QMMRequestAdapter requestSignalParams:[params decodeWithAPI:@"viewuseraddress"]
                                      responseType:YSResponseTypeMessage
                                     responseClass:nil]
            map:^id _Nullable(YSResponseModel *_Nullable value) {
                return [value.data lastObject];
            }];
}

- (RACSignal *)heartSignalWithParams:(NSDictionary *)params {
    return [[QMMRequestAdapter requestSignalParams:[params decodeWithAPI:API_ISBEMOVED]
                                      responseType:YSResponseTypeObject
                                     responseClass:[QMMMemberInfoModel class]]
            map:^id _Nullable(YSResponseModel *_Nullable value) {
                return value.data;
            }];
}

+ (instancetype)viewModelWithObj:(id)obj {
    QMMContactItemVM *vm = [QMMContactItemVM new];
    [vm setObj:obj];
    return vm;
}

- (void)setObj:(QMMContactModel *)obj {
    self.userID         = obj.uid;
    self.avatar         = [NSURL URLWithString:obj.avatar];
    self.nickname       = obj.name;
    self.age            = obj.age;
    self.city           = obj.workcity;
    self.userAgeAndcity = [NSString stringWithFormat:@"%@岁 * %@", obj.age ?: @"", obj.workcity ?: @""];
    self.heartType      = obj.isheart;
    self.isView         = obj.isview;
    self.mid            = obj.mid;
}


@end
