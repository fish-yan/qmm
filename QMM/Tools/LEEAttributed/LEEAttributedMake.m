//
//  LEEAttributedMake.m
//  AttributedStringTest
//
//  Created by Li,Huanan on 2017/6/1.
//  Copyright © 2017年 Li,Huanan. All rights reserved.
//

#import "LEEAttributedMake.h"


@interface LEEAttributedMake ()

@property (nonatomic, assign) NSRange tempRange;

@property (nonatomic, copy) NSMutableAttributedString *tempString;

@end


@implementation LEEAttributedMake

- (LEEAttributedMake *(^)(id))add {
    
    return ^LEEAttributedMake *(id sender) {
      
        if ([sender isKindOfClass:[NSString class]]) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:sender];
            self.tempRange = NSMakeRange(self.leeString.length, string.length);
            [self.leeString appendAttributedString:string];
        }
        else if ([sender isKindOfClass:[UIImage class]]) {
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = sender;
//            CGFloat lineH = label.font.lineHeight;
//            attachment.bounds = CGRectMake(0, - ((label.xmg_height - lineH) * 0.5 - 1), lineH, lineH);
            // 将附近对象包装成一个属性文字
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attachment];
            self.tempRange = NSMakeRange(self.leeString.length, string.length);
            [self.leeString appendAttributedString:string];
        }
        return self;
    };
}

- (LEEAttributedMake *(^)(NSDictionary *))style {
    
    return ^LEEAttributedMake *(NSDictionary *style) {
        
        if (style[@"font"]) {
            [self.leeString addAttribute:NSFontAttributeName value:style[@"font"] range:self.tempRange];
        }
        
        if (style[@"color"]) {
            [self.leeString addAttribute:NSForegroundColorAttributeName value:style[@"color"] range:self.tempRange];
        }
        return self;
    };
}


- (NSMutableAttributedString *)leeString {
    
    if (!_leeString) {
        _leeString = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    return _leeString;
}

@end
