//
//  QMMPrivateMsgListModel.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseModel.h"


@interface QMMPrivateMsgListModel : YSBaseModel

@property(nonatomic ,strong) NSString *time;
@property(nonatomic ,strong) NSArray *array;

@end

