//
//  QMMMsgTextView.h
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChatBoxStatus) {
    ChatBoxStatusNothing,
    ChatBoxStatusShowKeyboard,
};

@class QMMMsgTextView;
@protocol ChatBoxDelegate <NSObject>

- (void)chatBox:(QMMMsgTextView *)chatBox changeStatusForm:(ChatBoxStatus)fromStatus to:(ChatBoxStatus)toStatus;
- (void)chatBox:(QMMMsgTextView *)chatBox sendTextMessage:(NSString *)textMessage;
- (void)chatBox:(QMMMsgTextView *)chatBox changeChatBoxHeight:(CGFloat)height;

@end

@interface QMMMsgTextView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *plachorLabel;
@property (nonatomic, assign) id<ChatBoxDelegate> delegate;
@property (nonatomic, assign) ChatBoxStatus status;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) CGFloat curHeight;

@end

