//
//  YSVersionCompare.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/5.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "YSVersionCompare.h"

@implementation YSVersionCompare

int compareVersion(const char *v1, const char *v2) {
    assert(v1);
    assert(v2);
    
    const char *p_v1 = v1;
    const char *p_v2 = v2;
    
    while (*p_v1 && *p_v2) {
        char buf_v1[32] = {0};
        char buf_v2[32] = {0};
        
        char *i_v1 = strchr(p_v1, '.');
        char *i_v2 = strchr(p_v2, '.');
        
        if (!i_v1 || !i_v2) break;
        
        if (i_v1 != p_v1) {
            strncpy(buf_v1, p_v1, i_v1 - p_v1);
            p_v1 = i_v1;
        }
        else
            p_v1++;
        
        if (i_v2 != p_v2) {
            strncpy(buf_v2, p_v2, i_v2 - p_v2);
            p_v2 = i_v2;
        }
        else
            p_v2++;
        
        
        
        int order = atoi(buf_v1) - atoi(buf_v2);
        if (order != 0)
            return order < 0 ? -1 : 1;
    }
    
    double res = atof(p_v1) - atof(p_v2);
    
    if (res < 0) return -1;
    if (res > 0) return 1;
    return 0;
}

@end
