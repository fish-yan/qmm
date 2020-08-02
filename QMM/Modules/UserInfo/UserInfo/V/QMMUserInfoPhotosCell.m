//
//  QMMUserInfoPhotosCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMUserInfoPhotosCell.h"
#import "UIButton+WebCache.h"

#define ITEM_WH ([UIScreen mainScreen].bounds.size.width - 2.0) / 3.0

@interface QMMUserInfoPhotosCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *imgsArrM;
@property (nonatomic, strong) UIButton *addBtn;


@end

@implementation QMMUserInfoPhotosCell

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
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [RACObserve(self, cellModel.value) subscribeNext:^(NSArray * _Nullable x) {
        @strongify(self);
        if (!x || x.count == 0) return;
        
        NSInteger totalCol = 3;
        NSInteger maxRow = 2;
        CGFloat margin = 1;
        CGFloat wh = ITEM_WH;
        __block CGFloat offsetX = 0;
        __block CGFloat offsetY = 0;
        __block NSInteger row = 0;
        __block NSInteger col = 0;
        
        __block NSMutableArray *imgsM = [NSMutableArray arrayWithCapacity:x.count];
        [x enumerateObjectsUsingBlock:^(PhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imgsM addObject:obj.url];
        }];
        
        
        self.addBtn.hidden = !self.isMySelf;
        
        [x enumerateObjectsUsingBlock:^(PhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            if (idx > totalCol * maxRow - 1) {
                self.addBtn.hidden = YES;
                *stop = YES;
                return;
            }
            
            UIButton *btn = [self cachedImgBtnAtIndex:idx];
            btn.hidden = NO;
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:obj.url]
                                     forState:UIControlStateNormal
                             placeholderImage:[UIImage imageNamed:@"img_placeholder_a"]];
            [[btn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                if (self.imageBtnClickHandler) {
                    self.imageBtnClickHandler(imgsM, idx);
                }
            }];
            
            row = idx / 3;
            col = idx % 3;
            offsetX = (wh + margin) * col;
            offsetY = 15 + (wh + 1) * row;
            [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(offsetX);
                make.width.height.mas_equalTo(wh);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(offsetY);
            }];
            
            if (idx == totalCol * maxRow  - 1) {
                [btn setTitle:@"查看更多" forState:UIControlStateNormal];
            }
        }];
        
        if (self.imgsArrM.count > x.count) {
            for (NSInteger i = x.count - 1; i < self.imgsArrM.count; i++) {
                UIButton *btn =self.imgsArrM[i];
                btn.hidden = YES;
            }
        }
        
        // 布局添加按钮
        if (self.addBtn.hidden == NO) {
            row = x.count / 3;
            col = x.count % 3;
            offsetX = (wh + margin) * col;
            offsetY = 15 + (wh + 1) * row;
            [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(offsetX);
                make.width.height.mas_equalTo(wh);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(offsetY);
            }];
        }
    }];
}

- (UIButton *)cachedImgBtnAtIndex:(NSInteger)idx {
    if (self.imgsArrM.count == 0 || self.imgsArrM.count <= idx) {
        return [self createImgBtn];
    }
    else {
        return self.imgsArrM[idx];
    }
}

- (UIButton *)createImgBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"img_placeholder_a"] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgsArrM addObject:btn];
    return btn;
}


#pragma mark - Setup UI

- (void)setupSubviews {
    _titleLabel = [UILabel labelWithText:@"照片"
                               textColor:[UIColor colorWithHexString:@"#313131"]
                                font:[UIFont systemFontOfSize:15]
                                  inView:self.contentView
                               tapAction:NULL];
    @weakify(self);
    _addBtn = [UIButton buttonWithNormalImgName:@"ic_photo_add"
                                        bgColor:nil
                                         inView:self.contentView
                                         action:^(UIButton *btn) {
                                             @strongify(self);
                                             if (self.addBtnClickHandler) {
                                                 self.addBtnClickHandler();
                                             }
                                         }];
    self.imgsArrM = [NSMutableArray array];
}


- (void)setupSubviewsLayout {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
    }];
    
    CGFloat wh = (SCREEN_WIDTH - 2) / 3;
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.height.mas_equalTo(wh);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
}


@end
