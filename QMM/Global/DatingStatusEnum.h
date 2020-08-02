//
//  DatingStatusEnum.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/23.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#ifndef DatingStatusEnum_h
#define DatingStatusEnum_h

/*
 0. 未交保证金
 
 发起方
 1. 等待接受状态: 对方没操作,可撤销,
 2. 关闭状态: 被对方拒绝
 
 接收方:
 3. 收到邀请状态: 可拒绝/接受
 
 约会中:
 4. 等待状态: 24小时外, 可取消, 不可签到
 5. 取消等待状态
 6. 取消请求状态
 7. 可签到状态: 前后1小时内, 没签到
 8. 已签到状态
 2. 关闭状态: 没签到, 爽约, 爽约提示
 
 9. 已完成
 
 */
typedef NS_ENUM(NSInteger, DatingStatusType) {
    DatingStatusTypeDidNotPay = 0,      // 未交保证金
    DatingStatusTypeWaitAccept,     // 等待对方确认
    DatingStatusTypeRejected,       // 被拒绝
    DatingStatusTypeGetInvite,      // 收到邀请
    DatingStatusTypeDatingWaiting,    // 约会中 24小时前,等待约会
    DatingStatusTypeWaitAcceptCancel,   // 自己取消,等待同意请求
    DatingStatusTypeGetCancelRequest,   // 接收到取消请求
    DatingStatusTypeCanSignin,     // 约会中, 约定时间前后一小时,可签到状态
    DatingStatusTypeObjectSignin,   // 对方签到了
    DatingStatusTypeHadSignin,     // 已经签到
    DatingStatusTypeClosed,            // 关闭状态
    DatingStatusTypeComplete,            // 完成状态
    DatingStatusTypeInvite = 99  // 发起约会
};

#endif /* DatingStatusEnum_h */
