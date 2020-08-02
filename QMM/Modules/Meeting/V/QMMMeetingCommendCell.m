//
//  QMMMeetingCommendCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMMeetingCommendCell.h"
#import "QMMMeetingCommendCell.h"
#import "QMMInfoListCell.h"
#import "QMMBottomActionVM.h"
#import "QMMCommendItemCell.h"

@interface QMMMeetingCommendCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *topBtn;    // 置顶
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

@implementation QMMMeetingCommendCell

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.showBottomLine = YES;
}


#pragma mark - Bind

- (void)bind {
    RAC(self.titleLabel, text) = RACObserve(self, title);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMMCommendItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kReuseId" forIndexPath:indexPath];
    QMMMemberInfoModel *m = self.dataArray[indexPath.item];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:m.avatar]
                     placeholderImage:[UIImage imageNamed:AVATAR_PLACEHOLDER]];
    cell.infoLabel.text = [NSString stringWithFormat:@"%@/%@岁", m.workcity ?: @"-", m.age ?: @"-"];
    cell.hadHeart = m.beckoningstatus;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QMMMemberInfoModel *m = self.dataArray[indexPath.item];
    if (self.itemClickedAction) {
        self.itemClickedAction(m);
    }
}

#pragma mark - Setup UI

- (void)setupSubviews {
    _titleLabel = [UILabel labelWithText:nil
                               textColor:[UIColor colorWithHexString:@"#3A444A"]
                                font:[UIFont systemFontOfSize:18]
                                  inView:self.contentView
                               tapAction:NULL];
    
    @weakify(self);
    _topBtn = [UIButton buttonWithTitle:@"我要置顶"
                             titleColor:[UIColor colorWithHexString:@"#43484D"]
                                   font:[UIFont systemFontOfSize:14]
                                bgColor:nil
                                 inView:self.contentView
                                 action:^(UIButton *btn) {
                                     @strongify(self);
                                     if (self.topAction) {
                                         self.topAction();
                                     }
                                 }];
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:self.layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = YES;
    [_collectionView registerClass:[QMMCommendItemCell class] forCellWithReuseIdentifier:@"kReuseId"];
    [self.contentView addSubview:_collectionView];
}

- (void)setupSubviewsLayout {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(20);
    }];
    
    [_topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.bottom.right.offset(0);
        make.left.offset(20);
    }];
}


#pragma mark - Lazy Loading

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.itemSize = CGSizeMake(70, 135);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 20;
        _layout.minimumInteritemSpacing = 0;
    }
    return _layout;
}

@end
