//
//  HYDatingShopImageCell.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/23.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYDatingShopImageCell.h"

@interface HYDatingShopImageCell ()

@end

@implementation HYDatingShopImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = 8;
    self.imageView.clipsToBounds = YES;
}

@end
