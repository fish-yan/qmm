//
//  NSString+Size.m
//  YSKit
//
//  Created by Joseph Koh on 16/4/21.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithFontSize:(CGFloat)fontSize {
    if (!fontSize) {
        fontSize = [UIFont systemFontSize];
    }
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:NSStringDrawingTruncatesLastVisibleLine
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                     context:nil].size;
    
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

- (CGFloat)widthWithFontSize:(CGFloat)fontSize {
    return [self sizeWithFontSize:fontSize].width;
}

- (CGFloat)heightWithFontSize:(CGFloat)fontSize {
    return [self sizeWithFontSize:fontSize].height;
}


+ (CGSize)getStringSize:(NSString*)input font:(UIFont*)font width:(CGFloat)width{
    if (input == nil || font == nil || width <= 0) {
        return CGSizeMake(0., 0.);
    }
    
    CGSize size;
    size  = [input boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

+ (CGFloat)getStringHight:(NSString*)input font:(UIFont*)font width:(CGFloat)width {
    if (input == nil || font == nil || width <= 0) {
        return 0.0f;
    }
    
    CGSize size ;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3.0;
    size  = [input boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil].size;
    
    return size.height;
}

+ (CGFloat)getStringWidth:(NSString *)input font:(UIFont*)font height:(CGFloat)height {
    if (input == nil || font == nil || height <= 0) {
        return 0.0f;
    }
    
    CGSize size ;
    size  = [input boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return size.width;
}


//inline NSString *strOrEmpty(id str){
//    if ([str isKindOfClass:[NSDictionary class]]
//        || [str isKindOfClass:[NSNull class]]
//        || [str isKindOfClass:[NSNull class]]
//        || [str isEqual:[NSNull null]]
//        || [str isEqualToString:@"(null)"]){
//        return @"";
//    }
//    else if ([str isKindOfClass:[NSNumber class]]) {
//        return  [NSString stringWithFormat:@"%@", str];
//    }
//
//    return (str == nil ? @"" : str);
//}

@end
