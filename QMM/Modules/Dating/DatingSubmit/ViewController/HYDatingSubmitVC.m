//
//  HYDatingSubmitVC.m
//  SeeYou
//
//  Created by Joseph Koh on 2018/7/11.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYDatingSubmitVC.h"
#import "HYDatingMarginHelper.h"
#import "HYDatingSubmitVM.h"


@interface HYDatingSubmitVC ()

@property (nonatomic, strong) HYDatingSubmitVM *viewModel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UITextView *tipsTextView;
@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UIView *actionContentView;

@property (nonatomic, strong) HYDatingMarginHelper *marginHelper;
@property (nonatomic, strong) HYOrderPayModel *payModel;

@end

@implementation HYDatingSubmitVC

+(void)load {
    [self mapName:@"kModuleDatingSubmit" withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self bind];

    [YSProgressHUD showInView:self.view];
    [self requestData];
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [[self.viewModel.requestCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        [YSProgressHUD hiddenHUD];
        [self.view layoutIfNeeded];
    }];
    
    [[self.viewModel.requestCmd errors] subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [YSProgressHUD showTips:x.localizedDescription];
        [self.view showFailureViewOfType:WDFailureViewTypeError withClickAction:^{
            @strongify(self);
            [self requestData];
        }];
    }];
    
    RAC(self.tipsTextView, attributedText) = [RACObserve(self.viewModel, ruleHtmlString)
                                              map:^id _Nullable(NSString * _Nullable value) {
                                                   NSAttributedString *attrStr = [[NSAttributedString alloc]
                                                               initWithData:[value dataUsingEncoding:NSUnicodeStringEncoding]
                                                               options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                               documentAttributes:nil
                                                               error:nil];
                                                  return attrStr;
                                                }];
}


#pragma mark - Action

- (void)requestData {
    [self.viewModel.requestCmd execute:nil];
    [self getPrice];
}

- (void)doPaySuccessAction:(BOOL)isBalancePayType {
    NSString *msg = isBalancePayType ? @"已通过余额支付成功" : @"支付成功";
    [YSProgressHUD showTips:msg];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self popBack];
    });
}

//获取价格
-(void)getPrice {
    [YSProgressHUD showInView:self.view];
    
    @weakify(self);
    self.marginHelper = [HYDatingMarginHelper handMarginOfDating:self.dateId result:^(NSError *error, HYOrderPayModel *payModel) {
        [YSProgressHUD hiddenHUD];
        @strongify(self);
        if (error) {
            [YSProgressHUD showTips:error.localizedDescription];
            return;
        }
        self.payModel = payModel;
        self.countLabel.attributedText = [self countAttributeString];
    }];
    
    [self.marginHelper.payCmd execute:nil];
}

//支付保证金
-(void)doPayMoneyAction {

        if (self.payModel.status == 1) {
            [self doPaySuccessAction:YES];
        } else {
            // 跳支付页面
            /*
             @property (nonatomic, copy) NSString *orderId;
             @property (nonatomic, copy) NSString *balance;
             @property (nonatomic, copy) NSString *payCount;
             */
            id rst = ^(BOOL isSuccess){
                if (isSuccess) {
                    [self doPaySuccessAction:NO];
                }
            };
            NSDictionary *params = @{
                                     @"orderId": self.payModel.orderid ?: @"",
                                     @"balance": self.payModel.balance,
                                     @"payCount": self.payModel.payamount,
                                     @"rst": rst
                                     };
            [YSMediator pushToViewController:kModuleDatingPay
                                  withParams:params
                                    animated:YES
                                    callBack:NULL];
        }
}

- (void)go2RuleView {
    [YSMediator pushToViewController:kModuleDatingRule
                          withParams:nil
                            animated:YES
                            callBack:NULL];
}

#pragma mark - Initialize

- (void)initialize {
    self.navigationItem.title = @"确认约会";
    self.viewModel = [HYDatingSubmitVM new];
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"规则"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(go2RuleView)];
    
    [self setupMainInfoView];
    [self setupBottomActionView];
}


