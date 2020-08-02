//
//  HYPrivateCellViewModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYPrivateCellViewModel : YSBaseViewModel

@property (nonatomic, copy) NSURL *phtotUrl;
@property (nonatomic, copy) NSString *photoString;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *lastMessage;
@property (nonatomic, assign) NSNumber *isread;
@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *fromsex;
@property (nonatomic, copy) NSString *newcount;
@property (nonatomic, assign) NSNumber *isVip;
@property (nonatomic, copy) NSMutableAttributedString *des;
@property (nonatomic, assign) NSNumber *usertype;

@property (nonatomic, strong) RACCommand *doRecommand;

@property (nonatomic, assign) BOOL hasRead;

@end

NS_ASSUME_NONNULL_END
