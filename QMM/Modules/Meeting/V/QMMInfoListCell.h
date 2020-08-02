//
//  QMMInfoListCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, InfoListCellType) {
    InfoListCellTypeCity,
    InfoListCellTypeDistance,
};


@interface QMMInfoListCell : YSBaseTableViewCell

@property (nonatomic, strong) QMMMemberInfoModel *model;

@property (nonatomic, assign) InfoListCellType cellType;

@property (nonatomic, copy) void(^msgClickHandler)(NSString *uid,NSString * name,NSString * avatar);
@property (nonatomic, copy) void(^dateClickHandler)(NSString *dateId, NSString *uid);
@property (nonatomic, copy) void(^heartClickHandler)(NSString *uid, NSInteger type);
@property (nonatomic, copy) void(^memberClicked)(void);

@end

NS_ASSUME_NONNULL_END
