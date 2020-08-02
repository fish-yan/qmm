//
//  ZMCertHelper.h
//  QMM
//
//  Created by Joseph Koh on 2018/11/14.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMCertHelper : NSObject

+ (instancetype)shareHelper;

- (void)doVerify:(NSString *)url;

@end
