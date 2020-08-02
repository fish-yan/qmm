//
//  YSBaseTableViewCell.m
//
//  Created by luzhongchang on 17/5/16.
//  Copyright © 2017年 Jam. All rights reserved.
//

#import "YSBaseTableViewCell.h"

@interface YSBaseTableViewCell ()

@end

@implementation YSBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupSeperatorLine];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)] ||
            [self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        [self setupSeperatorLine];
    }
    return self;
}

- (void)setupSeperatorLine {
    self.topLine = [self addLineWithType:YSBaseCellLineTypeTop];
    self.bottomLine = [self addLineWithType:YSBaseCellLineTypeBottom];
}

typedef NS_ENUM(NSInteger, YSBaseCellLineType) {
    YSBaseCellLineTypeTop,
    YSBaseCellLineTypeBottom,
};

- (UIView *)addLineWithType:(YSBaseCellLineType)type {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
    v.hidden = YES;
    [self.contentView addSubview:v];
    
    v.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1.0
                                                                  constant:0.5]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:v
//                                                                 attribute:NSLayoutAttributeLeft
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeLeft
//                                                                multiplier:1.0
//                                                                  constant:0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:v
//                                                                 attribute:NSLayoutAttributeRight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeRight
//                                                                multiplier:1.0
//                                                                  constant:0]];
    switch (type) {
        case YSBaseCellLineTypeTop: {
            self.topLineLeftConstraint = [NSLayoutConstraint constraintWithItem:v
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
            [self.contentView addConstraint:self.topLineLeftConstraint];
            
            self.topLineRightConstraint = [NSLayoutConstraint constraintWithItem:v
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.contentView
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
            [self.contentView addConstraint:self.topLineRightConstraint];
            
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:0]];
        }
            break;
        case YSBaseCellLineTypeBottom: {
            self.bottomLineLeftConstraint = [NSLayoutConstraint constraintWithItem:v
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
            [self.contentView addConstraint:self.bottomLineLeftConstraint];
            
            self.bottomLineRightConstraint = [NSLayoutConstraint constraintWithItem:v
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.contentView
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
            [self.contentView addConstraint:self.bottomLineRightConstraint];
            
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:0]];
            break;
        }
        default:
            break;
    }
    
    return v;
}

- (void)setShowTopLine:(BOOL)showTopLine {
    _showTopLine = showTopLine;
    self.topLine.hidden = !showTopLine;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
    self.bottomLine.hidden = !showBottomLine;
}

@end
