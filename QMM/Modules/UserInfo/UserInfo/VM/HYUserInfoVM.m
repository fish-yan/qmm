//
//  HYUserInfoVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUserInfoVM.h"
#import "HYUserInfoCellModel.h"
#import "HYUpdateUserInfoHelper.h"

@interface HYUserInfoVM ()

@property (nonatomic, strong) HYUpdateUserInfoHelper *helper;

@end

@implementation HYUserInfoVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.helper = [HYUpdateUserInfoHelper new];
    self.updateCmd = self.helper.updateCmd;
    
    @weakify(self);
    self.requestCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [[self userInfoSignal]
                doNext:^(id _Nullable x) {
                    @strongify(self);
                    switch (self.type) {
                        case UserTypeSelf:{
                            [self combineSelfDataArrayWithModel:x];
                            break;
                        }
                        case UserTypeOther: {
                            [self combineOtherDataArrayWithModel:x];
                            break;
                        }
                    }
                    self.infoModel = x;
                }];
    }];
}

- (void)combineSelfDataArrayWithModel:(HYUserCenterModel *)model {
    self.name              = model.name;
    self.avatar            = model.avatar;
    
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    // --
    HYUserInfoCellModel *cellModel01 = [HYUserInfoCellModel modelWithType:UserInfoCellTypeHeader
                                                                    value:model.avatar
                                                                    title:nil
                                                                     desc:nil];
    [arrM addObject:@[cellModel01]];
    
    // 图片
    HYUserInfoCellModel *cellModelPics = [HYUserInfoCellModel modelWithType:UserInfoCellTypePhotos
                                                                      value:model.photos
                                                                      title:nil
                                                                       desc:nil];
    [arrM addObject:@[cellModelPics]];
    
    
    //
    [arrM addObject:
     @[
       [HYUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"基本资料" desc:nil],
       [HYUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"交友条件" desc:nil],
       [HYUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"自我介绍" desc:nil],
       ]];
    
    self.dataArray = arrM.copy;
}

- (void)combineOtherDataArrayWithModel:(HYUserInfoModel *)model {
    self.name              = model.name;
    self.avatar            = model.avatar;
    self.appointmentstatus = model.appointmentstatus;
    self.dateId            = model.appointmentid;
    self.beckoningstatus   = [model.beckoningstatus boolValue];
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    // --
    HYUserInfoCellModel *cellModel01 = [HYUserInfoCellModel modelWithType:UserInfoCellTypeHeader
                                                                    value:model.avatar
                                                                    title:nil
                                                                     desc:nil];
    HYUserInfoCellModel *cellModel02 = [HYUserInfoCellModel modelWithType:UserInfoCellTypeInfo
                                                                    value:model
                                                                    title:nil
                                                                     desc:nil];
    [arrM addObject:@[
                      cellModel01,
                      cellModel02]];
    
    
    // 图片
    NSMutableArray *tempM = [NSMutableArray arrayWithCapacity:3];
    if (model.photos.count) {
        HYUserInfoCellModel *cellModelPics = [HYUserInfoCellModel modelWithType:UserInfoCellTypePhotos
                                                                          value:model.photos
                                                                          title:nil
                                                                           desc:nil];
        [tempM addObject:cellModelPics];
    }
    
    HYUserInfoCellModel *cellModelTags = [HYUserInfoCellModel modelWithType:UserInfoCellTypeTags
                                                                      value:model.baseinfo
                                                                      title:@"基本资料"
                                                                       desc:nil];
    [tempM addObject:cellModelTags];
    HYUserInfoCellModel *cellModeldesc = [HYUserInfoCellModel modelWithType:UserInfoCellTypeDesc
                                                                      value:nil
                                                                      title:@"交友条件"
                                                                       desc:model.friendreq];
    [tempM addObject:cellModeldesc];
    [arrM addObject:tempM];
    
    
    
    
    //
    HYUserInfoCellModel *cellModelIntro = [HYUserInfoCellModel modelWithType:UserInfoCellTypeDesc
                                                                       value:nil
                                                                       title:@"自我介绍"
                                                                        desc:model.intro];
    [arrM addObject:@[cellModelIntro]];
    
    //
    [arrM addObject:
     @[
       [HYUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"最后登陆时间" desc:@""],
       [HYUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"上线提醒" desc:@""],
       [HYUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"设置备注" desc:@""],
       ]];
    
    self.dataArray = arrM.copy;
}
- (void)combineDataArrayWithInfoModel:(HYUserCenterModel *)userModel {
    NSMutableArray *arrM = [NSMutableArray array];
    
    // --
    HYUserInfoCellModel *cellModel01 = [HYUserInfoCellModel modelWithType:UserInfoCellTypeHeader
                                                                    value:userModel.avatar
                                                                    title:nil
                                                                     desc:nil];
    HYUserInfoCellModel *cellModel02 = [HYUserInfoCellModel modelWithType:UserInfoCellTypeInfo
                                                                    value:userModel
                                                                    title:nil
                                                                     desc:nil];
    [arrM addObject:@[
                      cellModel01,
                      cellModel02]];
    // 图片
    HYUserInfoCellModel *cellModelPics = [HYUserInfoCellModel modelWithType:UserInfoCellTypePhotos
                                                                      value:userModel.photos
                                                                      title:nil
                                                                       desc:nil];
    NSArray *arr = @[@"23岁", @"工作生活在：上海",@"168cm", @"本科",@"10W-20W", @"期望两年内结婚"];
    HYUserInfoCellModel *cellModelTags = [HYUserInfoCellModel modelWithType:UserInfoCellTypeTags
                                                                      value:arr
                                                                      title:@"基本资料"
                                                                       desc:nil];
    HYUserInfoCellModel *cellModeldesc = [HYUserInfoCellModel modelWithType:UserInfoCellTypeDesc
                                                                      value:@"TODO: 用户信息模型"
                                                                      title:@"交友条件"
                                                                       desc:@"我希望你在上海，24-30岁之间，身高170cm以上，月收入10K-20K，但这些并不是硬性条件， 对的人才重要，和我多多联系吧。"];
    [arrM addObject:@[cellModelPics, cellModelTags, cellModeldesc]];
    
    
    
    
    //
    [arrM addObject:
     @[
       [HYUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"昵称" desc:@"张三"],
       [HYUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"所在地区" desc:@""],
       [HYUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"交友条件" desc:@""],
       [HYUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"自我介绍" desc:@""],
       ]];
    
    self.dataArray = arrM.copy;
    
}

- (RACSignal *)userInfoSignal {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.uid ?: @"" forKey:@"id"];
    NSString *api = API_USER_INFO;
    Class cls = [HYUserInfoModel class];
    
    if (self.type == UserTypeSelf) {
        [params setObject:@2 forKey:@"version"];
        api = API_PROFILE;
        cls = [HYUserCenterModel class];
    }
    
    return [[YSRequestAdapter requestSignalWithURL:@""
                                            params:[params decodeWithAPI:api]
                                       requestType:YSRequestTypePOST
                                      responseType:YSResponseTypeObject
                                     responseClass:cls]
            map:^id _Nullable(YSResponseModel * _Nullable value) {
                return value.data;
            }];
}

@end
