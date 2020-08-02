//
//  YSResponseModel.h
//  MyProject
//
//  Created by Joseph Gao on 2017/5/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSResponseModel : NSObject

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) id data;
/// 响应的数据是否需要解密
@property (nonatomic, strong) NSNumber *encode;

/// 总页数, 只有是列表的时候才会有
@property (nonatomic ,assign) NSInteger totalpage;
/// 总数量, 只有是列表的时候才会有
@property (nonatomic ,assign) NSInteger total;

@property (nonatomic, strong) id extra;
@end


//@interface YSListModel : NSObject
//
//@property (nonatomic, strong) NSNumber      *more;
//@property (nonatomic, strong) NSDictionary  *more_params;
//@property (nonatomic, strong) NSDictionary  *extras;
//@property (nonatomic, strong) NSArray       *content;
//
//@end
