//
//  UITableView+Create.h
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Create)

+ (instancetype)tableViewOfStyle:(UITableViewStyle)style
                          inView:(__kindof UIView *)inView
                  withDatasource:(id <UITableViewDataSource>)dataSource
                        delegate:(id <UITableViewDelegate>)delegate;

@end
