//
//  LEEAttributedMake.h
//  AttributedStringTest
//
//  Created by Li,Huanan on 2017/6/1.
//  Copyright © 2017年 Li,Huanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LEEAttributedMake : NSObject

@property (nonatomic, copy) NSMutableAttributedString *leeString;

- (LEEAttributedMake *(^)(id))add;

- (LEEAttributedMake *(^)(NSDictionary *))style;

@end
