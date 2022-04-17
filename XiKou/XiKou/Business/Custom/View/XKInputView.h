//
//  UUInputMethodsView.h
//  CallWatch
//
//  Created by Vincent on 2017/2/27.
//  Copyright © 2017年 xtc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKTextView.h"

@class XKInputView;

@protocol XKInputViewDelegate <NSObject>

@optional
// text
- (void)inputView:(XKInputView *)inputView sendMessage:(NSString *)message;


@end

@interface XKInputView : UIView


@property (nonatomic,assign) NSUInteger textMaximumLength;

- (instancetype)initWithDelegate:(id<XKInputViewDelegate>)delegate;

- (void)writeInitText:(NSString *)text;

- (NSString *)readText;

@property (nonatomic,strong,readonly) XKTextView *textView;

@property (nonatomic,strong,readonly) UIButton *sendBtn;

@end

