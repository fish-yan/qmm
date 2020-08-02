//
//  LEEAttributed.h
//  AttributedStringTest
//
//  Created by Li,Huanan on 2017/6/1.
//  Copyright © 2017年 Li,Huanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEEAttributedMake.h"


typedef void(^AttributedMakeBlock)(LEEAttributedMake *make);

@interface LEEAttributed : NSObject

+ (NSMutableAttributedString *)attributedMake:(AttributedMakeBlock)block;

@end
