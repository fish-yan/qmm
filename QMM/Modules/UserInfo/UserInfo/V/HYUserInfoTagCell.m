//
//  HYUserInfoTagCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYUserInfoTagCell.h"

@interface HYUserInfoTagCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *tagsArray;
@property (nonatomic, assign) NSInteger validityTagCount;

@end

@implementation HYUserInfoTagCell


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
    self.showBottomLine = NO;
    self.tagsArray = [NSMutableArray array];
}


#pragma mark - Bind

- (void)bind {
    RAC(self.titleLabel, text) = RACObserve(self, cellModel.title);
    
    @weakify(self);
    [RACObserve(self, cellModel.value) subscribeNext:^(NSArray * _Nullable values) {
        @strongify(self);
        self.validityTagCount = 0;
        
        if (!values || values.count == 0) {
            return;
        }
        
        __block CGFloat x = 15;
        __block CGFloat y = 50;
        __block CGFloat preTotal = 0;
        CGFloat h = 26;
        CGFloat padding = 10;
        CGFloat margin = 15;
        [values enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            if([obj isKindOfClass:[NSNull class]]
               || [obj stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
                return;
            }
            
            CGFloat tagW = [obj widthWithFontSize:15] + margin * 2;
            if (idx == 0) {
                
            }
            else if ((preTotal + padding + tagW) > (SCREEN_WIDTH - padding * 2)) {
                x = margin;
                y += (h + padding);
            } else {
                x = preTotal + padding;
            }
            preTotal = x + tagW;
            
            UILabel *l = [self cacheLabelAtIndex:idx];
            l.text = obj;
            l.hidden = NO;
            l.frame = CGRectMake(x, y, tagW, h);
            
            self.validityTagCount++;
        }];
        
    }];
}

- (UILabel *)cacheLabelAtIndex:(NSInteger)idx {
    if (self.tagsArray.count == 0 || (self.tagsArray.count != 0 && self.tagsArray.count <= idx)) {
        UILabel *l = [[UILabel alloc] init];
        l.font = [UIFont systemFontOfSize:15];
        l.textColor = [UIColor colorWithHexString:@"#7D7D7D"];
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        l.layer.cornerRadius = 4;
        l.clipsToBounds = YES;
        [self.contentView addSubview:l];
        [self.tagsArray addObject:l];
        return l;
    }
    
    return self.tagsArray[idx];
}

#pragma mark - Setup UI

- (void)setupSubviews {
    _titleLabel = [UILabel labelWithText:nil
                               textColor:[UIColor colorWithHexString:@"#313131"]
                                font:[UIFont systemFontOfSize:14]
                                  inView:self.contentView
                               tapAction:NULL];
    
}

- (void)setupSubviewsLayout {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(20);
    }];
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat h = 50;
    if (self.validityTagCount != 0) {
        UILabel *label = self.tagsArray[self.validityTagCount - 1];
        h = CGRectGetMaxY(label.frame) + 20;
    }
    return CGSizeMake(size.width, h);
}

@end
