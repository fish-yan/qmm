//
//  HYMapViewController.m
//  youbaner
//
//  Created by Joseph Koh on 2018/6/23.
//  Copyright © 2018 luzhongchang. All rights reserved.
//

#import "HYMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "HYMapInnerOpenHelper.h"

@interface MapTransationItem : UIView
@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *info;

@end

@implementation MapTransationItem

+ (instancetype)viewWithIcon:(NSString *)icon info:(NSString *)info {
    MapTransationItem *i = [MapTransationItem new];
    i.icon = icon;
    i.info = info;
    return i;
}

-  (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubvews];
        [self setupSubvewsLayout];
        [self bind];
    }
    
    return self;
}

- (void)setupSubvews {
    _iconV = [UIImageView imageViewWithImageName:nil inView:self];
    [_iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 23));
    }];
    
    _infoLabel = [UILabel labelWithText:@"45分钟"
                              textColor:[UIColor colorWithHexString:@"#313131"]
                               font:[UIFont systemFontOfSize:14]
                                 inView:self
                              tapAction:NULL];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_iconV);
        make.top.equalTo(_iconV.mas_bottom).offset(7);
    }];
}

- (void)setupSubvewsLayout {
    
}

- (void)bind {
    RAC(self.iconV, image) = [RACObserve(self, icon) map:^id _Nullable(id  _Nullable value) {
        return [UIImage imageNamed:value];
    }];
    RAC(self.infoLabel, text) = RACObserve(self, info);
}

@end


#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3

@interface HYMapViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIImageView *locationIcon;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *rangeIcon;
@property (nonatomic, strong) UILabel *rangeLabel;

@property (nonatomic, strong) MapTransationItem *busItem;
@property (nonatomic, strong) MapTransationItem *carItem;
@property (nonatomic, strong) MapTransationItem *walkItem;
@property (nonatomic, strong) UIButton *actionBtn;



@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@end

@implementation HYMapViewController

+ (void)load {
    [self mapName:kModuleMap withParams:nil];
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupSubviews];
    [self initMapView];
    [self initCompleteBlock];
    [self configLocationManager];
    [self bind];
    [self locAction];
}


#pragma mark - Action
- (void)showTranstation {
    [HYMapInnerOpenHelper showMapSelectorInVC:self
                        withCurrentCoordinate:self.currentLocation
                                endCoordinate:self.endLocation
                                      endName:self.name];
}

#pragma mark - Bind

- (void)bind {
}


#pragma mark - Initialize

- (void)initialize {
    self.navigationItem.title = self.name;
    
}



#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    
    //设置开启虚拟定位风险监测，可以根据需要开启
    [self.locationManager setDetectRiskOfFakeLocation:NO];
}

- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)reGeocodeAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)locAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

#pragma mark - Initialization

- (void)initCompleteBlock
{
    __weak HYMapViewController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //根据定位信息，添加annotation
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        [annotation setCoordinate:location.coordinate];
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
            [annotation setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
            [annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
        }
        else
        {
            [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
            [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
        }
        
        HYMapViewController *strongSelf = weakSelf;
        [strongSelf addAnnotationToMapView:annotation];
    };
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    [self.mapView addAnnotation:annotation];
    
    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView setZoomLevel:15.1 animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

- (void)initMapView {
    if (self.mapView == nil) {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 350)];
        [self.mapView setDelegate:self];
        [self.scrollView addSubview:self.mapView];
    }
}

#pragma mark - Setup Subviews

- (void)setupSubviews {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(0, 600);
    [self.view addSubview:self.scrollView];
    
    [self initMapView];
    
    
    
    _locationIcon = ({
        UIImageView *imgV = [UIImageView imageViewWithImageName:@"icon_location" inView:self.scrollView];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.equalTo(_mapView.mas_bottom).offset(20);
            make.size.mas_equalTo(imgV.image.size);
        }];
        imgV;
    });
    
    _locationLabel = ({
        UILabel *l = [UILabel labelWithText:self.address
                                  textColor:[UIColor colorWithHexString:@"#313131"]
                                   font:[UIFont systemFontOfSize:15]
                                     inView:self.scrollView
                                  tapAction:NULL];
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_locationIcon.mas_right).offset(10);
            make.right.offset(-10);
            make.top.equalTo(_locationIcon);
        }];
        
        l;
    });
    
    _rangeIcon = ({
        UIImageView *imgV = [UIImageView imageViewWithImageName:@"icon_range" inView:self.scrollView];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.equalTo(_locationLabel.mas_bottom).offset(20);
            make.size.mas_equalTo(imgV.image.size);
        }];
        imgV;
    });
    
    _rangeLabel = ({
        UILabel *l = [UILabel labelWithText:[NSString stringWithFormat:@"%@米", self.range]
                                  textColor:[UIColor colorWithHexString:@"#313131"]
                                   font:[UIFont systemFontOfSize:15]
                                     inView:self.scrollView
                                  tapAction:NULL];
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_rangeIcon.mas_right).offset(10);
            make.right.offset(-10);
            make.top.equalTo(_rangeIcon);
        }];
        l;
    });
    
    //
    //[self setupTransationItem];
    
    @weakify(self);
    _actionBtn = [UIButton buttonWithTitle:@"导航"
                                titleColor:[UIColor whiteColor]
                                      font:[UIFont systemFontOfSize:16]
                             normalImgName:nil
                      highlightedImageName:nil
                                   bgColor:nil
                         normalBgImageName:@"btn_bg"
                    highlightedBgImageName:nil
                                    inView:self.scrollView
                                    action:^(UIButton *btn) {
                                        @strongify(self);
                                        [self showTranstation];
                                    }];
    [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_rangeLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(315, 45));
    }];
}

- (void)setupTransationItem {
    
    CGSize size = CGSizeMake(SCREEN_WIDTH * 0.3, 50);
    
    _carItem = ({
        MapTransationItem *item = [MapTransationItem viewWithIcon:@"map_car" info:@"20分钟"];
        [_scrollView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(_rangeIcon.mas_bottom).offset(30);
            make.size.mas_equalTo(size);
        }];
        item;
    });
    
    UIView *separator1 = ({
        UIView *v = [UIView viewWithBackgroundColor:[UIColor colorWithHexString:@"#DDDFE2"] inView:_scrollView];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(2, 10));
            make.right.equalTo(_carItem.mas_left);
            make.top.equalTo(_carItem).offset(7);
        }];
        v;
    });
    
    
    
    UIView *separator2 = ({
        UIView *v = [UIView viewWithBackgroundColor:[UIColor colorWithHexString:@"#DDDFE2"] inView:_scrollView];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(2, 10));
            make.left.equalTo(_carItem.mas_right);
            make.top.equalTo(_carItem).offset(7);
        }];
        v;
    });
    
    
    _busItem = ({
        MapTransationItem *item = [MapTransationItem viewWithIcon:@"map_bus" info:@"45分钟"];
        [_scrollView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(separator1.mas_left);
            make.top.equalTo(_rangeIcon.mas_bottom).offset(30);
            make.size.mas_equalTo(size);
        }];
        item;
    });
    

    
    _walkItem = ({
        MapTransationItem *item = [MapTransationItem viewWithIcon:@"map_walk" info:@"99分钟"];
        [_scrollView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(separator2);
            make.top.equalTo(_rangeIcon.mas_bottom).offset(30);
            make.size.mas_equalTo(size);
        }];
        item;
    });
    
    
}

- (void)setupSubviewsLayout {
    
}


#pragma mark - Lazy Loading

@end
