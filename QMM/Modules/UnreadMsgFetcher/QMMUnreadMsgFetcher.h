//
//  QMMUnreadInfoModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QMMUnreadInfoModel : NSObject

/// 消息未读数量
@property (nonatomic, assign) NSInteger msgcount;
/// 进行中的约会数量
@property (nonatomic, assign) NSInteger appointmentcount;
/// 新增通讯录数量
@property (nonatomic, assign) NSInteger addresscount;

@end


@interface QMMUnreadMsgFetcher : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) RACCommand *unreadMsgCmd;

@end
