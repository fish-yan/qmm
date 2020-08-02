//
//  QMMUserInfoVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMUserInfoVM.h"
#import "QMMUserInfoCellModel.h"
#import "QMMUpdateUserInfoHelper.h"

@interface QMMUserInfoVM ()

@property (nonatomic, strong) QMMUpdateUserInfoHelper *helper;

@end

@implementation QMMUserInfoVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.helper = [QMMUpdateUserInfoHelper new];
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

- (void)combineSelfDataArrayWithModel:(HYUserModel *)model {
    self.name              = model.name;
    self.avatar            = model.avatar;
    
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    // --
    QMMUserInfoCellModel *cellModel01 = [QMMUserInfoCellModel modelWithType:UserInfoCellTypeHeader
                                                                    value:model.avatar
                                                                    title:nil
                                                                     desc:nil];
    [arrM addObject:@[cellModel01]];
    
    // 图片
    QMMUserInfoCellModel *cellModelPics = [QMMUserInfoCellModel modelWithType:UserInfoCellTypePhotos
                                                                      value:model.photos
                                                                      title:nil
                                                                       desc:nil];
    [arrM addObject:@[cellModelPics]];
    
    
    //
    [arrM addObject:
     @[
       [QMMUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"基本资料" desc:nil],
       [QMMUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"交友条件" desc:nil],
       [QMMUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"自我介绍" desc:nil],
       ]];
    
    self.dataArray = arrM.copy;
}

- (void)combineOtherDataArrayWithModel:(QMMUserInfoModel *)model {
    self.name              = model.name;
    self.avatar            = model.avatar;
    self.appointmentstatus = model.appointmentstatus;
    self.dateId            = model.appointmentid;
    self.beckoningstatus   = [model.beckoningstatus boolValue];
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    // --
    QMMUserInfoCellModel *cellModel01 = [QMMUserInfoCellModel modelWithType:UserInfoCellTypeHeader
                                                                    value:model.avatar
                                                                    title:nil
                                                                     desc:nil];
    QMMUserInfoCellModel *cellModel02 = [QMMUserInfoCellModel modelWithType:UserInfoCellTypeInfo
                                                                    value:model
                                                                    title:nil
                                                                     desc:nil];
    [arrM addObject:@[
                      cellModel01,
                      cellModel02]];
    
    
    // 图片
    NSMutableArray *tempM = [NSMutableArray arrayWithCapacity:3];
    if (model.photos.count) {
        QMMUserInfoCellModel *cellModelPics = [QMMUserInfoCellModel modelWithType:UserInfoCellTypePhotos
                                                                          value:model.photos
                                                                          title:nil
                                                                           desc:nil];
        [tempM addObject:cellModelPics];
    }
    
    QMMUserInfoCellModel *cellModelTags = [QMMUserInfoCellModel modelWithType:UserInfoCellTypeTags
                                                                      value:model.baseinfo
                                                                      title:@"基本资料"
                                                                       desc:nil];
    [tempM addObject:cellModelTags];
    QMMUserInfoCellModel *cellModeldesc = [QMMUserInfoCellModel modelWithType:UserInfoCellTypeDesc
                                                                      value:nil
                                                                      title:@"交友条件"
                                                                       desc:model.friendreq];
    [tempM addObject:cellModeldesc];
    [arrM addObject:tempM];
    
    
    
    
    //
    QMMUserInfoCellModel *cellModelIntro = [QMMUserInfoCellModel modelWithType:UserInfoCellTypeDesc
                                                                       value:nil
                                                                       title:@"自我介绍"
                                                                        desc:model.intro];
    [arrM addObject:@[cellModelIntro]];
    
    //
    [arrM addObject:
     @[
       [QMMUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"最后登陆时间" desc:@""],
       [QMMUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"上线提醒" desc:@""],
       [QMMUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"设置备注" desc:@""],
       ]];
    
    self.dataArray = arrM.copy;
}
- (void)combineDataArrayWithInfoModel:(HYUserModel *)userModel {
    NSMutableArray *arrM = [NSMutableArray array];
    
    // --
    QMMUserInfoCellModel *cellModel01 = [QMMUserInfoCellModel modelWithType:UserInfoCellTypeHeader
                                                                    value:userModel.avatar
                                                                    title:nil
                                                                     desc:nil];
    QMMUserInfoCellModel *cellModel02 = [QMMUserInfoCellModel modelWithType:UserInfoCellTypeInfo
                                                                    value:userModel
                                                                    title:nil
                                                                     desc:nil];
    [arrM addObject:@[
                      cellModel01,
                      cellModel02]];
    // 图片
    QMMUserInfoCellModel *cellModelPics = [QMMUserInfoCellModel modelWithType:UserInfoCellTypePhotos
                                                                      value:userModel.photos
                                                                      title:nil
                                                                       desc:nil];
    NSArray *arr = @[@"23岁", @"工作生活在：上海",@"168cm", @"本科",@"10W-20W", @"期望两年内结婚"];
    QMMUserInfoCellModel *cellModelTags = [QMMUserInfoCellModel modelWithType:UserInfoCellTypeTags
                                                                      value:arr
                                                                      title:@"基本资料"
                                                                       desc:nil];
    QMMUserInfoCellModel *cellModeldesc = [QMMUserInfoCellModel modelWithType:UserInfoCellTypeDesc
                                                                      value:@"TODO: 用户信息模型"
                                                                      title:@"交友条件"
                                                                       desc:@"我希望你在上海，24-30岁之间，身高170cm以上，月收入10K-20K，但这些并不是硬性条件， 对的人才重要，和我多多联系吧。"];
    [arrM addObject:@[cellModelPics, cellModelTags, cellModeldesc]];
    
    
    
    
    //
    [arrM addObject:
     @[
       [QMMUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"昵称" desc:@"张三"],
       [QMMUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"所在地区" desc:@""],
       [QMMUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"交友条件" desc:@""],
       [QMMUserInfoCellModel modelWithType:UserInfoCellTypeList value:nil title:@"自我介绍" desc:@""],
       ]];
    
    self.dataArray = arrM.copy;
    
}

- (RACSignal *)userInfoSignal {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.uid ?: @"" forKey:@"id"];
    NSString *api = API_USER_INFO;
    Class cls = [QMMUserInfoModel class];
    
    if (self.type == UserTypeSelf) {
        [params setObject:@2 forKey:@"version"];
        api = API_PROFILE;
        cls = [HYUserModel class];
    }
    
    return [[QMMRequestAdapter requestSignalParams:[params decodeWithAPI:api]
                                      responseType:YSResponseTypeObject
                                     responseClass:cls]
            map:^id _Nullable(YSResponseModel * _Nullable value) {
                return value.data;
            }];
}

@end
