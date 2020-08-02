//
//  HYUserInfoCellModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUserInfoCellModel.h"

@implementation HYUserInfoCellModel

+ (instancetype)modelWithType:(UserInfoCellType)cellType
                        value:(id)values
                        title:(NSString *)title
                         desc:(NSString *)desc {
    HYUserInfoCellModel *m = [HYUserInfoCellModel new];
    m.cellType = cellType;
    
    switch (cellType) {
        case UserInfoCellTypeHeader: {
            m.cellHeight = SCREEN_WIDTH / 375.0 * 280.0;;
            break;
        }
        case UserInfoCellTypeInfo: {
            m.cellHeight = 96;
            break;
        }
        case UserInfoCellTypePhotos: {
            NSArray *imgs = values;
            CGFloat h = 48.0;
            CGFloat wh = (SCREEN_WIDTH - 2) / 3;
            if (imgs.count >= 3) {
                m.cellHeight = h + wh * 2 + 2;
            } else {
                m.cellHeight = h + wh;
            }
            break;
        }
        case UserInfoCellTypeList: {
            m.cellHeight = 48.0;
            break;
        }
            
        default:
            break;
    }
    m.value = values;
    m.title = title;
    m.desc = desc;
    return m;
}

@end
