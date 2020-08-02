//
//  HYDatingInfoCell.m
//  youbaner
//
//  Created by Joseph Koh on 2018/5/4.
//  Copyright © 2018年 luzhongchang. All rights reserved.
//

#import "HYDatingInfoCell.h"

@interface HYDatingInfoCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation HYDatingInfoCell

#pragma mark - Initialize

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
        [self setupSubviews];
        [self setupSubviewsLayout];
        [self bind];
    }
    return self;
}

- (void)initialize {
    self.showBottomLine = YES;
}


#pragma mark - Bind

- (void)bind {
    RAC(self.titleLabel, text) = RACObserve(self, cellModel.title);
    RAC(self.infoLabel, text) = [RACSignal combineLatest:@[RACObserve(self, cellModel.info),
                                                           RACObserve(self, cellModel.canEdited)]
                                                  reduce:^id(NSString *info, NSNumber *canEdited){
      
                                                      [self remakeCellLayoutByInfo:info];
                                                      
                                                      if (info.length == 0 && [canEdited boolValue]) {
                                                          return @"请选择";
                                                      }
                                                      return info;
                                                  }];
    RAC(self.infoLabel, textColor) = [RACObserve(self, cellModel.infoColor) filter:^BOOL(id  _Nullable value) {
        return value != nil;
    }];
    RAC(self.arrow, hidden) = [RACObserve(self, cellModel.hasArrow) map:^id _Nullable(id  _Nullable value) {
        return @(![value boolValue]);
    }];
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _titleLabel = [UILabel labelWithText:nil
                               textColor:[UIColor colorWithHexString:@"#43484D"]
                                font:[UIFont systemFontOfSize:14]
                                  inView:self.contentView
                               tapAction:nil];
    
    _infoLabel = [UILabel labelWithText:nil
                              textColor:[UIColor colorWithHexString:@"#7D7D7D"]
                               font:[UIFont systemFontOfSize:14]
                                 inView:self.contentView
                              tapAction:NULL];
    _infoLabel.numberOfLines = 0;
    _arrow = [UIImageView imageViewWithImageName:@"cellarrow" inView:self.contentView];
}

- (void)setupSubviewsLayout {
    
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_arrow.image.size);
        make.centerY.equalTo(self.contentView);
        make.right.offset(-20);
    }];
    
    [self remakeCellLayoutByInfo:nil];
}

- (void)remakeCellLayoutByInfo:(NSString *)info {
    if (info.length == 0) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.left.offset(15);
            make.bottom.offset(-20);
        }];
        
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel);
            make.left.offset(120);
            make.right.equalTo(_arrow.mas_left).offset(-10);
        }];
    } else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.left.offset(15);
        }];
        
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel);
            make.left.offset(120);
            make.right.equalTo(_arrow.mas_left).offset(-10);
            make.bottom.offset(-20);
        }];
    }
}


@end
