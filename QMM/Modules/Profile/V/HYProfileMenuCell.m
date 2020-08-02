//
//  HYProfileMenuCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYProfileMenuCell.h"

@interface HYProfileMenuItem: UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HYProfileMenuItem

-  (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubvews];
    }
    
    return self;
}

- (void)setupSubvews {
    _imgV = [UIImageView imageViewWithImageName:nil inView:self.contentView];
    _titleLabel = [UILabel labelWithText:nil
                               textColor:[UIColor colorWithHexString:@"#313131"]
                                font:[UIFont systemFontOfSize:13]
                                  inView:self.contentView
                               tapAction:NULL];
    
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerX.equalTo(self.contentView);
        make.top.offset(30);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.imgV.mas_bottom).offset(10);
    }];
    
}

@end


@interface HYProfileMenuCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HYProfileMenuCell

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
    
}


#pragma mark - Bind

- (void)bind {
    RAC(self.titleLabel, text) = RACObserve(self, cellModel.title);
    RAC(self.infoLabel, text) = RACObserve(self, cellModel.desc);
}


#pragma mark - UICollection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.cellModel.value count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.cellModel.value;
    HYProfileCellModel *model = arr[indexPath.item];
    HYProfileMenuItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseID"
                                                                        forIndexPath:indexPath];
    cell.imgV.image = [UIImage imageNamed:model.desc];
    cell.titleLabel.text = model.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.cellModel.value;
    HYProfileCellModel *model = arr[indexPath.item];
    if (self.menuItemClick) {
        self.menuItemClick(indexPath.item, model.mapStr);
    }
}

#pragma mark - Setup UI

- (void)setupSubviews {
    self.titleLabel = [UILabel labelWithText:self.cellModel.title
                                   textColor:[UIColor colorWithHexString:@"#313131"]
                                    font:[UIFont systemFontOfSize:16]
                                      inView:self.contentView
                                   tapAction:NULL];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    
    _arrow = [UIImageView imageViewWithImageName:@"arrowright" inView:self.contentView];
    
    _infoLabel = [UILabel labelWithText:self.cellModel.desc
                              textColor:[UIColor colorWithHexString:@"#7D7D7D"]
                               font:[UIFont systemFontOfSize:14]
                                 inView:self.contentView
                              tapAction:^(UILabel *label, UIGestureRecognizer *tap) {
                                  NSArray *arr = self.cellModel.value;
                                  HYProfileCellModel *model = arr[0];
                                  if (self.menuItemClick) {
                                      self.menuItemClick(0, model.mapStr);
                                  }
                              }];
    
    
    //
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 4.0, 188.0 / 2.0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[HYProfileMenuItem class] forCellWithReuseIdentifier:@"reuseID"];
    [self.contentView addSubview:_collectionView];
}

- (void)setupSubviewsLayout {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(17);
    }];
    
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrow.image.size);
        make.centerY.equalTo(self.titleLabel);
        make.right.offset(-15);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.arrow.mas_left).offset(-5);
    }];
    
    //
    UIView *line = [UIView viewWithBackgroundColor:[UIColor colorWithHexString:@"#E7E7E7"] inView:self.contentView];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(17);
        make.height.mas_equalTo(1);
    }];
    
    //
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.mas_equalTo(188);
    }];
}
@end
