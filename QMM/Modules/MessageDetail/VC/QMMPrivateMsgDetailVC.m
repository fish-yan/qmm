//
//  QMMPrivateMsgDetailVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMPrivateMsgDetailVC.h"
#import "QMMPrivateMsgListModel.h"
#import "QMMPrivateMsgDetailListVM.h"
#import "QMMPrivateMsgDetailCell.h"
#import "QMMPrivateMsgModel.h"
#import "QMMMsgTextView.h"
#import "QMMPrivateMsgDateCell.h"
#define PrivateMessageDetialCell_ID @"PrivateMessageDetialCell"
#define HYYueHuiTableViewCell_ID @"HYYueHuiTableViewCell_ID"

#define HEIGHT_CHATBOXVIEW 215
#define HEIGHT_TABBAR 49

@interface QMMPrivateMsgDetailVC () <ChatBoxDelegate>

@property (nonatomic, strong) NSString *cantactName;
@property (nonatomic, strong) NSString *cantactID;
@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) QMMPrivateMsgDetailListVM *viewModel;
@property (nonatomic, strong) QMMMsgTextView *chatBox;
@property (nonatomic, assign) float curheight;
@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, assign) BOOL sending;

@end

@implementation QMMPrivateMsgDetailVC

+ (void)load {
    [self mapName:kMessageDetail withParams:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.cantactName;

    self.canBack = YES;
    self.sending = NO;

    self.viewModel = [QMMPrivateMsgDetailListVM new];
    [self bindModel];
    
    self.viewModel.uid = self.cantactID;
    
    [YSProgressHUD showInView:self.view];
    [self.viewModel.doCommond execute:@"1"];
}


- (void)setupSubviews {
    [super setupSubviews];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor              = [UIColor clearColor];
    [self.tableView registerClass:[QMMPrivateMsgDetailCell class] forCellReuseIdentifier:PrivateMessageDetialCell_ID];
    [self.tableView registerClass:[QMMPrivateMsgDateCell class] forCellReuseIdentifier:HYYueHuiTableViewCell_ID];


    
    [self.view addSubview:self.chatBox];
    
    [self.chatBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TABBAR);
    }];
    
    @weakify(self);
    self.tableView.mj_header = [YSRefresher headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.lastdate = nil;
        [self.viewModel.doCommond execute:@"1"];
    }];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 32)];
    [button setTitle:@"⊘" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor tc3Color] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(stopOpration) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 32)];
    [button1 setTitle:@"约会" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:16];
    [button1 setTitleColor:[UIColor tc3Color] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(yuehui) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *rightberitem  = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *rightberitem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    //    UIBarButtonItem * rightberitem =[[UIBarButtonItem alloc] initWithTitle:@"⊘" style:UIBarButtonItemStyleBordered
    //    target:self action:@selector(stopOpration)];
    self.navigationItem.rightBarButtonItems = @[rightberitem1, rightberitem];
    
}

- (void)setupSubviewsLayout {
    [super setupSubviewsLayout];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
}

- (void)yuehui {
    [YSProgressHUD showTips:@"敬请期待"];
//    NSDictionary *params =
//    @{ @"uid": self.cantactID ?: @"",
//       @"avatar": self.avatar,
//       @"name": @"",
//       @"appointmentstatus": @0 };
//
//    [YSMediator pushToViewController:kModuleDatingInfo withParams:params animated:YES callBack:NULL];
}

- (void)stopOpration {
    id cancelBlock = ^() {

    };
    id sureBlock = ^() {
        if (self.cantactID.length == 0) return;

        [YSProgressHUD showInView:nil];
        [self.viewModel.pBUserCommand execute:@{ @"uid": self.cantactID }];
    };


    [YSMediator presentToViewController:@"AlertViewController"
                             withParams:@{
                                 @"message": @"确定屏蔽此人？",
                                 @"type": @2,
                                 @"rightButtonTitle": @"是",
                                 @"leftButtonTitle": @"否",
                                 @"rightTitleColor": [UIColor tc2Color],
                                 @"cancelBlock": cancelBlock,
                                 @"sureBlock": sureBlock
                             }
                               animated:YES
                               callBack:nil];
}


