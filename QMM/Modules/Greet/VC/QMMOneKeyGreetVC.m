//
//  QMMOneKeyGreetVC.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMOneKeyGreetVC.h"
#import "QMMGreetAnimator.h"
#import "QMMOneKeyGreetVM.h"
#import "QMMExclusiveGreetVC.h"

#define ITEM_TAG_OFFSET 100
#define WIDTH_SCALE SCREEN_WIDTH / 375.0

@interface HYOneKeyGreetItemView : UICollectionViewCell

@property (nonatomic, strong) QMMGreetUserModel *model;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, copy) void(^clickHandler)(QMMGreetUserModel *model, NSInteger tag);

@end

@implementation HYOneKeyGreetItemView

-  (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubvews];
        [self setupSubvewsLayout];
        [self bind];
    }
    
    return self;
}

- (void)setupSubvews {
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.clipsToBounds = YES;
    _btn.layer.cornerRadius = 35;
    _btn.adjustsImageWhenHighlighted = NO;
    _btn.userInteractionEnabled = NO;
    [_btn setBackgroundImage:AVATAR_PLACEHOLDER_IMAGE forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"ic_meet_check"] forState:UIControlStateSelected];
    [self addSubview:_btn];
    
    _nameLabel = [UILabel labelWithText:@"23岁/165cm"
                              textColor:[UIColor colorWithHexString:@"#3A444A"]
                               font:[UIFont systemFontOfSize:12]
                                 inView:self
                              tapAction:NULL];
    
}

- (void)setupSubvewsLayout {
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.height.mas_equalTo(70);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.btn.mas_bottom).offset(10);
    }];
}

- (void)bind {
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(QMMGreetUserModel * _Nullable x) {
        @strongify(self);
        [self.btn sd_setBackgroundImageWithURL:[NSURL URLWithString:x.avatar]
                                      forState:UIControlStateNormal
                              placeholderImage:AVATAR_PLACEHOLDER_IMAGE];
        self.nameLabel.text = [NSString stringWithFormat:@"%@岁/%@cm", x.age, x.height];
    }];
    
    [[self.btn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.clickHandler) {
            self.clickHandler(self.model, self.tag);
        }
    }];
}

@end

@interface QMMOneKeyGreetVC ()<UIViewControllerTransitioningDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) QMMGreetAnimator *animator;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *greetBtn;
@property (nonatomic, strong) UIButton *info;

@property (nonatomic, strong) QMMOneKeyGreetVM *viewModel;
@property (nonatomic, strong) NSMutableDictionary *selItems;
@property (nonatomic, strong) QMMExclusiveGreetVC *exclusiveGreetVC;

@property (nonatomic, copy) NSString *exclusiveGreetStr;

@end

@implementation QMMOneKeyGreetVC

+ (void)load {
    [self mapName:kModuleOneKeyGreetView withParams:nil];
}


//
- (instancetype)init {
    if (self = [super init]) {
        self.animator = [QMMGreetAnimator new];
        self.transitioningDelegate = self.animator;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self setupSubviewsLayout];
    [self bind];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - Action

- (void)requestData {
    [self.viewModel.requestCmd execute:nil];
}

- (void)actionLabelClicked {
    if (![[QMMUserContext shareContext].userModel.vipstatus boolValue]) {
        [YSMediator pushToViewController:kModuleMembership
                              withParams:@{}
                                animated:YES
                                callBack:nil];
        return;
    }
    if (!self.exclusiveGreetVC.view.superview) {
        [self.view addSubview:self.exclusiveGreetVC.view];
    }
    self.exclusiveGreetVC.view.hidden = NO;
}

- (void)onekeyGreetAction {
    __block NSMutableString *ids = [NSMutableString string];
    [self.selItems enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, QMMMemberInfoModel * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *s = ids.length == 0 ? obj.uid :[NSString stringWithFormat:@",%@", obj.uid];
        [ids appendString:s];
    }];
    
    NSDictionary *info = @{
                           @"uid": ids,
                           @"msg" : self.exclusiveGreetStr ?: @""
                           };
    [self.viewModel.greetCmd execute:info];
}


#pragma mark - Bind

