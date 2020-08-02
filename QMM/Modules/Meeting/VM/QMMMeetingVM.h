//
//  QMMMeetingVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"
#import "QMMFilterRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ContentType) {
    ContentTypeRecommend = 1,
    ContentTypeLatest,
    ContentTypeNearby,
};


@interface QMMMeetingVM : YSBaseViewModel

@property (nonatomic, strong) RACCommand *requestDataCmd;
@property (nonatomic, strong) RACCommand *commendRequestCmd;
@property (nonatomic, strong) RACCommand *listRequestCmd;
//@property (nonatomic, strong) RACCommand *filterRequestCmd;

@property (nonatomic, strong) QMMFilterRecordModel *filterInfos;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *commendArray;
@property (nonatomic, strong) NSArray *listArray;

@property (nonatomic, assign) ContentType type;
@property (nonatomic, assign) BOOL hasCommend;

@end

NS_ASSUME_NONNULL_END
