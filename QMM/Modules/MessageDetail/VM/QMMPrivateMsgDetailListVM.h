//
//  QMMPrivateMsgDetailListVM.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSBaseViewModel.h"

@interface QMMPrivateMsgDetailListVM : YSBaseViewModel

@property(nonatomic ,strong) RACCommand *doCommond;
@property(nonatomic ,strong) NSString * uid;
@property(nonatomic ,strong) NSArray *listArray;
@property(nonatomic,copy) NSString * lastdate;
@property(nonatomic ,strong) NSString *content;
@property(nonatomic ,strong) RACCommand *doSendMessageCommond;
@property(nonatomic ,strong) RACCommand *pBUserCommand;


@end

