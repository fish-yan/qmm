//
//  QMMSupplementarySelectVC.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMSupplementaryBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SelectType) {
    SelectTypeBirthday = 0,
    SelectTypeLocation,
    SelectTypeIncome,
};


@interface QMMSupplementarySelectVC : QMMSupplementaryBaseVC

@property (nonatomic, assign) SelectType selectType;

@end

NS_ASSUME_NONNULL_END
