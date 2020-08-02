//
//  QMMAuthViewModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMAuthViewModel : YSBaseViewModel

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIImage *frontIdPhoto;
@property (nonatomic, strong) UIImage *backIdPhoto;

@end

NS_ASSUME_NONNULL_END