#pragma mark-- tableview delegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.listArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((QMMPrivateMsgListModel *) [self.viewModel.listArray objectAtIndex:section]).array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMMPrivateMsgModel *model =
    [((QMMPrivateMsgListModel *) [self.viewModel.listArray objectAtIndex:indexPath.section]).array objectAtIndex:indexPath.row];


    if ([model.type intValue] == 10) {
        QMMPrivateMsgDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:PrivateMessageDetialCell_ID];
        cell.Model                     = model;

        return cell;
    } else {
        QMMPrivateMsgDateCell *cell = [tableView dequeueReusableCellWithIdentifier:HYYueHuiTableViewCell_ID];
        cell.model                  = model;
        if (model == nil) {
            cell.hidden = YES;
        } else {
            cell.hidden = NO;
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMMPrivateMsgModel *model =
    [((QMMPrivateMsgListModel *) [self.viewModel.listArray objectAtIndex:indexPath.section]).array objectAtIndex:indexPath.row];
    if ([model.type intValue] == 10) {
        return [QMMPrivateMsgDetailCell
        getheight:[((QMMPrivateMsgListModel *) [self.viewModel.listArray objectAtIndex:indexPath.section]).array
                  objectAtIndex:indexPath.row]];
    }
    else {
        return [tableView fd_heightForCellWithIdentifier:HYYueHuiTableViewCell_ID
                                           configuration:^(QMMPrivateMsgDateCell *cell) {
                                               cell.model = model;
                                           }];
    }
    return 0.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 42;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QMMPrivateMsgListModel *m = [self.viewModel.listArray objectAtIndex:section];

    UIView *v  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    UILabel *l = [UILabel labelWithText:m.time
                              textColor:[UIColor tc4Color]
                                   font:[UIFont systemFontOfSize:12]
                                 inView:v
                              tapAction:nil];
    l.textAlignment = NSTextAlignmentCenter;
    l.frame         = CGRectMake(0, 20, SCREEN_WIDTH, 12);
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QMMPrivateMsgModel *model =
    [((QMMPrivateMsgListModel *) [self.viewModel.listArray objectAtIndex:indexPath.section]).array objectAtIndex:indexPath.row];
    if ([model.type intValue] == 20) {
        NSDictionary *params = @{
            @"dateID": model.appointmentid ?: @"",
            @"appointmentstatus": @1,
            @"uid": model.uid ?: @"",
            @"avatar": model.useravatar ?: @"",
            @"name": model.name ?: @""
        };

        [YSProgressHUD showTips:@"敬请期待"];
//        [YSMediator pushToViewController:kModuleDatingInfo withParams:params animated:YES callBack:NULL];
    }
}

#pragma mark - Getter
- (QMMMsgTextView *)chatBox {
    if (_chatBox == nil) {
        _chatBox = [[QMMMsgTextView alloc] initWithFrame:CGRectZero];
        [_chatBox setDelegate:self];
    }
    return _chatBox;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resignFirstResponder];
}
#pragma mark -chatBoxDelegate
- (void)chatBox:(QMMMsgTextView *)chatBox sendTextMessage:(NSString *)textMessage {
    if (chatBox.textView.text.length <= 0) {
        [YSProgressHUD showTips:@"消息内容不可以为空"];
        return;
    }

    if (textMessage.length > 1000) {
        [YSProgressHUD showTips:@"私信不能超过1000字"];
        return;
    }

    self.viewModel.content = textMessage;


    if (self.sending) {
        [YSProgressHUD showTips:@"发送中"];
        return;
    }
    self.sending = YES;

    [self.viewModel.doSendMessageCommond execute:@"1"];
}
- (void)chatBox:(QMMMsgTextView *)chatBox changeChatBoxHeight:(CGFloat)height {
    self.curheight = height;
    [self.chatBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.frame.size.height - self.keyboardFrame.size.height -
                             (height > HEIGHT_TABBAR ? height : HEIGHT_TABBAR));
        make.height.mas_equalTo(height > HEIGHT_TABBAR ? height : HEIGHT_TABBAR);
    }];


    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.chatBox.mas_top);
    }];


    [self scrollBottom];
}
- (void)chatBox:(QMMMsgTextView *)chatBox changeStatusForm:(ChatBoxStatus)fromStatus to:(ChatBoxStatus)toStatus {
}

