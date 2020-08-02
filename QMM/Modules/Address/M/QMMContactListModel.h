//
//  QMMContactListModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"
#import "QMMContactModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMMContactListModel : YSBaseModel

@property (nonatomic, strong) QMMContactModel *leftModel;
@property (nonatomic, strong) QMMContactModel *rightModel;

@end

NS_ASSUME_NONNULL_END
