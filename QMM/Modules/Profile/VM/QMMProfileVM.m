//
//  QMMProfileVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMProfileVM.h"
#import "QMMProfileCellModel.h"

@implementation QMMProfileVM


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
                doNext:^(HYUserModel * _Nullable x) {
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
        return [[self logoutSignalWithParams:@{}]
                 doNext:^(id  _Nullable x) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT_NOTIF_KEY object:nil];
                 }];
    }];
}

- (void)combineDataArrayWithInfoModel:(HYUserModel *)model {
    //
    QMMProfileCellModel *m1 = [QMMProfileCellModel modelWithType:ProfileCellTypeInfo
                                                         title:nil
                                                          desc:nil
                                                        mapStr:nil
                                                         value:model];
    //
    NSString *m2s = @"未开通";
    if ([model.vipstatus boolValue]) {
        m2s = [NSString stringWithFormat:@"%@到期", model.vipdate];
    }
    QMMProfileCellModel *m2 = [QMMProfileCellModel modelWithType:ProfileCellTypeMenu
                                                         title:@"会员中心"
                                                          desc:m2s
                                                        mapStr:nil
                                                         value:[self menus]];
    
    QMMProfileCellModel *m3 = [QMMProfileCellModel modelWithType:ProfileCellTypeInvationAd
                                                           title:nil
                                                            desc:nil
                                                          mapStr:nil
                                                           value:nil];
    
    self.dataArray = @[@[m1], @[m2], @[m3], [self listByModel:model]];
}

- (NSArray *)listByModel:(HYUserModel *)model {
    NSString *topDate = @"";
    NSString *redniangdate = @"";
    if (model.topdate.length) {
        topDate = [NSString stringWithFormat:@"%@到期", model.topdate];
    }
    if (model.redniangdate.length) {
        redniangdate = [NSString stringWithFormat:@"%@到期", model.redniangdate];
    }
    return @[
             [QMMProfileCellModel modelWithType:ProfileCellTypeList
                                         title:@"排名提前"
                                          desc:topDate
                                        mapStr:kModuleTopDisplayPay
                                         value:nil],
             [QMMProfileCellModel modelWithType:ProfileCellTypeList
                                         title:@"红娘推荐"
                                          desc:redniangdate
                                        mapStr:kModuleMatchMaker
                                         value:nil],
//             [QMMProfileCellModel modelWithType:ProfileCellTypeList
//                                         title:@"发现星球"
//                                          desc:@""
//                                        mapStr:kModuleWebView
//                                         value:@{
//                                                 @"urlString": @"https://http://m.baidu.com/"
//                                                 }],
             [QMMProfileCellModel modelWithType:ProfileCellTypeList
                                         title:@"邀请好友"
                                          desc:@""
                                        mapStr:kModuleWebView
                                         value:@{
                                                 @"urlString": @"https://http://m.baidu.com/"
                                                 }],
             [QMMProfileCellModel modelWithType:ProfileCellTypeListInfo
                                          title:@"反馈问题"
                                           desc:@"kefu@huayuanvip.com"
                                         mapStr:nil
                                          value:nil]
             ];
}

- (NSArray *)menus {
    NSString *url = kModuleMembership;//[NSString stringWithFormat:@"com.tm.IwantYou:///%@", kModuleMembership];
    return @[
             [QMMProfileCellModel modelWithTitle:@"无限畅聊" desc:@"profile_menu_chat" mapStr:url value:nil],
             [QMMProfileCellModel modelWithTitle:@"尊贵标签" desc:@"profile_menu_tag" mapStr:url value:nil],
             [QMMProfileCellModel modelWithTitle:@"排名优先" desc:@"profile_menu_sort" mapStr:url value:nil],
             [QMMProfileCellModel modelWithTitle:@"自由备注" desc:@"profile_menu_mark" mapStr:url value:nil],
             [QMMProfileCellModel modelWithTitle:@"定制打招呼" desc:@"profile_menu_hello" mapStr:url value:nil],
             [QMMProfileCellModel modelWithTitle:@"上线提醒" desc:@"profile_menu_notif" mapStr:url value:nil],
             [QMMProfileCellModel modelWithTitle:@"最后登陆时间" desc:@"profile_menu_time" mapStr:url value:nil],
             [QMMProfileCellModel modelWithTitle:@"敬请期待" desc:@"profile_menu_smile" mapStr:url value:nil],
             ];
}


- (RACSignal *)userInfoSignalWithParams:(NSDictionary *)params {
    return [QMMRequestAdapter requestSignalParams:[params decodeWithAPI:API_PROFILE]
                                     responseType:YSResponseTypeObject
                                    responseClass:[HYUserModel class]];
}

- (RACSignal *)logoutSignalWithParams:(NSDictionary *)params {
    return [QMMRequestAdapter requestSignalParams:[params decodeWithAPI:API_LOGOUT]
                                     responseType:YSResponseTypeMessage
                                    responseClass:nil];
}


@end
