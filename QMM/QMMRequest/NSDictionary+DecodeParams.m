//
//  NSDictionary+DecodeParams.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "NSDictionary+DecodeParams.h"
#import "AESUtility.h"

static NSString *const md5_key = @"Gwn1zaQtCPUnd688jIruSS6gZvfShvNB";

@implementation NSDictionary (DecodeParams)

- (NSDictionary *)decodeWithAPI:(NSString *)API {
    NSLog(@"=========> 请求接口为: %@", API);
    NSLog(@"=========> 请求参数为: %@", self);

    NSDictionary *basedic = [self headerDict];
    NSNumber *ver         = [self __verOfApi:API];
    if (self.allValues.count == 0) {
        NSMutableDictionary *dm = [NSMutableDictionary new];
        [dm addEntriesFromDictionary:basedic];
        NSDictionary *rem = @{
            @"code": API,
            @"ver": ver,
            @"sign": [self __md5String:[self __stringOfDict:dm]]
        };

        NSMutableDictionary *targetDic = [NSMutableDictionary new];
        [targetDic addEntriesFromDictionary:basedic];
        [targetDic addEntriesFromDictionary:rem];

        return [targetDic copy];
    }


    NSString *jsonString    = [[self __jsonString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonAes       = [AESUtility AES256Encrypt:jsonString];
    NSMutableDictionary *dm = [NSMutableDictionary new];
    [dm addEntriesFromDictionary:basedic];
    [dm addEntriesFromDictionary:@{ @"body": jsonAes }];
    NSDictionary *rem = @{
        @"body": jsonAes,
        @"code": API,
        @"ver":  ver,
        @"sign": [self __md5String:[self __stringOfDict:dm]]
    };

    NSMutableDictionary *targetDic = [NSMutableDictionary new];
    [targetDic addEntriesFromDictionary:basedic];
    [targetDic addEntriesFromDictionary:rem];

    return [targetDic copy];
}


#pragma mark - Pravita

- (NSDictionary *)headerDict {
    NSString *accessToken = [QMMUserContext shareContext].token ?: @"";
    //接口调用唯一UUID
    NSString *uuid = [[NSUUID UUID] UUIDString];
    //接口调用时间
    NSString *dateTime = [NSString stringWithFormat:@"%ld", (long) [[NSDate date] timeIntervalSince1970]];
    NSString *appVersion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];

    NSDictionary *headerDict = @{
        @"appid": @"4002",
        @"appv": appVersion ?: @"",
        @"token": accessToken,
        @"appch": @"appstore",
        @"did": uuid,
        @"appm": @"native",
        @"dbr": @"ios",
        @"dmd": DEVICE_MODEL,
        @"dos": @"ios",
        @"dscr": [NSString stringWithFormat:@"%@*%@", SCREEN_HEIGHT_STR, SCREEN_WIDTH_STR],
        //                                 @"dnet"  :@"",
        //                                 @"lng"     : @"",
        //                                 @"lat"   :@"",
        @"ts": dateTime
    };
    return headerDict;
    
}


- (NSString *)__jsonString {
    NSError *parseError = nil;
    NSData *jsonData =
    [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSNumber *)__verOfApi:(NSString *)api {
    NSArray *arr = @[
        @"msg-getMessage",
        @"msg-getMsglist",
        @"getuserinfo",
        @"executewechatpaybytype",
        @"executealipay",
        @"rechargememeservicebyapple"
    ];
    NSInteger i = [arr indexOfObject:api];
    if (i == NSNotFound) {
        return @1;
    } else {
        return @2;
    }
}

- (NSString *)__md5String:(NSString *)string {
    NSString *withKey = [string stringByAppendingString:md5_key];
    return [withKey md5String];
}


- (NSString *)__stringOfDict:(NSDictionary *)dic {
    NSMutableArray *array = [NSMutableArray new];

    for (int i = 0; i < dic.count; i++) {
        if ([dic.allValues[i] isEqualToString:@""]) {
            continue;
        }
        NSString *string = [NSString stringWithFormat:@"%@=%@", dic.allKeys[i], dic.allValues[i]];
        [array addObject:string];
    }


    NSArray *sortAfterArray =
    [array sortedArrayUsingComparator:^NSComparisonResult(NSString *_Nonnull obj1, NSString *_Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        if (result == NSOrderedSame) {
            result = [obj1 compare:obj2];
        }
        return result;
    }];

    NSString *md5string = @"";
    for (int i = 0; i < sortAfterArray.count; i++) {
        md5string = [md5string stringByAppendingString:[sortAfterArray objectAtIndex:i]];
        if (i < sortAfterArray.count - 1) {
            md5string = [md5string stringByAppendingString:@"&"];
        }
    }
    return md5string;
}

@end
