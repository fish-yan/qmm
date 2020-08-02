//
//  HYOnlinePayVC.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/27.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYOnlinePayVC.h"
#import "HYOnlinePayVM.h"

@interface HYOnlinePayVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIImageView *aliTagImgView;
@property (weak, nonatomic) IBOutlet UIImageView *wxTagImgView;
@property (nonatomic, strong) HYOnlinePayVM *viewModel;
@end

@implementation HYOnlinePayVC

+ (void)load {
    [self mapName:kModuleDatingPay withParams:nil];
}

- (void)initialize {
    self.navigationItem.title = @"在线支付";
    self.viewModel = [HYOnlinePayVM new];
    self.viewModel.orderId = self.orderId;
    self.viewModel.balance = self.balance;
    self.viewModel.count = self.payCount;
    self.viewModel.payType = OnlinePayTypeAli;
    
    self.titleLabel.attributedText = [self titleAttributeString];
    
    self.blanceLabel.text = [NSString stringWithFormat:@"余额抵扣 %@", self.balance ?: @""];
    self.blanceLabel.hidden = (self.actionType == OnlinePayActionTypeInput);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self bind];
}

- (void)bind {
    @weakify(self);
    [[self.viewModel.payCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            [YSProgressHUD showIndeterminate];
        }
    }];
    
    [[self.viewModel.payCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        if (self.rst) {
            self.rst(YES);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.viewModel.payCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
}

- (IBAction)payAction:(id)sender {
    [self.viewModel.payCmd execute:nil];
}

- (IBAction)selectAction:(UITapGestureRecognizer *)gesture {
    UIView *v = gesture.view;
    
    if (v.tag == 998) { // 选择支付宝
        self.aliTagImgView.hidden = NO;
        self.wxTagImgView.hidden = YES;
        self.viewModel.payType = OnlinePayTypeAli;
    }
    else {    // 选择微信
        self.aliTagImgView.hidden = YES;
        self.wxTagImgView.hidden = NO;
        self.viewModel.payType = OnlinePayTypeWeChat;
    }
}
- (NSAttributedString *)titleAttributeString {
    NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc]
                                        initWithString:self.payCount ?: @"-"
                                        attributes:@{
                                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:45]
                                                     }];
    NSAttributedString *unitAttr = [[NSAttributedString alloc]
                                    initWithString:@"/元"
                                    attributes:@{
                                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:15]
                                                 }];
    [attrM appendAttributedString:unitAttr];
    return attrM.copy;
}

@end
