//
//  QMMRequestAdapter.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/23.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YSProjectRequest/YSProjectRequest.h>

@interface QMMRequestAdapter : NSObject

+ (RACSignal *)requestSignalParams:(NSDictionary *)params
                       responseType:(YSResponseType)responseType
                      responseClass:(Class)responseClass;

@end
