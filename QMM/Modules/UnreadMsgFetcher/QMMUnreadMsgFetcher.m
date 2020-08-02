//
//  QMMUnreadInfoModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMUnreadMsgFetcher.h"


@implementation QMMUnreadInfoModel

@end

@implementation QMMUnreadMsgFetcher

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static QMMUnreadMsgFetcher *instance;
    dispatch_once(&onceToken, ^{
        instance = [QMMUnreadMsgFetcher new];
        @weakify(instance);
        instance.unreadMsgCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(instance);
            return [instance fetchUnreadInfoSignal];
        }];
    });
    return instance;
}

- (RACSignal *)fetchUnreadInfoSignal {
    NSDictionary *params = @{};
    
    return [[[QMMRequestAdapter requestSignalParams:[params decodeWithAPI:@"getuserunreadcount"]
                                       responseType:YSResponseTypeObject
                                      responseClass:[QMMUnreadInfoModel class]]
             map:^id _Nullable(YSResponseModel * _Nullable value) {
                 return value.data;
             }]
            doNext:^(QMMUnreadInfoModel * _Nullable x) {
                if (x == nil) return;
                
                UITabBar *tabBar = [QMMUIAssistant shareInstance].rootTabBarController.tabBar;
                for (NSInteger i = 0; i < tabBar.items.count; i++) {
                    if (i == 0 || i ==4) continue;
                    UITabBarItem *item = tabBar.items[i];
                    NSInteger cnt = 0;
                    if (i == 1) {
                        cnt = x.msgcount;
                    } else if (i == 2) {
                        cnt = x.appointmentcount;
                    } else if (i == 3) {
                        cnt = x.addresscount;
                    }
                    item.badgeValue = [self covertedNumber:cnt];
                }
            }];
}

- (NSString *)covertedNumber:(NSInteger)cnt {
    if (cnt == 0) return nil;
    if (cnt > 99) return @"99+";
    return [NSString stringWithFormat:@"%zd", cnt];
}
@end
