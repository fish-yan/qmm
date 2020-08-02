//
//  YSCodeVerifyView.m
//  自定义文本控件UIKeyInput协议
//
//  Created by Joseph Koh on 2018/4/18.
//  Copyright © 2018年 Joseph Koh. All rights reserved.
//

#import "YSCodeVerifyView.h"

@interface YSCodeVerifyView ()

@property (nonatomic, copy) NSMutableString *strM;
@property (nonatomic, strong) NSMutableArray *layerArrM;

@end

@implementation YSCodeVerifyView

-  (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:20];
        self.clipsToBounds = YES;
        self.margin = 20.0;
        self.padding = 0.0;
        self.codeLength = 4.0;
        self.lineWidth = 2.0;
        self.lineColor = [UIColor blackColor];
        self.inputSize = CGSizeMake(45, 50);
    }
    
    return self;
}


#pragma mark - Main

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat w = self.inputSize.width;
    CGFloat h = self.inputSize.height;
    CGFloat y = 0;

    if (self.layerArrM.count == 0) {
        for (int i = 0 ; i < self.codeLength; i++) {
            CATextLayer *layer = [self createLayer];
            [self.layer addSublayer:layer];

            CGFloat x = self.padding + (self.margin + self.inputSize.width) * i;
            layer.frame = CGRectMake(x, y, w, h);

            [self.layerArrM addObject:layer];
        }
    }
    
    for (int i = 0; i < self.strM.length; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", [self.strM characterAtIndex:i]];
        CATextLayer *layer = [self cachedLayerByIndex:i];
        
        CGFloat x = self.padding + (self.margin + self.inputSize.width) * i;
        layer.frame = CGRectMake(x, y, w, h);
        
        [str drawInRect:CGRectMake(x + w * 0.5 - [self __sizeOfString:str].width * 0.5,
                                   y + h * 0.5 - [self __sizeOfString:str].height * 0.5,
                                   w,
                                   h)
         withAttributes:@{NSFontAttributeName: self.font,
                          NSForegroundColorAttributeName: self.textColor}];
    }
}

- (CGSize)__sizeOfString:(NSString *)string {
    CGSize size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: self.font}
                                       context:nil].size;
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

- (BOOL)hasUnusedCachaLayerByIdx:(NSInteger)idx {
    return (self.layerArrM.count > 0 && idx < self.layerArrM.count);
}

- (CATextLayer *)createLayer {
    CATextLayer *layer = [CATextLayer layer];
    layer.bounds = CGRectMake(0, 0, self.inputSize.width, self.inputSize.height);
    
    switch (self.type) {
        case YSCodeVerifyViewTypeBorder: {
            layer.borderColor = self.lineColor.CGColor;
            layer.borderWidth = self.lineWidth;
            break;
        }
        case YSCodeVerifyViewTypeUnderLine: {
            CAShapeLayer *line = [CAShapeLayer layer];
            line.frame = CGRectMake(0,
                                    layer.bounds.size.height - self.lineWidth,
                                    layer.bounds.size.width,
                                    self.lineWidth);
            line.strokeColor   = self.lineColor.CGColor;
            line.lineCap       = kCALineCapSquare;
            line.lineWidth     = self.lineWidth;
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(layer.bounds.size.width, 0)];
            line.path          = path.CGPath;
            [layer addSublayer:line];
            break;
        }
            
        default:
            break;
    }

    return layer;
}

- (CATextLayer *)cachedLayerByIndex:(NSInteger)idx {
    CATextLayer *layer = nil;
    if (![self hasUnusedCachaLayerByIdx:idx]) {
        layer = [self createLayer];
        [self.layer addSublayer:layer];
        [self.layerArrM addObject:layer];
    }
    else {
        layer = self.layerArrM[idx];
    }
    
    return layer;
}


#pragma mark - UIKeyInput Delegate

- (BOOL)hasText {
    return self.strM.length > 0;
}

- (void)insertText:(NSString *)text {
    if (self.strM.length >= self.codeLength) {
        return;
    }
    [self.strM appendString:text];
    [self setNeedsDisplay];
    
    if (self.strM.length == self.codeLength) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(codeVerifyView:didEndInput:)]) {
                [self.delegate codeVerifyView:self didEndInput:self.strM.copy];
            }
        });
    }
}

- (void)deleteBackward {
    if (self.strM.length == 0) return;
    
    [self.strM deleteCharactersInRange:NSMakeRange(self.strM.length - 1, 1)];
    [self setNeedsDisplay];
}


#pragma mark - Lazy Loading

- (NSMutableString *)strM {
    if (!_strM) {
        _strM = [NSMutableString new];
    }
    return _strM;
}

- (NSMutableArray *)layerArrM {
    if (!_layerArrM) {
        _layerArrM = [NSMutableArray new];
    }
    return _layerArrM;
}
@end