- (void)setupMainInfoView {
    _titleLabel = ({
        UILabel *label = [UILabel labelWithText:@"约会服务费"
                                      textColor:[UIColor colorWithHexString:@"#43484D"]
                                       font:[UIFont systemFontOfSize:16]
                                         inView:self.view
                                      tapAction:NULL];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(30);
            make.centerX.equalTo(self.view);
        }];
        
        label;
    });
    
    
    _countLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.attributedText = [self countAttributeString];
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(30);
            make.centerX.equalTo(self.view);
        }];
        
        label;
    });
    
    
    _tipsTextView = ({
        UITextView *tf = [[UITextView alloc] init];
        
        NSString *htmlString = [self test];
        NSAttributedString *attrStr = [[NSAttributedString alloc]
                                       initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                       documentAttributes:nil
                                       error:nil];
        tf.textContainerInset = UIEdgeInsetsMake(10, 10, 30, 10);
        tf.attributedText = attrStr;
        tf.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
        tf.editable = NO;
        [self.view addSubview:tf];
        
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_countLabel.mas_bottom).offset(50);
            make.left.right.offset(0);
            make.bottom.offset(-45);
        }];
        
        tf;
    });
}

- (void)setupBottomActionView {
    
    self.actionContentView = ({
        UIView *v = [UIView viewWithBackgroundColor:[UIColor whiteColor]
                                             inView:self.view];
        v.layer.shadowOpacity = 0.1;
        v.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        v.layer.shadowOffset = CGSizeMake(0, -5);

        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo(75);
        }];

        v;
    });

    self.actionBtn = ({
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(30, 15, SCREEN_WIDTH - 60, 45);
        [submitBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        submitBtn.layer.cornerRadius = 22.5;
        submitBtn.clipsToBounds = YES;
        [submitBtn addTarget:self action:@selector(doPayMoneyAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionContentView addSubview:submitBtn];
        submitBtn;
    });
}

- (NSAttributedString *)countAttributeString {
    NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc]
                                        initWithString:@"¥"
                                        attributes:@{
                                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:15]
                                                     }];
    NSAttributedString *unitAttr = [[NSAttributedString alloc]
                                    initWithString:self.payModel.payamount ?: @"0"
                                    attributes:@{
                                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:45]
                                                 }];
    [attrM appendAttributedString:unitAttr];
    return attrM.copy;
}


- (NSString *)test {
    return @"\
    <div style=\"font-size: 10.5px\">\
    <p>约会服务费用途（请仔细阅读）：</p>\
    <p>“约会服务费”是保障您和约会对象<b><span style=\"color:#E53333;\">双方利益</span></b>的一种有效机制，具体如下：</p>\
    <p>\
    1.若对方没有按时接受您的邀请，保证金将<b>全<span style=\"color:#E53333;\">额退还至您的钱包账户</span></b>；\
    </p>\
    <p>\
    2.若您或者对方协商一致取消约会，双方保证金将<b><span style=\"color:#E53333;\">全额退还至双方的钱包账户</span></b>；\
    </p>\
    <p>\
    3.若双方达成约会共识，一方违约（即未到场签到），<b><span style=\"color:#E53333;\">您的保证金将全额退还至您的钱包账户、且违约方的保证金也将全额补偿给如约方（共计</span></b><b><span style=\"color:#E53333;\">398</span></b><b><span style=\"color:#E53333;\">元）</span></b><span style=\"color:#E53333;\">；</span>\
    </p>\
    <p>\
    4.若双方达成约会共识，两方违约（即均未到场签到），则双方保证金均不退还；\
    </p>\
    <p>\
    5.若您和对方成功约会，保证金将<b><span style=\"color:#E53333;\">退还</span></b><b><span style=\"color:#E53333;\">90%</span></b><b><span style=\"color:#E53333;\">至您的钱包账户</span><span style=\"color:#E53333;\">，平台各收取</span></b><b><span style=\"color:#E53333;\">10%</span></b><b><span style=\"color:#E53333;\">（即</span></b><b><span style=\"color:#E53333;\">19.9</span></b><b><span style=\"color:#E53333;\">元）作为佣金</span></b>；\
    </p>\
    <p>\
    6.<b><span style=\"color:#E53333;\">祝您有一个难忘的约会</span></b>。\
    </p>\
    </div>\
    ";
}

@end
