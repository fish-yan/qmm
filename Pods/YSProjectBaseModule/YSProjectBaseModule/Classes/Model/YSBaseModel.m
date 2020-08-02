//
//  YSBaseModel.m
//  MyProject
//
//  Created by Joseph Gao on 2017/4/30.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSBaseModel.h"
#import <objc/runtime.h>

@implementation YSBaseModel

- (NSString *)debugDescription {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name] ?: [NSNull null];
        [dictionary setObject:value forKey:name];
    }
    
    free(properties);
    
    return [NSString stringWithFormat:@"<%@: %p>\n%@", [self class], self,dictionary];
}

@end
