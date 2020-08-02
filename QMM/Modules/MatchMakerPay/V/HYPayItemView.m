//
//  HYPayItemView.m
//  SeeYou
//
//  Created by Joseph Koh on 2018/8/9.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYPayItemView.h"

@implementation HYPayItemView

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    if (self.tapAction) {
        self.tapAction(self);
    }
}

+ (instancetype)itemWithTitle:(NSString *)title price:(NSString *)price {
    HYPayItemView *v = [[NSBundle mainBundle] loadNibNamed:@"HYPayItemView" owner:nil options:nil].firstObject;
    v.titleLabel.text = title;
    v.priceLabel.text = price;
    
    v.backgroundColor = [UIColor whiteColor];
    v.layer.cornerRadius = 4;
    v.layer.borderWidth = 1;
    v.selected = NO;
    
    return v;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    UIColor *color = [UIColor colorWithHexString:@"#DDDFE2"];
    if (selected) {
        color = [UIColor colorWithHexString:@"#FF5D9C"];
    }
    self.layer.borderColor = color.CGColor;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    
    return self;
}
@end
