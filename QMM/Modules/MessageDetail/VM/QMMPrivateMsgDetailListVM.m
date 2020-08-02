//
//  QMMPrivateMsgDetailListVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMPrivateMsgDetailListVM.h"
#import "QMMPrivateMsgListModel.h"
#import "QMMPrivateMsgModel.h"

@interface QMMPrivateMsgDetailListVM ()
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int count;

@end

@implementation QMMPrivateMsgDetailListVM


- (id)init {
    self = [super init];
    if (self) {
        self.page  = 1;
        self.count = 1000;
        [self initalize];
    }
    return self;
}


- (void)initalize {
    @weakify(self);
    self.doCommond = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(id _Nullable input) {

        @strongify(self);
        NSDictionary *dic = nil;

                if(self.lastdate.length>0)
                {
                    dic =@{@"fromuid":self.uid,@"page":[NSString stringWithFormat:@"%d",self.page], @"count":
                    [NSString stringWithFormat:@"%d",self.count],@"lastdate":self.lastdate };
                }
                else
        {
            self.listArray = nil;

            dic = @{
                @"fromuid": self.uid,
                @"page": [NSString stringWithFormat:@"%d", self.page],
                @"count": [NSString stringWithFormat:@"%d", self.count]
            };
        }

        return [[self getmessagelist:[dic decodeWithAPI:API_MESSAGELISTBYUSERID]] doNext:^(YSResponseModel *_Nullable x) {
            @strongify(self);
            self.lastdate = x.extra;
            if(self.page < x.totalpage) {
                self.page ++;
            }
            [self getlist:x.data];
        }];
    }];


    self.doSendMessageCommond = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(id _Nullable input) {
        @strongify(self);
        NSDictionary *dic = @{ @"touid": self.uid, @"content": self.content };

        return [[self getmessagelist:[dic decodeWithAPI:API_SENDMESSAGE]] doNext:^(YSResponseModel *_Nullable x) {

            NSLog(@"%@", x.data);
        }];

    }];


    self.pBUserCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(id _Nullable input) {

        return [[self pBlackUser:[input decodeWithAPI:API_BLACKUSER]] doNext:^(id _Nullable x){

        }];
    }];
}

- (RACSignal *)getmessagelist:(NSDictionary *)dic {
    RACSignal *signal = [YSRequestAdapter requestSignalWithURL:@""
                                                        params:dic
                                                   requestType:YSRequestTypePOST
                                                  responseType:YSResponseTypeList
                                                 responseClass:[QMMPrivateMsgModel class]];
    return signal;
}

- (RACSignal *)senMesage:(NSDictionary *)dic {
    RACSignal *signal = [YSRequestAdapter requestSignalWithURL:@""
                                                        params:dic
                                                   requestType:YSRequestTypePOST
                                                  responseType:YSResponseTypeObject
                                                 responseClass:[NSString class]];
    return signal;
}


- (RACSignal *)pBlackUser:(NSDictionary *)dic {
    RACSignal *signal = [YSRequestAdapter requestSignalWithURL:@""
                                                        params:dic
                                                   requestType:YSRequestTypePOST
                                                  responseType:YSResponseTypeObject
                                                 responseClass:[NSString class]];
    return signal;
}

//数据组装 并且需要排序
- (void)getlist:(NSArray *)array {
    NSMutableArray *set = [NSMutableArray new];
    for (QMMPrivateMsgModel *m in array) {
        BOOL has = NO;
        for (int mj = 0; mj < set.count; mj++) {
            if ([m.time isEqualToString:[set objectAtIndex:mj]]) {
                has = YES;
                break;
            }
        }

        if (has == NO) {
            [set addObject:m.time];
        }
    }

    NSArray *temlist            = [[array reverseObjectEnumerator] allObjects];
    NSMutableArray *returnArray = [NSMutableArray new];
    NSInteger numner            = set.count - 1;
    for (int i = (int) numner; i >= 0; i--) {
        QMMPrivateMsgListModel *m       = [QMMPrivateMsgListModel new];
        m.time                       = [set objectAtIndex:i];
        NSMutableArray *sorttemArray = [NSMutableArray new];
        for (QMMPrivateMsgModel *dem in temlist) {
            if ([dem.time isEqualToString:m.time]) {
                [sorttemArray addObject:dem];
            }
        }
        m.array = [sorttemArray copy];
        [returnArray addObject:m];
    }


    self.listArray = [returnArray copy];
}

@end
