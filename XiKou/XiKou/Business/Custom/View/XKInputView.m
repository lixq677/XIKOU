//
//  UUInputMethodsView.m
//  CallWatch
//
//  Created by Vincent on 2017/2/27.
//  Copyright © 2017年 xtc. All rights reserved.
//

#import "XKInputView.h"
#import "XKUIUnitls.h"
#import "UIView+XKUnitls.h"

static const CGFloat kToolBarHeight = 60.0f;//toolBarHeight


@interface XKInputView ()<UITextViewDelegate>

@property (nonatomic,weak) id<XKInputViewDelegate>delegate;

@end

@implementation XKInputView
@synthesize textView = _textView;
@synthesize sendBtn = _sendBtn;

- (instancetype)initWithDelegate:(id<XKInputViewDelegate>)delegate{
    CGRect frame =  CGRectMake(0, 0, kScreenWidth, kToolBarHeight);
    if (self = [super initWithFrame:frame]) {
        _delegate = delegate;
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:Nil];
        [self.textView setXk_monitor:YES];
    }
    return self;
}


-(void)dealloc{
    [self.textView setXk_monitor:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupUI{
    [self addSubview:self.sendBtn];
    [self addSubview:self.textView];
    [self.sendBtn addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.sendBtn.frame = CGRectMake(self.width-65.0f, self.height-48.0f, 50.0f, 35.0f);
    self.textView.frame = CGRectMake(20.0f, 12.0f, self.width-95.0f, self.height-24.0f);
    [self addShadowWithColor:COLOR_LINE_GRAY margin:XKShadowMarginTop];
}


- (void)writeInitText:(NSString *)text{
    [self.textView xk_setText:text];
}

- (NSString *)readText{
    return self.textView.text;
}


- (void)modifyTextViewFrame{
    if ([NSString isNull:_textView.text]) {
        // 修改BAR的高度
        CGRect frame = self.frame;
        if (frame.size.height > kToolBarHeight) {
            frame.size.height = kToolBarHeight;
        }
        frame.origin.y = CGRectGetMaxY(self.frame)-frame.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
        return;
    }
    
    CGSize size = [self.textView sizeThatFits:CGSizeMake(self.width-95.0f, MAXFLOAT)];
    // 修改BAR的高度
    CGRect frame = self.frame;
    if (size.height <= 36) {
        frame.size.height = kToolBarHeight;
    }else if(size.height >= 80.0f){
        frame.size.height  = 80.0f+24.0f;
    }else{
        frame.size.height = size.height+24.0f;
    }
    frame.origin.y = CGRectGetMaxY(self.frame)-frame.size.height;
    self.frame = frame;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if ([text isEqualToString:@"\n"]) {
        [self sendMsg];
        return NO;
    }
    return YES;
}



- (void)textViewChanged:(NSNotification *)notif{
    [self modifyTextViewFrame];
    dispatch_async(dispatch_get_main_queue(), ^{
        //用self.frame.size.height-14.0f来代替self.textView.frame.size.height,是因为在约束的环境下，self.frame改变，但访问self.textView.frame却还未变化
        CGPoint offset = CGPointMake(0, self.textView.contentSize.height - (self.frame.size.height-14.0f));
        if (offset.y > 0) {
            [self.textView setContentOffset:offset animated:YES];
        }
    });
}




- (void)sendMsg{
    if ([self.delegate respondsToSelector:@selector(inputView:sendMessage:)]) {
        NSString *text = self.textView.text;
        if (self.textMaximumLength != 0 && text.length > self.textMaximumLength) {
            text = [text substringToIndex:self.textMaximumLength];
        }
        [self.delegate inputView:self sendMessage:text];
        self.textView.text = @"";
        CGRect rect = self.frame;
        rect.size.height = kToolBarHeight;
        rect.origin.y = CGRectGetMaxY(self.frame) - kToolBarHeight;
        self.frame = rect;
    }
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        _sendBtn.layer.cornerRadius = 2.0f;
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
    }
    return _sendBtn;
}

- (XKTextView *)textView{
    if (!_textView) {
        _textView = [[XKTextView alloc] init];
        _textView.backgroundColor = COLOR_VIEW_GRAY;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.textColor = HexRGB(0x222222, 1.0f);
        _textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.layer.cornerRadius = 6.0f;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor = HexRGB(0xe0e0e0, 1.0f).CGColor;
        _textView.delegate = self;
        _textView.tintColor = HexRGB(0xff7700, 1.0);
        _textView.placeHolderLabel.text = @"请输入评价";
        _textView.placeHolderLabel.textColor = HexRGB(0x999999, 1.0f);
        _textView.placeHolderLabel.font = [UIFont systemFontOfSize:12.0f];
        _textView.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment"]];
        _textView.backgroundColor = COLOR_VIEW_GRAY;
        _textView.xk_maximum = 140;
    }
    return _textView;
}


@end


