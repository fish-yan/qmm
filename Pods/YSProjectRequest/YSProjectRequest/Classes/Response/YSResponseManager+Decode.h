//
//  YSResponseManager+Decode.h
//  Pods
//
//  Created by Joseph Koh on 2018/7/12.
//


#import "YSResponseManager.h"

@interface YSResponseManager (Decode)

+ (id)decryptResponseData:(NSString *)encryptedStr;

@end
