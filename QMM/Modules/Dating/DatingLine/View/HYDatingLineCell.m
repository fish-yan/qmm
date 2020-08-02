//
//  HYDatingLineCell.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/26.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYDatingLineCell.h"

@interface HYDatingLineCell ()
@property (weak, nonatomic) IBOutlet UIButton *roundTag;

@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation HYDatingLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self bind];
}

#pragma mark - Bind

- (void)bind {
    RAC(self.topLine, hidden) = RACObserve(self, isFirstItem);
    RAC(self.bottomLine, hidden) = RACObserve(self, isLastItem);
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(HYDatingRouteItem * _Nullable x) {
        @strongify(self);
        if ([x.type integerValue] == 1) {   // 发起方
            self.myTitleLabel.text = x.content;
            self.myTimeLabel.text = x.date;
            
            self.myTitleLabel.hidden = NO;
            self.myTimeLabel.hidden = NO;
            self.otherTitleLabel.hidden = YES;
            self.otherTimeLabel.hidden = YES;
            
        }
        else if ([x.type integerValue] == 2) {   // 接受方
            self.otherTitleLabel.text = x.content;
            self.otherTimeLabel.text = x.date;
            
            self.myTitleLabel.hidden = YES;
            self.myTimeLabel.hidden = YES;
            self.otherTitleLabel.hidden = NO;
            self.otherTimeLabel.hidden = NO;
        }
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
