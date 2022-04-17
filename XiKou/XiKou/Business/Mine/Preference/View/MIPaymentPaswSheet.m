//
//  MIPaymentPaswSheet.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIPaymentPaswSheet.h"
#import "XKUIUnitls.h"
#import <IQKeyboardManager.h>
#import "XKAESEncryptor.h"
#import "XKBase64Encryptor.h"

static NSString *AES_Key = @"xikouxikouxikoux";

@interface MIPaswView : UIView

@property (nonatomic,strong)UIView *elsView;

@property (nonatomic,assign)BOOL selected;

@end

@implementation MIPaswView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.elsView];
        self.selected = NO;
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
        self.layer.borderColor = [HexRGB(0xe4e4e4, 1.0f) CGColor];
        self.layer.borderWidth = 0.5f;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.elsView.frame = CGRectMake(CGRectGetMidX(self.bounds)-5.0f, CGRectGetMidY(self.bounds)-5.0f, 10.0f, 10.0f);
    if (self.selected) {
        self.elsView.hidden = NO;
    }else{
        self.elsView.hidden = YES;
    }
}

- (UIView *)elsView{
    if (!_elsView) {
        _elsView = [[UIView alloc] init];
        _elsView.backgroundColor = HexRGB(0x444444, 1.0f);
        _elsView.layer.cornerRadius = 5.0f;
    }
    return _elsView;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (selected) {
        [self.elsView setHidden:NO];
    }else{
        [self.elsView setHidden:YES];
    }
}

@end


@interface MIPaymentPaswSheet ()

@property (nonatomic,strong,readonly)NSArray<MIPaswView *> *paswViews;

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UIButton *resetBtn;

@property (nonatomic,strong,readonly)UITextField *textField;

@property (nonatomic,weak)id<MIPaymentPaswSheetDelegate> delegate;

@end

@implementation MIPaymentPaswSheet
@synthesize paswViews = _paswViews;
@synthesize resetBtn = _resetBtn;
@synthesize textLabel = _textLabel;
@synthesize textField = _textField;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleHeight = 60.0f;
        self.titleLabel.text = @"请输入支付密码";
        [self.paswViews enumerateObjectsUsingBlock:^(MIPaswView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSubview:obj];
        }];
        [self addSubview:self.textLabel];
        [self addSubview:self.resetBtn];
        [self addSubview:self.textField];
        [self.textField setXk_monitor:YES];
        [self.textField setXk_maximum:6];
        [self addObserver];
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//        [self.backgroundView addGestureRecognizer:gesture];
        @weakify(self);
        [self.textField setXk_textDidChangeBlock:^(NSString * _Nonnull text) {
            @strongify(self);
            [self inputPassword:text];
        }];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<MIPaymentPaswSheetDelegate>)delegate{
    if (self = [self init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc{
    [self removeObserver];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = 6;
    CGFloat width = 45.0f;
    CGFloat height = 45.0f;
    CGFloat x = CGRectGetMidX(self.bounds) - 0.5*width*count;
    CGFloat y = CGRectGetMaxY(self.titleLabel.frame) + 29.0f;
    for (int i = 0; i<self.paswViews.count; i++) {
        MIPaswView *paswView = [self.paswViews objectAtIndex:i];
        paswView.frame = CGRectMake(x+i*width, y, width, height);
    }
    CGFloat w = self.textLabel.size.width + self.resetBtn.size.width;
    self.textLabel.frame = CGRectMake(CGRectGetMidX(self.bounds)-0.5*w, y+height+22.0f, self.textLabel.size.width, self.textLabel.size.height);
    self.resetBtn.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame), CGRectGetMidY(self.textLabel.frame)-0.5*self.resetBtn.size.height, self.resetBtn.size.width, self.resetBtn.size.height);
}

- (void)show{
    [super show];
    [self.textField becomeFirstResponder];
}

- (void)dismiss{
    //[self.textField setXk_monitor:NO];
    [self.textField resignFirstResponder];
    [super dismiss];
}

- (void)tapAction{
    [self.textField resignFirstResponder];
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
};

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




//输入键盘显示
- (void)inputKeyboardWillShow:(NSNotification *)notif{
    NSDictionary * info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect keyboardFrame = [self.superview convertRect:[aValue CGRectValue] fromView:window];
    [UIView animateWithDuration:0.3f animations:^{
        self.bottom = CGRectGetMinY(keyboardFrame);
    }];
}

//输入键盘隐藏
- (void)inputKeyboardWillHide:(NSNotification *)notif{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottom = CGRectGetMaxY(self.superview.bounds);
    }];
}

- (void)inputKeyboardWillChangeFrame:(NSNotification *)notif{
    NSDictionary * info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect keyboardFrame = [self.superview convertRect:[aValue CGRectValue] fromView:window];
    [UIView animateWithDuration:0.3f animations:^{
        self.bottom = CGRectGetMinY(keyboardFrame) - [XKUIUnitls safeBottom];
    }];
}


- (void)inputPassword:(NSString *)password{
    [self.paswViews enumerateObjectsUsingBlock:^(MIPaswView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < password.length) {
            obj.selected = YES;
        }else{
            obj.selected = NO;
        }
    }];
    if (password.length == 6) {
        NSData *payPasswordData = [XKAESEncryptor aes128EncryptDataNoPadding:[password dataUsingEncoding:NSUTF8StringEncoding] key:AES_Key];
        NSString *payPassword = [XKBase64Encryptor base64EncodeData:payPasswordData];
        if ([self.delegate respondsToSelector:@selector(paymentPaswSheet:inputPassword:)]) {
            [self.delegate paymentPaswSheet:self inputPassword:payPassword];
        }
    }
}

- (void)resetAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(resetPassword:)]) {
        [self.delegate resetPassword:self];
    }
    [self dismiss];
}



- (CGFloat)sheetWidth{
    return kScreenWidth;
}

- (CGFloat)sheetHeight{
    return  214.0f;
}

- (NSArray<MIPaswView *> *)paswViews{
    if (!_paswViews) {
        NSMutableArray<MIPaswView *> *array = [NSMutableArray arrayWithCapacity:6];
        for (int i = 0;i < 6; i++) {
            MIPaswView *paswView = [[MIPaswView alloc] init];
            [array addObject:paswView];
        }
        _paswViews = array;
    }
    return _paswViews;
}

- (UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBtn setTitle:@"去重置" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
        [[_resetBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
        [_resetBtn sizeToFit];
        [_resetBtn addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        _textLabel.textColor = HexRGB(0x999999, 1.0f);
        _textLabel.text = @"忘记密码OR未设置支付密码";
        [_textLabel sizeToFit];
    }
    return _textLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField =  [[UITextField alloc] init];
        _textField.hidden = YES;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

@end