- (void)bind {
    @weakify(self);
    [[self.viewModel.requestCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
    }];
    
    [[self.viewModel.requestCmd.executionSignals switchToLatest] subscribeNext:^(NSArray * _Nullable x) {
        @strongify(self);
        [YSProgressHUD hiddenHUD];
        [self.collectionView reloadData];
    }];
    
    [self.viewModel.requestCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
    
    
    // 打招呼
    [[self.viewModel.greetCmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [YSProgressHUD showInView:self.view];
        }
    }];
    
    [[self.viewModel.greetCmd.executionSignals switchToLatest] subscribeNext:^(YSResponseModel * _Nullable x) {
        @strongify(self);
        [YSProgressHUD showTips:@"一键打招呼成功"];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    
    [self.viewModel.greetCmd.errors subscribeNext:^(NSError * _Nullable x) {
        [YSProgressHUD showTips:x.localizedDescription];
    }];
    
}


#pragma mark - Initialize

- (void)initialize {
    self.view.backgroundColor = [UIColor clearColor];
    self.viewModel = [QMMOneKeyGreetVM new];
    
    [self configExclusiveGreetVC];
}

- (void)configExclusiveGreetVC {
    self.exclusiveGreetVC = [QMMExclusiveGreetVC new];
    
    @weakify(self);
    self.exclusiveGreetVC.cancleClickHandler = ^{
        @strongify(self);
        self.exclusiveGreetVC.view.hidden = YES;
    };
    self.exclusiveGreetVC.submitClickHandler = ^(NSString *content) {
        @strongify(self);
        self.exclusiveGreetStr = content;
        self.exclusiveGreetVC.view.hidden = YES;
    };
    [self addChildViewController:self.exclusiveGreetVC];
}


#pragma mark - Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYOneKeyGreetItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseID" forIndexPath:indexPath];
    QMMGreetUserModel *model = self.viewModel.dataArray[indexPath.item];
    cell.model = model;
    cell.btn.selected = YES;
    [self.selItems setObject:model forKey:@(indexPath.item + ITEM_TAG_OFFSET)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HYOneKeyGreetItemView *cell = (HYOneKeyGreetItemView *)[collectionView cellForItemAtIndexPath:indexPath];
    //
    cell.btn.selected = !cell.btn.selected;;
    
    QMMGreetUserModel *model = self.viewModel.dataArray[indexPath.item];
    cell.model = model;
    if (cell.btn.selected) {
        [self.selItems setObject:model forKey:@(indexPath.item + ITEM_TAG_OFFSET)];
    }
    else {
        [self.selItems removeObjectForKey:@(indexPath.item + ITEM_TAG_OFFSET)];
    }
}

#pragma mark - Setup Subviews

- (void)setupSubviews {
    self.maskView = [UIView viewWithBackgroundColor:[UIColor blackColor] inView:self.view];
    self.maskView.tag = 1024;
    self.maskView.alpha = 0.4;
    self.maskView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    self.contentView = [UIView viewWithBackgroundColor:[UIColor whiteColor] inView:self.view];
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.tag = 1025;
    
    
    
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGFloat w = 70 * WIDTH_SCALE;
    layout.itemSize = CGSizeMake(w, 90);
    layout.minimumLineSpacing = 25 * WIDTH_SCALE;
    layout.minimumInteritemSpacing = 20 * WIDTH_SCALE;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, 40* WIDTH_SCALE, 0, 40* WIDTH_SCALE);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //    self.collectionView.showsVerticalScrollIndicator = NO;
    //    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[HYOneKeyGreetItemView class] forCellWithReuseIdentifier:@"reuseID"];
    [self.contentView addSubview:self.collectionView];
    
    @weakify(self);
    self.closeBtn = [UIButton buttonWithNormalImgName:@"close_white"
                                              bgColor:nil
                                               inView:self.view
                                               action:^(UIButton *btn) {
                                                   @strongify(self);
                                                   [self dismissViewControllerAnimated:YES completion:NULL];
                                               }];
    self.closeBtn.tag = 1026;
    
    
    //
    _titleLabel = [UILabel labelWithText:@"精选优质会员，错过后悔"
                               textColor:[UIColor blackColor]
                           textAlignment:NSTextAlignmentCenter
                                font:[UIFont systemFontOfSize:18]
                                  inView:self.contentView
                               tapAction:NULL];
    
    _greetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _greetBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_greetBtn setTitle:@"一键打招呼" forState:UIControlStateNormal];
    [_greetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_greetBtn setBackgroundImage:[UIImage imageNamed:@"action_btn_bg"] forState:UIControlStateNormal];
    [_greetBtn addTarget:self action:@selector(onekeyGreetAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_greetBtn];
    
    //
    _info = [UIButton buttonWithType:UIButtonTypeCustom];
    [_info addTarget:self action:@selector(actionLabelClicked) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_info];
    NSAttributedString *attrStr = [[NSAttributedString alloc]
                                   initWithString:@"我想要与众不同，定制专属打招呼"
                                   attributes:@{
                                                NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#3DA8F5"],
                                                }];
    [_info setAttributedTitle:attrStr forState:UIControlStateNormal];
}

- (void)setupSubviewsLayout {
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.offset(-50);
        make.width.height.mas_equalTo(24);
    }];
    
    
    CGFloat contentPadding = 20 * WIDTH_SCALE;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(contentPadding);
        make.right.offset(-contentPadding);
        make.center.equalTo(self.view);
        make.bottom.equalTo(self.closeBtn.mas_top).offset(-10);
    }];
    
    //
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.centerX.equalTo(self.contentView);
    }];
    
    
    [_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.greetBtn);
        make.bottom.offset(-20);
    }];
    
    
    //
    [_greetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20 * WIDTH_SCALE);
        make.right.offset(-20 * WIDTH_SCALE);
        make.bottom.equalTo(self.info.mas_top).offset(-20);
        make.height.mas_equalTo(WIDTH_SCALE * 45);
    }];
    
    
    
    //
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.right.offset(0);
        make.bottom.equalTo(self.greetBtn.mas_top).offset(-20);
    }];
    
    
}


- (HYOneKeyGreetItemView *)createItemViewWithTag:(NSInteger)tag {
    HYOneKeyGreetItemView *v = [HYOneKeyGreetItemView new];
    v.hidden = YES;
    @weakify(self);
    @weakify(v);
    v.clickHandler = ^(QMMGreetUserModel *model, NSInteger tag) {
        @strongify(self);
        @strongify(v);
        v.selected = !v.isSelected;
        
        if (v.isSelected) {
            [self.selItems setObject:model forKey:@(tag)];
        } else {
            [self.selItems removeObjectForKey:@(tag)];
        }
        // 空的置灰按钮
        self.greetBtn.enabled = (self.selItems.count != 0);
    };
    v.tag = tag;
    return v;
}

- (NSMutableDictionary *)selItems {
    if (!_selItems) {
        _selItems = [NSMutableDictionary dictionary];
    }
    return _selItems;
}
@end
