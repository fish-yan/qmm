//
//  UITableView+Create.m
//  MyProject
//
//  Created by Joseph Koh on 2017/5/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "UITableView+Create.h"

@implementation UITableView (Create)

+ (instancetype)tableViewOfStyle:(UITableViewStyle)style
                          inView:(__kindof UIView *)inView
                  withDatasource:(id <UITableViewDataSource>)dataSource
                        delegate:(id <UITableViewDelegate>)delegate {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];

    tableView.separatorInset = UIEdgeInsetsZero;
    
    if (dataSource && [dataSource conformsToProtocol:@protocol(UITableViewDataSource)]) {
        tableView.dataSource = dataSource;
    }
    if (delegate && [delegate conformsToProtocol:@protocol(UITableViewDelegate)]) {
        tableView.delegate = delegate;
    }
    if (inView && [inView isKindOfClass:[UIView class]]) {
        [inView addSubview:tableView];
    }
    return tableView;
}

@end
