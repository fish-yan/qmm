//
//  QMMLoginMainVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/11/9.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMLoginMainVC.h"
#import "QMMLoginMainVM.h"

@interface QMMLoginMainVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) QMMLoginMainVM *viewModel;
@property (nonatomic, strong) UIImageView *bgImageV;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation QMMLoginMainVC

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

#pragma mark - Action

- (void)go2LoginView {
    [YSMediator pushToViewController:kModuleLoginRegister
                          withParams:nil
                            animated:YES
                            callBack:nil];
}


#pragma mark - Bind

- (void)bind {
}


#pragma mark - Initialize

- (void)initialize {
    self.canBack = NO;
    self.viewModel = [QMMLoginMainVM new];
}

#pragma mark - Setup Subviews

- (void)setupSubviews {
    CGFloat scale = [UIScreen mainScreen].bounds.size.width/375.0;

    
    _bgImageV = [UIImageView imageViewWithImageName:@"splashBg" inView:self.view];
    _bgImageV.frame = self.view.bounds;

    // ---
    _scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        
        CGFloat top = 20 + (IS_FULL_SCREEN_IPHONE ? 40 : 0);
        scrollView.frame = CGRectMake(0, top, self.view.width, scale * 500);
        [self.view addSubview:scrollView];
       

        for (int i = 0; i < self.viewModel.dataArray.count; i++) {
            NSString *name = self.viewModel.dataArray[i];
            UIView *container = [UIView viewWithBackgroundColor:nil inView:scrollView];
            container.frame = CGRectMake(scrollView.width * i, 0, scrollView.width, scrollView.height);
            
            
            UIImageView *imgV = [UIImageView imageViewWithImageName:name inView:container];
            CGFloat v = 0;//30 * scale;
            CGFloat w = scrollView.width - v * 2;
            CGFloat h = 480.0 * scale;
            imgV.frame = CGRectMake(v, v, w, h);
            imgV.layer.cornerRadius = 10;
            imgV.layer.shadowOffset = CGSizeZero;
            imgV.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            imgV.layer.shadowRadius = 15;
            imgV.layer.shadowOpacity = 0.5;
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.width * self.viewModel.dataArray.count, 0);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        
        scrollView;
    });
    
    
    // --
    _pageControl = ({
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                                     CGRectGetMaxY(self.scrollView.frame) - 30,
                                                                                     self.view.width,
                                                                                     30)];
        pageControl.numberOfPages = self.viewModel.dataArray.count;
        pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#B375FF"];
        [self.view addSubview:pageControl];
        
        pageControl;
    });
    
    // --
    _loginBtn = ({
        UIButton *btn = [UIButton buttonWithTitle:@"登录/注册"
                                       titleColor:[UIColor colorWithHexString:@"#464646"]
                                             font:[UIFont systemFontOfSize:18]
                                          bgColor:[UIColor colorWithHexString:@"#BDFED7"]
                                           inView:self.view
                                           action:^(UIButton *btn) {
                                               [self go2LoginView];
                                           }];
        [btn setCornerWithRadius:20 borderWidth:0 borderColor:nil clipsToBounds:YES];
        btn;
    });
}

- (void)setupSubviewsLayout {
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(38);
        make.right.offset(-38);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.pageControl).offset(70);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger idx = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = idx;
    [self.pageControl updateCurrentPageDisplay];
}


@end
