//
//  QMMMeetingCommendCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMMeetingCommendCell : YSBaseTableViewCell

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) void(^topAction)(void);
@property (nonatomic, copy) void(^itemClickedAction)(QMMMemberInfoModel *m);
@property (nonatomic, copy) void(^heartAction)(QMMMemberInfoModel *m);

@end

NS_ASSUME_NONNULL_END
