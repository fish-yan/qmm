//
//  YSBaseTableViewController.h
//  YSBaseComponent
//
//  Created by Joseph Koh on 2018/5/23.
//

#import "YSBaseViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UITableView+FDTemplateLayoutCell.h"
#import <YSToolsKit/YSToolsKit.h>
//#import <ProjectConfig/ProjectConfig.h>
#import <YSMediator/YSMediator.h>

@interface YSBaseTableViewController : YSBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UITableViewStyle style;

- (void)initialize;
- (void)setupSubviews;
- (void)setupSubviewsLayout;
- (void)bind;


@end
