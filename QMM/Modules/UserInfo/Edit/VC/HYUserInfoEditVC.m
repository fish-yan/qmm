//
//  HYUserInfoEditVC.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/23.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYUserInfoEditVC.h"
#import "QMMUpdateUserInfoHelper.h"

@interface HYUserInfoEditVC ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) QMMUpdateUserInfoHelper *helper;

@end

@implementation HYUserInfoEditVC

+ (void)load {
    [self mapName:kModuleInfoEdit withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self setupSubviewsLayout];
    [self bind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Action


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [[self.helper.updateCmd.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [YSProgressHUD showTips:x];
        if (self.callback) {
            self.callback(self.textView.text);
        }
        [self delayPop];
    }];
    
    [[self.helper.updateCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
    }];
    
    [self.helper.updateCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
}

- (void)delayPop {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self popBack];
    });
}

#pragma mark - Initialize

- (void)initialize {
    self.helper = [QMMUpdateUserInfoHelper new];
    
    NSString *title = @"修改信息";
    NSString *placeHolder = @"请输入内容";
    switch (self.type) {
        case EditInfoTypeNickName:
            title = @"修改昵称";
            placeHolder = @"请输入昵称";
            break;
        case EditInfoTypeJob: {
            title = @"修改工作";
            placeHolder = @"请输入工作";
            break;
        }
        case EditInfoTypeIntro: {
            title = @"修改自我介绍";
            placeHolder = @"请输入自我介绍";
            break;
        }
        default:
            break;
    }
    
    self.navigationItem.title = title;
    self.textView.placeholder = placeHolder;
    self.textView.text = self.info;
}


#pragma mark - Setup Subviews

- (void)setupSubviews {
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"#E7E7E7"].CGColor;
    self.textView.layer.cornerRadius = 5;
}

- (void)setupSubviewsLayout {
}


#pragma mark - Lazy Loading

- (IBAction)submit:(id)sender {
    NSString *str = self.textView.text;
    if (str.length == 0) return;
    
    switch (self.type) {
        case EditInfoTypeNickName: {
            if (str.length < 2 || str.length > 15) {
                [YSProgressHUD showTips:@"昵称字符数应在2 ~ 15之间"];
                return;
            }
            [self.helper.updateCmd execute:@{@"dk":@"name", @"dv": str}];
            break;
        }
        case EditInfoTypeJob: {
            [self.helper.updateCmd execute:@{@"dk":@"jobinfo", @"dv": str}];
            break;
        }
        case EditInfoTypeIntro: {
            [self.helper.updateCmd execute:@{@"dk":@"intro", @"dv": str}];
        }
        default:
            break;
    }
    
    
}

@end
