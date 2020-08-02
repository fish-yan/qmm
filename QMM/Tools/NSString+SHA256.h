//
//  NSString+SHA256.h
//  youbaner
//
//  Created by luzhongchang on 2017/8/30.
//  Copyright © 2017年 luzhongchang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SHA256)

- (NSString *)SHA256;
- (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;
@end
