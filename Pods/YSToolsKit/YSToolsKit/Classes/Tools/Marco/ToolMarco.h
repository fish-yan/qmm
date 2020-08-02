//
//  ToolMarco.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/12.
//  Copyright © 2017年 Joseph. All rights reserved.
//

/*
    工具类类型的宏定义文件
 */
#ifndef ToolMarco_h
#define ToolMarco_h

//------------------------------------------------------------------------------
#pragma mark - 去除performSelector警告

/// 解决ARC performSelector 警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
        do { \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
            Stuff; \
            _Pragma("clang diagnostic pop") \
        } while (0)


/// weakifly/ strongify
#define WEAKIFLY_SELF  __weak __typeof(self)weakSelf = self;
#define STRONGIFY_SELF  __strong __typeof(self)self = weakSelf;
#define WEAKIFLY(aObj)  __weak __typeof(aObj)weakAobj = aObj;
#define STRONGIFY(aObj)  __strong __typeof(aObj)aObj = weakAobj;


//------------------------------------------------------------------------------
#pragma mark - 判断是否为空

/// 判断是否为NULL
#define ISNULL(aValue) ([aValue isEqual:[NSNull null]] || (aValue == nil) || (((NSString *)aValue).length == 0))


//------------------------------------------------------------------------------
#pragma mark - 颜色

#define COLOR_RGB(r, g, b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha: 1.0]
#define COLOR_RGBA(r, g, b, a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha: a]
#define COLOR_HEX(h)            [UIColor colorWithHex:h alpha:1.0]
#define COLOR_HEXA(h, a)        [UIColor colorWithHex:h alpha:a]

/// rgb颜色转换（16进制->10进制）
#define UIColorByRGB(rgbValue)  \
        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                         blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#endif /* ToolMarco_h */
