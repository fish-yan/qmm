//
//  QMMProfileCellModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMProfileCellModel.h"

@implementation QMMProfileCellModel

+ (instancetype)modelWithTitle:(NSString *)title
                          desc:(NSString *)desc
                        mapStr:(NSString *)mapStr
                         value:(id)value {
    return [self modelWithType:ProfileCellTypeNull
                         title:title
                          desc:desc
                        mapStr:mapStr
                         value:value];
}

+ (instancetype)modelWithType:(ProfileCellType)type
                        title:(NSString *)title
                         desc:(NSString *)desc
                       mapStr:(NSString *)mapStr
                        value:(id)value {
    QMMProfileCellModel *m = [QMMProfileCellModel new];
    m.type = type;
    m.title = title;
    m.desc = desc;
    m.mapStr = mapStr;
    m.value = value;
    return m;
}


@end
