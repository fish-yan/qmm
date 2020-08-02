//
//  QMMMsgTextView.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/26.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "QMMMsgTextView.h"

#define HEIGHT_TABBAR 49
#define WBColor(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:a]
#define DEFAULT_CHATBOX_COLOR WBColor(244.0, 244.0, 246.0, 1.0)
#define CHATBOX_BUTTON_WIDTH 37
#define HEIGHT_TEXTVIEW 35
#define MAX_TEXTVIEW_HEIGHT 104
@implementation QMMMsgTextView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeButtonColor:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
        _curHeight = frame.size.height;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.topLine];
        [self addSubview:self.textView];

        self.plachorLabel = [UILabel labelWithText:@"说点什么..."
                                         textColor:[UIColor tc5Color]
                                          font:[UIFont systemFontOfSize:15]
                                            inView:self
                                         tapAction:nil];

        [self addSubview:self.plachorLabel];
        @weakify(self);
        [self.plachorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.textView.mas_left).offset(10);
            make.top.equalTo(self.textView.mas_top);
            make.bottom.equalTo(self.textView.mas_bottom);
        }];

        self.status = ChatBoxStatusNothing;

        self.button = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.button addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self.button setTitle:@"发送" forState:UIControlStateNormal];
        [self.button setTitle:@"发送" forState:UIControlStateHighlighted];
        [self.button setTitleColor:[UIColor tc3Color] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor tc3Color] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.button];

        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.mas_top).offset(7);
            make.left.equalTo(self.textView.mas_right).offset(0);
            make.right.equalTo(self).offset(0);
            make.height.mas_equalTo(@35);

        }];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}
- (void)setFrameWidth:(CGFloat)newWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.topLine.width = SCREEN_WIDTH;
}

#pragma Public Methods
- (BOOL)resignFirstResponder {
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}


- (void)sendCurrentMessage {
    if (self.textView.text.length > 0) {    // send Text
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:sendTextMessage:)]) {
            [_delegate chatBox:self sendTextMessage:self.textView.text];
        }
    };
    [self textViewDidChange:self.textView];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    ChatBoxStatus lastStatus = self.status;
    self.status              = ChatBoxStatusShowKeyboard;
    if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
        [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat height = [textView sizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)].height;
    height         = height > HEIGHT_TEXTVIEW ? height : HEIGHT_TEXTVIEW;
    height         = height < MAX_TEXTVIEW_HEIGHT ? height : MAX_TEXTVIEW_HEIGHT;
    _curHeight     = height + HEIGHT_TABBAR - HEIGHT_TEXTVIEW;

    if (_curHeight != self.height) {
        [UIView animateWithDuration:0.05
                         animations:^{
                             self.height = self.curHeight - 5;

                             if (self.delegate && [self.delegate respondsToSelector:@selector(chatBox:changeChatBoxHeight:)]) {
                                 [self.delegate chatBox:self changeChatBoxHeight:self.curHeight];
                             }
                         }];
    }
    if (height != textView.height) {
        [UIView animateWithDuration:0.05
                         animations:^{
                             textView.height = height;
                             [textView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.top.equalTo(self.mas_top).offset(7);
                                 make.bottom.equalTo(self.mas_bottom).offset(-7);
                                 make.left.equalTo(self.mas_left).offset(15);
                                 make.right.equalTo(self.mas_right).offset(-52);
                             }];

                         }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendCurrentMessage];
        return NO;
    } else if (textView.text.length > 0 && [text isEqualToString:@""]) {    // delete
        if ([textView.text characterAtIndex:range.location] == ']') {
            NSUInteger location = range.location;
            NSUInteger length   = range.length;
            while (location != 0) {
                location--;
                length++;
                char c = [textView.text characterAtIndex:location];
                if (c == '[') {
                    textView.text =
                    [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
                    return NO;
                } else if (c == ']') {
                    return YES;
                }
            }
        }
    }

    return YES;
}


- (UIView *)topLine {
    if (_topLine == nil) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        [_topLine
        setBackgroundColor:[[UIColor alloc] initWithRed:219 / 255.0 green:219 / 255.0 blue:219 / 255.0 alpha:1]];
    }
    return _topLine;
}
- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 7, SCREEN_WIDTH - 52 - 15, 35)];
        [_textView setFont:[UIFont systemFontOfSize:16.0f]];
        [_textView.layer setMasksToBounds:YES];
        [_textView.layer setCornerRadius:4.0f];
        [_textView.layer setBorderWidth:0.5f];
        [_textView.layer setBorderColor:self.topLine.backgroundColor.CGColor];
        [_textView setScrollsToTop:NO];
        [_textView setReturnKeyType:UIReturnKeySend];
        [_textView setDelegate:self];
    }
    return _textView;
}
- (void)sendMessage {
    if (self.textView.text.length > 0) {    // send Text
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:sendTextMessage:)]) {
            [_delegate chatBox:self sendTextMessage:self.textView.text];
        }
    }
}
- (void)changeButtonColor:(NSNotification *)info {
    if (self.textView.text.length > 0) {
        self.plachorLabel.hidden = YES;
        [self.button setTitleColor:[UIColor tc3Color] forState:UIControlStateNormal];


    } else {
        self.plachorLabel.hidden = NO;
        [self.button setTitleColor:[UIColor tc3Color] forState:UIControlStateNormal];
    }
}
@end
