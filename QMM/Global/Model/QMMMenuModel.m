//
//  QMMMenuModel.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMMenuModel.h"

@implementation QMMMenuModel

+ (instancetype)modelWithTitle:(NSString *)title contentVC:(UIViewController *)contentVC andID:(NSString *)mId {
    QMMMenuModel *menu = [[QMMMenuModel alloc] init];
    menu.menuId = mId;
    menu.contentVC = contentVC;
    menu.title = title;
    return menu;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p title: %@ menuId: %@>", [self class], self, _title, _menuId];
}


@end
