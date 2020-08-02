//
//  HYAddressListTableViewCell.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYAddressListTableViewCell.h"
#import "HYAddressCellViewModel.h"
#import "AddressSubView.h"


@interface HYAddressListTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) AddressSubView *leftView;
@property (nonatomic, strong) AddressSubView *rightView;

@property (nonatomic, strong) HYAddressCellViewModel *viewModel;

@end

@implementation HYAddressListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
        [self bindModel];
    }
    return self;
}

- (void)setUpView {
    float width = SCREEN_WIDTH - 40;
    self.bgView = [UIView viewWithBackgroundColor:[UIColor clearColor] inView:self.contentView];
    self.bgView.frame = CGRectMake(20, 0, width, 240);


    self.leftView = [[AddressSubView alloc] initWithFrame:CGRectMake(0, 0, width / 2, 240)];
    [self.bgView addSubview:self.leftView];


    self.rightView = [[AddressSubView alloc] initWithFrame:CGRectMake(width / 2, 0, width / 2, 240)];
    [self.bgView addSubview:self.rightView];
}
- (void)layout {
}

- (void)bindWithViewModel:(id)vm {
    if (vm && [vm isKindOfClass:[HYAddressCellViewModel class]]) {
        self.viewModel = vm;
    }
}

- (void)bindModel {
    [RACObserve(self, viewModel) subscribeNext:^(HYAddressCellViewModel *_Nullable x) {

        if (x) {
            if (x.leftViewModel) {
                self.leftView.hidden = NO;
                [self.leftView bindWithViewModel:x.leftViewModel];
            } else {
                self.leftView.hidden = YES;
            }
            if (x.rightViewModel) {
                self.rightView.hidden = NO;
                [self.rightView bindWithViewModel:x.rightViewModel];
            } else {
                self.rightView.hidden = YES;
            }
        }
    }];
}

@end
