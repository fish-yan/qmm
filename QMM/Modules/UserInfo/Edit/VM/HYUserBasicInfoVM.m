//
//  HYUserBasicInfoVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUserBasicInfoVM.h"
#import "HYUserBasicInfoCellModel.h"

@implementation HYUserBasicInfoVM


- (instancetype)init {
    if (self = [super init]) {
        [self combineDataArray];
        [self bind];
    }
    return self;
}

- (void)bind {
    @weakify(self);
    [RACObserve(self, infoModel) subscribeNext:^(HYUserCenterModel * _Nullable x) {
        @strongify(self);
        NSArray *arr;
        if (self.type == UserInfoEditTypeBasic) {
            arr = [self basicInfoArrayWithModel:x];
        }
        else {
            arr = [self friendRequireArrayWithModel:x];
        }
        self.dataArray = arr.mutableCopy;
    }];
}


- (NSArray *)friendRequireArrayWithModel:(HYUserCenterModel *)x {
    NSString *height = @"";
    NSString *age = @"";
    if (x.wantheightstart && x.wantheightend) {
        height = [NSString stringWithFormat:@"%@cm-%@cm", x.wantheightstart, x.wantheightend];
    }
    if (x.wantagestart && x.wantageend) {
        age = [NSString stringWithFormat:@"%@-%@", x.wantagestart, x.wantageend];
    }
    
    NSArray *arr =
    @[
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendWorkPlace
                                         name:@"工作所在地"
                                         icon:@"workplace"
                                         info:[NSString stringWithFormat:@"%@ %@ %@", x.wantprovincestr, x.wantcitystr, x.wantdistrictstr]],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendHome
                                         name:@"家乡所在地"
                                         icon:@"homeplace"
                                         info:[NSString stringWithFormat:@"%@ %@ %@", x.wanthomeprovincestr, x.wanthomecitystr, x.wanthomedistrictstr]],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendAge
                                         name:@"年龄"
                                         icon:@"birthday"
                                         info:age],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendHeight
                                         name:@"身高"
                                         icon:@"height"
                                         info:height],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendEdu name:@"学历" icon:@"schoolLevel" info:x.wantdegree],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendIncome name:@"月收入" icon:@"salary" info:x.wantsalary]
      ];
    return arr;
}

- (NSArray *)basicInfoArrayWithModel:(HYUserCenterModel *)x {
    NSArray *arr =
    @[
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeName name:@"姓名" icon:@"nickname" info:x.name],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeWorkPlace
                                         name:@"工作所在地"
                                         icon:@"workplace"
                                         info:[NSString stringWithFormat:@"%@ %@ %@", x.provincestr, x.citystr, x.districtstr]],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeHome
                                         name:@"家乡所在地"
                                         icon:@"homeplace"
                                         info:[NSString stringWithFormat:@"%@ %@ %@", x.homeprovincestr, x.homecitystr, x.homedistrictstr]],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeBirthday
                                         name:@"生日"
                                         icon:@"birthday"
                                         info:[NSString stringWithFormat:@"%@-%@-%@", x.birthyear, x.birthmonth, x.birthday]],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeHeight
                                         name:@"身高"
                                         icon:@"height"
                                         info:[NSString stringWithFormat:@"%@cm", x.height]],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeEdu name:@"学历" icon:@"schoolLevel" info:x.schoollevel],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeJob name:@"职业" icon:@"profession" info:x.personal],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeIncome name:@"月收入" icon:@"salary" info:x.reciveSalary],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeConstellation
                                         name:@"星座"
                                         icon:@"constellation"
                                         info:x.constellation],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeMarryDate
                                         name:@"期望结婚时间"
                                         icon:@"marrytime"
                                         info:x.wantMarry],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeMarryStatus
                                         name:@"目前婚姻状况"
                                         icon:@"marrayStatus"
                                         info:x.marry]
      ];
    return arr;
}

- (void)combineDataArray {
    self.dataArray =
    @[
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeName name:@"姓名" icon:@"nickname" info:nil],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeWorkPlace name:@"工作所在地" icon:@"workplace" info:nil],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeHome name:@"家乡所在地" icon:@"homeplace" info:nil],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeBirthday name:@"生日" icon:@"birthday" info:nil],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeHeight name:@"身高" icon:@"height" info:nil],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeEdu name:@"学历" icon:@"schoolLevel" info:nil],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeJob name:@"职业" icon:@"profession" info:nil],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeIncome name:@"月收入" icon:@"salary" info:nil],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeConstellation name:@"星座" icon:@"constellation" info:nil],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeMarryDate name:@"期望结婚时间" icon:@"marrytime" info:nil],
      [HYUserBasicInfoCellModel modelWithType:BasicInfoCellTypeMarryStatus name:@"目前婚姻状况" icon:@"marrayStatus" info:nil]
      ];
}

@end
