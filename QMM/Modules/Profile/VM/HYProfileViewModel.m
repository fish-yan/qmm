//
//  HYProfileViewModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYProfileViewModel.h"
#import "HYProfileCellModel.h"

@implementation HYProfileViewModel


- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.uid = [QMMUserContext shareContext].userModel.uid;
    
    @weakify(self);
    self.requestCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSDictionary *params = @{
                                 @"id":self.uid,
                                 @"version": @2
                                 };
        return [[[self userInfoSignalWithParams:params]
                 map:^id _Nullable(YSResponseModel * _Nullable value) {
                     return value.data;
                 }]
                doNext:^(HYUserCenterModel * _Nullable x) {
                    @strongify(self);
                    [[QMMUserContext shareContext] deployLoginActionWithUserModel:x action:NULL];
                    
                    self.detailModel = x;
                    self.hasIdentify = [x.identityverifystatus boolValue];
                    self.hasBuyMatchMaker = [x.redniangstatus boolValue];
                    [self combineDataArrayWithInfoModel:x];
                }];
    }];
    
    
    self.logoutCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [[self logoutSignalWithParams:@{}] doNext:^(id  _Nullable x) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT_NOTIF_KEY object:nil];
        }];
    }];
}

- (void)combineDataArrayWithInfoModel:(HYUserCenterModel *)model {
    //
    HYProfileCellModel *m1 = [HYProfileCellModel modelWithType:ProfileCellTypeInfo
                                                         title:nil
                                                          desc:nil
                                                        mapStr:nil
                                                         value:model];
    //
    NSString *m2s = @"未开通";
    if ([model.vipstatus boolValue]) {
        m2s = [NSString stringWithFormat:@"%@到期", model.vipdate];
    }
    HYProfileCellModel *m2 = [HYProfileCellModel modelWithType:ProfileCellTypeMenu
                                                         title:@"会员中心"
                                                          desc:m2s
                                                        mapStr:nil
                                                         value:[self menus]];
    
    self.dataArray = @[@[m1], @[m2], [self listByModel:model]];
}

- (NSArray *)listByModel:(HYUserCenterModel *)model {
    NSString *topDate = @"";
    NSString *redniangdate = @"";
    if (model.topdate.length) {
        topDate = [NSString stringWithFormat:@"%@到期", model.topdate];
    }
    if (model.redniangdate.length) {
        redniangdate = [NSString stringWithFormat:@"%@到期", model.redniangdate];
    }
    return @[
             [HYProfileCellModel modelWithType:ProfileCellTypeList
                                         title:@"排名提前"
                                          desc:topDate
                                        mapStr:kModuleTopDisplayPay
                                         value:nil],
             [HYProfileCellModel modelWithType:ProfileCellTypeList
                                         title:@"红娘推荐"
                                          desc:redniangdate
                                        mapStr:kModuleMatchMaker
                                         value:nil],
             [HYProfileCellModel modelWithType:ProfileCellTypeList
                                         title:@"发现星球"
                                          desc:@""
                                        mapStr:kModuleWebView
                                         value:@{
                                                 @"urlString": @"https://http://m.baidu.com/"
                                                 }],
             [HYProfileCellModel modelWithType:ProfileCellTypeList
                                         title:@"邀请好友"
                                          desc:@""
                                        mapStr:kModuleWebView
                                         value:@{
                                                 @"urlString": @"https://http://m.baidu.com/"
                                                 }]
             ];
}

- (NSArray *)menus {
    NSString *url = kModuleMembership;//[NSString stringWithFormat:@"com.tm.IwantYou:///%@", kModuleMembership];
    return @[
             [HYProfileCellModel modelWithTitle:@"无限畅聊" desc:@"profile_menu_large1" mapStr:url value:nil],
             [HYProfileCellModel modelWithTitle:@"尊贵标签" desc:@"profile_menu_large2" mapStr:url value:nil],
             [HYProfileCellModel modelWithTitle:@"排名优先" desc:@"profile_menu_large3" mapStr:url value:nil],
             [HYProfileCellModel modelWithTitle:@"自由备注" desc:@"profile_menu_large4" mapStr:url value:nil],
             [HYProfileCellModel modelWithTitle:@"定制打招呼" desc:@"profile_menu_large5" mapStr:url value:nil],
             [HYProfileCellModel modelWithTitle:@"上线提醒" desc:@"profile_menu_large6" mapStr:url value:nil],
             [HYProfileCellModel modelWithTitle:@"最后登陆时间" desc:@"profile_menu_large7" mapStr:url value:nil],
             [HYProfileCellModel modelWithTitle:@"敬请期待" desc:@"profile_menu_large8" mapStr:url value:nil],
             ];
}


- (RACSignal *)userInfoSignalWithParams:(NSDictionary *)params {
    return [YSRequestAdapter requestSignalWithURL:@""
                                           params:[params decodeWithAPI:API_PROFILE]
                                      requestType:YSRequestTypePOST
                                     responseType:YSResponseTypeObject
                                    responseClass:[HYUserCenterModel class]];
}

- (RACSignal *)logoutSignalWithParams:(NSDictionary *)params {
    return [YSRequestAdapter requestSignalWithURL:@""
                                           params:[params decodeWithAPI:API_LOGOUT]
                                      requestType:YSRequestTypePOST
                                     responseType:YSResponseTypeMessage
                                    responseClass:nil];
}


@end