#pragma mark - Private Methods

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardFrame = CGRectZero;
    [self.chatBox mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.curheight > HEIGHT_TABBAR ? self.curheight : HEIGHT_TABBAR);
    }];
}
- (void)keyboardDidHide:(NSNotification *)notification {
    @weakify(self);
    [self.chatBox mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(self.curheight > HEIGHT_TABBAR ? self.curheight : HEIGHT_TABBAR);
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.chatBox.mas_top);
    }];

    [self scrollBottom];
}


- (void)keyboardDidShow:(NSNotification *)notification {
    @weakify(self);
    [self.chatBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.mas_offset(self.view.frame.size.height - self.keyboardFrame.size.height -
                            (HEIGHT_TABBAR < self.curheight ? self.curheight : HEIGHT_TABBAR));
        make.height.mas_equalTo(HEIGHT_TABBAR < self.curheight ? self.curheight : HEIGHT_TABBAR);
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.chatBox.mas_top);

    }];


    [self scrollBottom];
}

- (void)keyboardWillChange:(NSNotification *)notification {
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    @weakify(self);

    [self.chatBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.frame.size.height - self.keyboardFrame.size.height -
                             (self.curheight > HEIGHT_TABBAR ? self.curheight : HEIGHT_TABBAR));
        make.height.mas_equalTo(self.curheight > HEIGHT_TABBAR ? self.curheight : HEIGHT_TABBAR);
    }];


    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.chatBox.mas_top);
    }];


    // [self scrollBottom];
}
- (void)scrollBottom {
    if (self.viewModel.listArray.count > 0) {
        QMMPrivateMsgListModel *m = [self.viewModel.listArray objectAtIndex:self.viewModel.listArray.count - 1];

        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:m.array.count - 1
                                                                   inSection:self.viewModel.listArray.count - 1]
                               atScrollPosition:UITableViewScrollPositionBottom
                                       animated:YES];
    }
}

- (void)bindModel {
    @weakify(self);

    [[self.viewModel.doCommond.executionSignals switchToLatest] subscribeNext:^(id _Nullable x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.view hiddenFailureView];
        [YSProgressHUD hiddenHUD];
        [self.tableView reloadData];
        [self scrollBottom];
    }];

    [self.viewModel.doCommond.errors subscribeNext:^(NSError *_Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
        [self.tableView.mj_header endRefreshing];
        [YSProgressHUD hiddenHUD];
        [self.view hiddenFailureView];
        @strongify(self);

        [self.view showFailureViewOfType:WDFailureViewTypeError
                         withClickAction:^{
                             [YSProgressHUD showInView:self.view];
                             [self.viewModel.doCommond execute:@"1"];
                         }];


    }];

    [[self.viewModel.doSendMessageCommond.executionSignals switchToLatest] subscribeNext:^(YSResponseModel *_Nullable x) {
        @strongify(self);
        self.chatBox.plachorLabel.hidden = NO;
        [self.chatBox.button setTitleColor:[UIColor tc3Color] forState:UIControlStateNormal];
        [self.tableView reloadData];
        [self scrollBottom];

        self.chatBox.curHeight     = 35;
        self.curheight             = 35;
        self.chatBox.textView.text = @"";
        [self.chatBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
            make.height.mas_equalTo(HEIGHT_TABBAR);
        }];
        [self.chatBox.textView resignFirstResponder];
        self.sending = NO;
        [self.viewModel.doCommond execute:@"1"];


    }];

    [self.viewModel.doSendMessageCommond.errors subscribeNext:^(NSError *_Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];

    [[self.viewModel.pBUserCommand.executionSignals switchToLatest] subscribeNext:^(YSResponseModel *_Nullable x) {
        [YSProgressHUD showTips:x.msg];
    }];

    [self.viewModel.pBUserCommand.errors subscribeNext:^(NSError *_Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
}
@end
