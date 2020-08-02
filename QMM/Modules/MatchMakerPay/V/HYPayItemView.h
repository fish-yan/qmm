//
//  HYPayItemView.h
//  SeeYou
//
//  Created by Joseph Koh on 2018/8/9.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPayItemView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, copy) void(^tapAction)(HYPayItemView *item);

+ (instancetype)itemWithTitle:(NSString *)title price:(NSString *)price;
@end

