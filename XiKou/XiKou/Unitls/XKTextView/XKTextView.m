//
//  XKTextView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKTextView.h"

@implementation XKTextView
@synthesize placeHolderLabel = _placeHolderLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.placeHolderLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChanged:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat x = 20.0f;
    if (self.leftView) {
        if (![self.subviews containsObject:self.leftView]) {
            [self addSubview:self.leftView];
        }
        self.leftView.frame = CGRectMake(20.0f, CGRectGetHeight(self.bounds)/2.0f-7.0f, 14.0f, 14.0f);
        x = CGRectGetMaxX(self.leftView.frame);
    }
    if (self.placeHolderLabel.hidden  == NO) {
        [self.placeHolderLabel sizeToFit];
        self.placeHolderLabel.frame = CGRectMake(x+5.0f, 11.0f, CGRectGetWidth(self.placeHolderLabel.frame), CGRectGetHeight(self.placeHolderLabel.frame));
    }
}

- (void)textViewTextDidChanged:(NSNotification *)notif{
    if ([notif isKindOfClass:[NSNotification class]] == NO)return;
    if ([notif.object isKindOfClass:[UITextView class]] == NO)return;
    if ([NSString isNull:self.text]) {
        self.leftView.hidden = NO;
        self.placeHolderLabel.hidden  = NO;
        
    }else{
        self.leftView.hidden = YES;
        self.placeHolderLabel.hidden  = YES;
    }
}

- (void)setText:(NSString *)text{
    if ([NSString isNull:text]) {
        self.leftView.hidden = NO;
        self.placeHolderLabel.hidden  = NO;
        
    }else{
        self.leftView.hidden = YES;
        self.placeHolderLabel.hidden  = YES;
    }
    [super setText:text];
}



- (UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
    }
    return _placeHolderLabel;
}


@end
