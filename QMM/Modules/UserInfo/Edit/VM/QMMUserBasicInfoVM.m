//
//  QMMUserBasicInfoVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMUserBasicInfoVM.h"
#import "QMMUserBasicInfoCellModel.h"

@implementation QMMUserBasicInfoVM


- (instancetype)init {
    if (self = [super init]) {
        [self combineDataArray];
        [self bind];
    }
    return self;
}

- (void)bind {
    @weakify(self);
    [RACObserve(self, infoModel) subscribeNext:^(HYUserModel * _Nullable x) {
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


- (NSArray *)friendRequireArrayWithModel:(HYUserModel *)x {
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
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendWorkPlace
                                         name:@"工作所在地"
                                         icon:@"workplace"
                                         info:[NSString stringWithFormat:@"%@ %@ %@", x.wantprovincestr, x.wantcitystr, x.wantdistrictstr]],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendHome
                                         name:@"家乡所在地"
                                         icon:@"homeplace"
                                         info:[NSString stringWithFormat:@"%@ %@ %@", x.wanthomeprovincestr, x.wanthomecitystr, x.wanthomedistrictstr]],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendAge
                                         name:@"年龄"
                                         icon:@"birthday"
                                         info:age],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendHeight
                                         name:@"身高"
                                         icon:@"height"
                                         info:height],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendEdu name:@"学历" icon:@"schoolLevel" info:x.wantdegree],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeFriendIncome name:@"月收入" icon:@"salary" info:x.wantsalary]
      ];
    return arr;
}

- (NSArray *)basicInfoArrayWithModel:(HYUserModel *)x {
    NSArray *arr =
    @[
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeName name:@"姓名" icon:@"nickname" info:x.name],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeWorkPlace
                                         name:@"工作所在地"
                                         icon:@"workplace"
                                         info:[NSString stringWithFormat:@"%@ %@ %@", x.provincestr, x.citystr, x.districtstr]],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeHome
                                         name:@"家乡所在地"
                                         icon:@"homeplace"
                                         info:[NSString stringWithFormat:@"%@ %@ %@", x.homeprovincestr, x.homecitystr, x.homedistrictstr]],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeBirthday
                                         name:@"生日"
                                         icon:@"birthday"
                                         info:[NSString stringWithFormat:@"%@-%@-%@", x.birthyear, x.birthmonth, x.birthday]],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeHeight
                                         name:@"身高"
                                         icon:@"height"
                                         info:[NSString stringWithFormat:@"%@cm", x.height]],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeEdu name:@"学历" icon:@"schoolLevel" info:x.schoollevel],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeJob name:@"职业" icon:@"profession" info:x.personal],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeIncome name:@"月收入" icon:@"salary" info:x.reciveSalary],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeConstellation
                                         name:@"星座"
                                         icon:@"constellation"
                                         info:x.constellation],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeMarryDate
                                         name:@"期望结婚时间"
                                         icon:@"marrytime"
                                         info:x.wantMarry],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeMarryStatus
                                         name:@"目前婚姻状况"
                                         icon:@"marrayStatus"
                                         info:x.marry]
      ];
    return arr;
}

- (void)combineDataArray {
    self.dataArray =
    @[
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeName name:@"姓名" icon:@"nickname" info:nil],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeWorkPlace name:@"工作所在地" icon:@"workplace" info:nil],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeHome name:@"家乡所在地" icon:@"homeplace" info:nil],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeBirthday name:@"生日" icon:@"birthday" info:nil],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeHeight name:@"身高" icon:@"height" info:nil],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeEdu name:@"学历" icon:@"schoolLevel" info:nil],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeJob name:@"职业" icon:@"profession" info:nil],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeIncome name:@"月收入" icon:@"salary" info:nil],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeConstellation name:@"星座" icon:@"constellation" info:nil],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeMarryDate name:@"期望结婚时间" icon:@"marrytime" info:nil],
      [QMMUserBasicInfoCellModel modelWithType:BasicInfoCellTypeMarryStatus name:@"目前婚姻状况" icon:@"marrayStatus" info:nil]
      ];
}

@end
