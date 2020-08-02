//
//  LEEAttributed.m
//  AttributedStringTest
//
//  Created by Li,Huanan on 2017/6/1.
//  Copyright © 2017年 Li,Huanan. All rights reserved.
//

#import "LEEAttributed.h"
#import "LEEAttributedMake.h"


@implementation LEEAttributed

+ (NSMutableAttributedString *)attributedMake:(AttributedMakeBlock)block {
    
    LEEAttributedMake *make = [[LEEAttributedMake alloc] init];
    block(make);
    return make.leeString;
}

@end
