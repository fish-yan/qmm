//
//  HYCitiesListVM.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYCitiesListVM.h"
#import "HYCityModel.h"

@interface QMMCityInstance: NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) NSArray *cities;

@end

@implementation QMMCityInstance

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static QMMCityInstance *instance;
    dispatch_once(&onceToken, ^{
        instance = [QMMCityInstance new];
    });
    return instance;
}

@end

@implementation HYCitiesListVM

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    @weakify(self);
    self.fetchCitiesCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        RACSignal *signal = nil;
        NSArray *cities = [QMMCityInstance shareInstance].cities;
        
        
        if (!cities) {
            signal = [[self requestSignal] doNext:^(id  _Nullable x) {
                @strongify(self);
                NSArray *arr = [self recombineDataArray:x];
                [QMMCityInstance shareInstance].cities = arr;
                self.cities = arr;
                
            }];
        }
        else {
            self.cities = cities;
            signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:cities];
                [subscriber sendCompleted];
                return nil;
            }];
        }
        return [signal doNext:^(id  _Nullable x) {
            @strongify(self);
            self.indexArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
            
        }];
    }];
    
}

- (NSArray *)recombineDataArray:(NSArray<HYCityModel *> *)dataArray {
    NSMutableArray *arrM_a = [NSMutableArray array];
    NSMutableArray *arrM_b = [NSMutableArray array];
    NSMutableArray *arrM_c = [NSMutableArray array];
    NSMutableArray *arrM_d = [NSMutableArray array];
    NSMutableArray *arrM_e = [NSMutableArray array];
    NSMutableArray *arrM_f = [NSMutableArray array];
    NSMutableArray *arrM_g = [NSMutableArray array];
    NSMutableArray *arrM_h = [NSMutableArray array];
    NSMutableArray *arrM_i = [NSMutableArray array];
    NSMutableArray *arrM_j = [NSMutableArray array];
    NSMutableArray *arrM_k = [NSMutableArray array];
    NSMutableArray *arrM_l = [NSMutableArray array];
    NSMutableArray *arrM_m = [NSMutableArray array];
    NSMutableArray *arrM_n = [NSMutableArray array];
    NSMutableArray *arrM_o = [NSMutableArray array];
    NSMutableArray *arrM_p = [NSMutableArray array];
    NSMutableArray *arrM_q = [NSMutableArray array];
    NSMutableArray *arrM_r = [NSMutableArray array];
    NSMutableArray *arrM_s = [NSMutableArray array];
    NSMutableArray *arrM_t = [NSMutableArray array];
    NSMutableArray *arrM_u = [NSMutableArray array];
    NSMutableArray *arrM_v = [NSMutableArray array];
    NSMutableArray *arrM_w = [NSMutableArray array];
    NSMutableArray *arrM_x = [NSMutableArray array];
    NSMutableArray *arrM_y = [NSMutableArray array];
    NSMutableArray *arrM_z = [NSMutableArray array];
    
    for (HYCityModel *m in dataArray) {
        @autoreleasepool{
            if ([m.initchar isEqualToString:@"a"]) {
                [arrM_a addObject:m];
            }
            else if ([m.initchar isEqualToString:@"b"]) {
                [arrM_b addObject:m];
            }
            else if ([m.initchar isEqualToString:@"c"]) {
                [arrM_c addObject:m];
            }
            else if ([m.initchar isEqualToString:@"d"]) {
                [arrM_d addObject:m];
            }
            else if ([m.initchar isEqualToString:@"e"]) {
                [arrM_e addObject:m];
            }
            else if ([m.initchar isEqualToString:@"f"]) {
                [arrM_f addObject:m];
            }
            else if ([m.initchar isEqualToString:@"g"]) {
                [arrM_g addObject:m];
            }
            else if ([m.initchar isEqualToString:@"h"]) {
                [arrM_h addObject:m];
            }
            else if ([m.initchar isEqualToString:@"i"]) {
                [arrM_i addObject:m];
            }
            else if ([m.initchar isEqualToString:@"j"]) {
                [arrM_j addObject:m];
            }
            else if ([m.initchar isEqualToString:@"k"]) {
                [arrM_k addObject:m];
            }
            else if ([m.initchar isEqualToString:@"l"]) {
                [arrM_l addObject:m];
            }
            else if ([m.initchar isEqualToString:@"m"]) {
                [arrM_m addObject:m];
            }
            else if ([m.initchar isEqualToString:@"n"]) {
                [arrM_n addObject:m];
            }
            else if ([m.initchar isEqualToString:@"o"]) {
                [arrM_o addObject:m];
            }
            else if ([m.initchar isEqualToString:@"p"]) {
                [arrM_p addObject:m];
            }
            else if ([m.initchar isEqualToString:@"q"]) {
                [arrM_q addObject:m];
            }
            else if ([m.initchar isEqualToString:@"r"]) {
                [arrM_r addObject:m];
            }
            else if ([m.initchar isEqualToString:@"s"]) {
                [arrM_s addObject:m];
            }
            else if ([m.initchar isEqualToString:@"t"]) {
                [arrM_t addObject:m];
            }
            else if ([m.initchar isEqualToString:@"u"]) {
                [arrM_u addObject:m];
            }
            else if ([m.initchar isEqualToString:@"v"]) {
                [arrM_v addObject:m];
            }
            else if ([m.initchar isEqualToString:@"w"]) {
                [arrM_w addObject:m];
            }
            else if ([m.initchar isEqualToString:@"x"]) {
                [arrM_x addObject:m];
            }
            else if ([m.initchar isEqualToString:@"y"]) {
                [arrM_y addObject:m];
            }
            else if ([m.initchar isEqualToString:@"z"]) {
                [arrM_z addObject:m];
            }
        }
    }
    
    NSArray *arr = @[arrM_a,
                     arrM_b,
                     arrM_c,
                     arrM_d,
                     arrM_e,
                     arrM_f,
                     arrM_g,
                     arrM_h,
                     arrM_i,
                     arrM_j,
                     arrM_k,
                     arrM_l,
                     arrM_m,
                     arrM_n,
                     arrM_o,
                     arrM_p,
                     arrM_q,
                     arrM_r,
                     arrM_s,
                     arrM_t,
                     arrM_u,
                     arrM_v,
                     arrM_w,
                     arrM_x,
                     arrM_y,
                     arrM_z];
    
    return arr;;
    
}

- (RACSignal *)requestSignal {
    //    " // 父节点id 0为最顶层
    //    private int parent;
    //
    //    // 级别 :1省2市3区县，直辖市1市2市3区县
    //    private int level;"
    NSDictionary *params = @{@"parent": @0,
                             @"parent": @2,
                             };
    return [[YSRequestAdapter requestSignalWithURL:@""
                                            params:[params decodeWithAPI:@"queryarealist"]
                                       requestType:YSRequestTypePOST
                                      responseType:YSResponseTypeList
                                     responseClass:[HYCityModel class]]
            map:^id _Nullable(YSResponseModel * _Nullable value) {
                return value.data;
            }];
}
@end
