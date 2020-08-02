//
//  QMMAuthUploadIDCell.m
//  SeeYou
//
//  Created by Joseph Koh on 2018/7/16.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "QMMAuthUploadIDCell.h"

@interface QMMAuthUploadIDCell ()

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *frontBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation QMMAuthUploadIDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self bind];
}

- (IBAction)addImageAction:(UIButton *)sender {
    if (self.addBtnClickHandler) {
        self.addBtnClickHandler(sender);
    }
}

- (void)bind {
    @weakify(self);
    [RACObserve(self, cellModel) subscribeNext:^(QMMAuthCellModel *_Nullable x) {
        @strongify(self);
        if (x == nil) return;
        
        [self.titleBtn setImage:[UIImage imageNamed:x.icon] forState:UIControlStateNormal];
        [self.titleBtn setTitle:[NSString stringWithFormat:@"  %@", x.title] forState:UIControlStateNormal];
        self.tipLabel.text = x.info;
    }];
}


- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, 400);
}
@end
