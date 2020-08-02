//
//  QMMMemberItemView.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/23.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMMMemberItemView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

+ (instancetype)viewWithTitle:(NSString *)title subTitle:(NSString *)subTitle action:(void (^)(void))action;


@end
