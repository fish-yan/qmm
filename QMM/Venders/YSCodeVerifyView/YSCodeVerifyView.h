//
//  YSCodeVerifyView.h
//  自定义文本控件UIKeyInput协议
//
//  Created by Joseph Koh on 2018/4/18.
//  Copyright © 2018年 Joseph Koh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YSCodeVerifyViewType) {
    YSCodeVerifyViewTypeBorder,
    YSCodeVerifyViewTypeUnderLine,
};

@class YSCodeVerifyView;
@protocol YSCodeVerifyViewDelegate <NSObject>

@optional
- (void)codeVerifyView:(YSCodeVerifyView *)codeVerifyView didEndInput:(NSString *)code;

@end

@interface YSCodeVerifyView : UIView<UIKeyInput>

@property (nonatomic, assign) YSCodeVerifyViewType type;
@property (nonatomic, weak) id<YSCodeVerifyViewDelegate> delegate;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) NSInteger codeLength;
@property (nonatomic, assign) CGSize inputSize;

@end
