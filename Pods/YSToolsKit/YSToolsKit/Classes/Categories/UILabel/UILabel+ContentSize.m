//
//  UILabel+ContentSize.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "UILabel+ContentSize.h"

@implementation UILabel (ContentSize)


- (CGSize)contentSize {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = self.lineBreakMode;
        paragraphStyle.alignment = self.textAlignment;
    
        NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                      NSParagraphStyleAttributeName : paragraphStyle};
    
        CGSize contentSize = [self.text boundingRectWithSize:self.frame.size
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:attributes
                                                     context:nil].size;
        return CGSizeMake(ceil(contentSize.width), ceil(contentSize.height));
}


@end
