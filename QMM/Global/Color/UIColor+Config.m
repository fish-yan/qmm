//
//  UIColor+Config.m
//  youbaner
//
//  Created by luzhongchang on 17/7/29.
//  Copyright © 2017年 luzhongchang. All rights reserved.
//

#import "UIColor+Config.h"

@implementation UIColor (Config)
static const char *colorNameDB=","
"tc0#ffffff,tc1#949494,tc2#ff8bb1,tc3#313131,tc4#bcbcbc,#tc5#a6a6a6,tc7#7d7d7d,tc8#a9a9a9,"
"bg0#f7f7f7,bg2#fd5492,bg1#dbdbdbd,bg3#f6f6f6,bg4#a1e65b,"
"bt0#f97ba6,bt1#e7e7e7,"
"line0#e7e7e7,"
;
+(UIColor*)searchForColorByName:(NSString*)cssColorName
{
    UIColor *result = nil;
    const char *searchString = [[NSString stringWithFormat:@",%@#", cssColorName] UTF8String];
    const char *found = strstr(colorNameDB, searchString);
    if (found) {
        const char *after = found + strlen(searchString);
        int hex;
        if (sscanf(after, "%x", &hex) == 1) {
            result = [self colorWithHex:hex];
        }
    }
    
    return result;
}


#pragma mark color
+(UIColor*)tc0Color
{
    return [UIColor searchForColorByName:@"tc0"];
}


+(UIColor*)tc3Color
{
    return [UIColor searchForColorByName:@"tc3"];
}

+(UIColor *)tc1Color
{
    return [UIColor searchForColorByName:@"tc1"];
}


+(UIColor *)tc4Color
{
    return [UIColor searchForColorByName:@"tc4"];
}

+(UIColor*)tc7Color
{
    return [UIColor searchForColorByName:@"tc7"];
}


+(UIColor*)tc2Color
{
    return [UIColor searchForColorByName:@"tc2"];
}

+(UIColor*)tc5Color
{
    return [UIColor searchForColorByName:@"tc5"];
}

+(UIColor*)tc8Color
{
    return [UIColor searchForColorByName:@"tc8"];
}

+(UIColor*)bg0Color
{
     return [UIColor searchForColorByName:@"bg0"];
}

+(UIColor*)bg2Color
{
    return [UIColor searchForColorByName:@"bg2"];
}

+(UIColor*)bt0Color
{
     return [UIColor searchForColorByName:@"bt0"];
}

+(UIColor *)bg3Color
{
    return [UIColor searchForColorByName:@"bg3"];
}

+(UIColor *)bg4Color
{
    return [UIColor searchForColorByName:@"bg4"];
}


+(UIColor*)bg1Color
{
    return [UIColor searchForColorByName:@"bg1"];
}


+(UIColor*)bt1Color
{
    return  [UIColor searchForColorByName:@"bt1"];
}


+(UIColor*)line0Color
{
    return [UIColor searchForColorByName:@"line0"];
}

@end
