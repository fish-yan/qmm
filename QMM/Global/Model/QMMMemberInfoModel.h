//
//  QMMMemberInfoModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMMemberInfoModel : YSBaseModel

@property (nonatomic, copy) NSString *uid;
// 头像
@property (nonatomic, copy) NSString *avatar;
// 心动状态(0:未心动,1:已心动)
@property (nonatomic, assign) BOOL beckoningstatus;
// 名称
@property (nonatomic, copy) NSString *name;
// 年龄
@property (nonatomic, copy) NSString *age;
// 身高
@property (nonatomic, copy) NSString *height;
// 收入
@property (nonatomic, copy) NSString *msalary;
// 自我介绍
@property (nonatomic, copy) NSString *intro;
// 工作地址城市
@property (nonatomic, copy) NSString *workcity;
// 是否是会员(0:非会员,1:是会员)
@property (nonatomic, assign) BOOL vipstatus;
/// 是否是约会状态，0:非约会中,1:约会中
@property (nonatomic, assign) BOOL appointmentstatus;
@property (nonatomic, copy) NSString *appointmentid;
@property (nonatomic, copy) NSString *distance;


@end

NS_ASSUME_NONNULL_END
