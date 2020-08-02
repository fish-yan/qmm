//
//  QMMRequestAdapter.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/23.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMRequestAdapter.h"

@implementation QMMRequestAdapter

+ (RACSignal *)requestSignalParams:(NSDictionary *)params
                      responseType:(YSResponseType)responseType
                     responseClass:(Class)responseClass {
    NSString *url = [YSRequestInfoConfig shareConfig].baseURL;
    return [[[YSRequestAdapter requestSignalWithURL:url
                                             params:params
                                        requestType:YSRequestTypePOST
                                       responseType:YSResponseTypeOriginal
                                      responseClass:responseClass] map:^id _Nullable(YSResponseModel * _Nullable value) {
        NSLog(@"%@", value);
        
        YSResponseModel *m = [YSResponseModel new];
        m.extra = value.extra;
        m.msg = value.msg;
        m.total = value.total;
        m.totalpage = value.totalpage;
        
        switch (responseType) {
            case YSResponseTypeOriginal:
            case YSResponseTypeMessage: {
                m.data = value.data;
                break;
            }
            case YSResponseTypeList: {
                m.data = [responseClass mj_objectArrayWithKeyValuesArray:value.data];
                return m;
                break;
            }
            case YSResponseTypeObject: {
                m.data = [responseClass mj_objectWithKeyValues:value.data[0]];
                break;
            }
            default:
                break;
        }
        return m;
    }] doError:^(NSError * _Nonnull error) {
        
        if (error.code == 402002) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT_NOTIF_KEY object:nil];
        }
    }] ;
}

@end
