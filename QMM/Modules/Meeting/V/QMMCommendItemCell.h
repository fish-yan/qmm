//
//  QMMCommendItemCell.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMCommendItemCell : YSBaseCollectionViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *tagView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, assign) BOOL hadHeart;

@end

NS_ASSUME_NONNULL_END
