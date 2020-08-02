//
//  HYMatchMakerPayItemCell.h
//  SeeYou
//
//  Created by Joseph Koh on 2018/8/9.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "YSBaseTableViewCell.h"

@interface HYMatchMakerPayItemCell : YSBaseTableViewCell

@property (weak, nonatomic) IBOutlet UITextView *protocalView;
@property (nonatomic, copy) void(^selectedHandler)(NSInteger idx);

@property (nonatomic, strong) NSArray *dataArray;

@end
