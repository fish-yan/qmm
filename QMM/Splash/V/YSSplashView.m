//
//  YSSplashView.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/27.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "YSSplashView.h"
#import "YSSplashVM.h"

@interface YSSplashView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) YSSplashVM *viewModel;
@property (nonatomic, strong) NSArray *imagesArray;

@end

@implementation YSSplashView

- (void)bindWithViewModel:(YSSplashVM *)vm {
    self.viewModel = vm;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor blackColor];
        self.imagesArray = [NSArray array];
        
        [self setupSubvews];
        [self setupSubvewsLayout];
        [self bind];
    }
    
    return self;
}

- (void)setupSubvews {
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.bounces = NO;
    [self addSubview:self.contentScrollView];
    
    
    
    self.openBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:@"点击进入" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"submit_btn_bg"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        btn.hidden = YES;
        [self addSubview:btn];
        
        btn;
    });
}

- (void)setupSubvewsLayout {
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-30.0);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(150.0, 35.0));
    }];
}

- (void)bind {
    @weakify(self);
    [[[[RACObserve(self, viewModel) distinctUntilChanged]
       filter:^BOOL(id  _Nullable value) {
           return value != nil;
       }]
      map:^id _Nullable(YSSplashVM * _Nullable value) {
          return value.imagesArray;
      }]
     subscribeNext:^(NSArray * _Nullable images) {
         @strongify(self);
         self.imagesArray = images;
         [self makeDisplayImageViewsWithImages:images];
     }];
    
    
    self.showCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self show];
        return [RACSignal empty];
    }];
    
    
    [[[self rac_signalForSelector:@selector(scrollViewDidEndDecelerating:)
                     fromProtocol:@protocol(UIScrollViewDelegate)]
      map:^id _Nullable(id  _Nullable value) {
          @strongify(self);
          NSInteger idx = self.contentScrollView.contentOffset.x / self.width;
          return @(idx);
      }]
     subscribeNext:^(NSNumber * _Nullable x) {
         @strongify(self);
         NSInteger idx = [x integerValue];
         BOOL isLastImageView = NO;
         
         if ((self.imagesArray.count == 1 && idx == 1)  // 只有一个 且 显示第一张图时
             || idx == self.imagesArray.count - 1) {     // 最后一张图
             isLastImageView = YES;
         }
         self.openBtn.hidden = !isLastImageView;
     }];
}

- (void)makeDisplayImageViewsWithImages:(NSArray *)images {
    if (images.count == 0) return;
    
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgV = [UIImageView imageViewWithImageName:obj inView:self.contentScrollView];
        imgV.frame = CGRectMake(self.width * idx, 0, self.width, self.height);
        self.contentScrollView.contentSize = CGSizeMake(self.width * images.count, self.height);
    }];
}

- (void)show {
    if (self.imagesArray == 0) return;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"splash_view_hidden" object:nil];
    }];
}

@end
