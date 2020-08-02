//
//  NSDictionary+DecodeParams.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DecodeParams)

- (NSDictionary *)decodeWithAPI:(NSString *)API;

@end
