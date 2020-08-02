//
//  AppContext.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppContext : NSObject

@property (nonatomic, assign, readonly) BOOL isNewUpdate;

+ (instancetype)shareContext;

@end


@interface AppVersionModel : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *releasenote;
@property (nonatomic, copy) NSString *releasedate;
@property (nonatomic, copy) NSString *updatecmd;

@property (nonatomic, copy) NSString *newversion;
@property (nonatomic, copy) NSString *newnote;
@property (nonatomic, copy) NSString *newdate;
@property (nonatomic, copy) NSString *downloadurl;

@end


NS_ASSUME_NONNULL_END
