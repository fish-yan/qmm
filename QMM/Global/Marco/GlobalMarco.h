//
//  GlobalMarco.h
//  youbaner
//
//  Created by luzhongchang on 17/7/29.
//  Copyright © 2017年 luzhongchang. All rights reserved.
//

#ifndef GlobalMarco_h
#define GlobalMarco_h

typedef enum : NSUInteger {
    HYHOME_LETGO =1,
    HYHOME,
} HomeType;


typedef enum : NSUInteger {
    HYGOTOUserNameEditorType,
    HYGOTOWorkPlaceEditorType,
    HYGOTOHomePlaceEditorType,
    HYGOTOBirthEditorType,
    HYGOTOHeightEditorType,
    HYGOTOSchoolLevelEditorType,
    HYGOTOProfessialEditorType,
    HYGOTOSalaryEditorType,
    HYGOTOConstellationEditorType,
    HYGOTOWantMarrayTimeEditorType,
    HYGOTOMarrayStatusEditorType,
    HYGOTOGeneralStatusEditorType,
    
    
} HYEditorType;



#define APP_ERROR_DOMAIN                @"mobi.wonders.ios.apps.youbaner"          // 错误信息Domain

#define AVATAR_PLACEHOLDER  [HYUserContext shareContext].avatarPlaceholder  // 全局头像占位
#define OBJECT_CALL [HYUserContext shareContext].objectCall

#endif /* GlobalMarco_h */
