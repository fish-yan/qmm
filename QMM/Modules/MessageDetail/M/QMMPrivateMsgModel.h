//
//  QMMPrivateMsgModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"

@interface QMMPrivateMsgModel : YSBaseModel

@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, assign) BOOL isself;    //是否是自己
@property (nonatomic, strong) NSString *appointmentstatus;
@property (nonatomic, strong) NSString *appointmentid;
@property (nonatomic, assign) NSNumber *type;
@property (nonatomic, strong) NSString *appointmentaddress;
@property (nonatomic, strong) NSString *useravatar;
@property (nonatomic, strong) NSString *appointmentdate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *messageContent;

@end
