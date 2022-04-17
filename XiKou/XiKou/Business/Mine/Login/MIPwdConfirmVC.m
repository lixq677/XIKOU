//
//  MIPwdConfirmVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIPwdConfirmVC.h"
#import "XKUnitls.h"
#import "XKUIUnitls.h"
#import <Masonry.h>
#import <AFViewShaker.h>
#import "MIRedBagVC.h"
#import "XKUserService.h"
#import "XKAESEncryptor.h"
#import "XKBase64Encryptor.h"

static NSString *AES_Key = @"xikouxikouxikoux";

@interface MIPwdConfirmVC () <UITextFieldDelegate>

@property (nonatomic,strong,readonly)UITextField *passwordTextField;

@property (nonatomic,strong,readonly)UITextField *confirmPasswordTextField;

@property (nonatomic,strong,readonly)UILabel *label;

@property (nonatomic,strong,readonly)UIButton *confirmBtn;

@property (nonatomic,strong,readonly)UITapGestureRecognizer *tapGesture;

@property (nonatomic,strong,readonly)UIView *line1;
@property (nonatomic,strong,readonly)UIView *line2;

@property (nonatomic,strong,readonly)NSString *mobile;

@property (nonatomic,strong,readonly)NSString *code;

@end

@implementation MIPwdConfirmVC

@synthesize passwordTextField = _passwordTextField;
@synthesize confirmPasswordTextField = _confirmPasswordTextField;
@synthesize confirmBtn = _confirmBtn;
@synthesize line1 = _line1;
@synthesize line2 = _line2;
@synthesize label = _label;
@synthesize tapGesture = _tapGesture;

- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code{
    if (self = [super init]) {
        _mobile = mobile;
        _code = code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付密码";
    [self setupUI];
    self.passwordTextField.xk_monitor = YES;
    self.passwordTextField.xk_maximum = 6;
    self.confirmPasswordTextField.xk_monitor = YES;
    self.confirmPasswordTextField.xk_maximum = 6;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

- (void)dealloc{
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
}


-(void)setupUI{
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.confirmPasswordTextField];
    [self.view addSubview:self.confirmBtn];
    [self.view addSubview:self.line1];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.label];
    
    [self layout];
    
    NSString *mobile = [[XKAccountManager defaultManager] mobile];
    self.label.text = [NSString stringWithFormat:@"支付密码的账号:%@",mobile];
    @weakify(self);
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self commitIt];
    }];
}



- (void)layout{
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(38.0f);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-38.0f);
        make.top.mas_equalTo(50.0f);
        make.height.mas_equalTo(16.0f);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(38.0f);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-38.0f);
        make.top.mas_equalTo(self.label.mas_bottom).mas_offset(15.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.passwordTextField);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.passwordTextField);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.confirmPasswordTextField);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.confirmPasswordTextField);
        make.top.mas_equalTo(self.confirmPasswordTextField.mas_bottom).mas_offset(27.0f);
        make.height.mas_equalTo(40.0f);
    }];
}

- (void)commitIt{
    if ([self.passwordTextField.text length] != 6) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.passwordTextField];
        [viewShaker shake];
        XKShowToast(@"支付密码必须是6位数的数字");
        return;
    }
    if ([self.confirmPasswordTextField.text length] != 6) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.confirmPasswordTextField];
        [viewShaker shake];
        XKShowToast(@"支付密码必须是6位数的数字");
        return;
    }
    
    NSData *payPasswordData = [XKAESEncryptor aes128EncryptDataNoPadding:[self.passwordTextField.text dataUsingEncoding:NSUTF8StringEncoding] key:AES_Key];
    NSString *payPassword = [XKBase64Encryptor base64EncodeData:payPasswordData];
    
    NSData *confirmPasswordData = [XKAESEncryptor aes128EncryptDataNoPadding:[self.confirmPasswordTextField.text dataUsingEncoding:NSUTF8StringEncoding] key:AES_Key];
    NSString *confirmPassword = [XKBase64Encryptor base64EncodeData:confirmPasswordData];
    
    XKPayPasswordParams *params = [[XKPayPasswordParams alloc] init];
    params.userId = [[XKAccountManager defaultManager] userId];
    params.payPassword = payPassword;
    params.confirmPayPassword = confirmPassword;
    params.verificationCode = self.code;
    params.mobile = self.mobile;
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() userService] changePayPasswordWithParams:params completion:^(XKBaseResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if ([response isSuccess]) {
            NSString *userId = [XKAccountManager defaultManager].account.userId;
            XKUserInfoData *userInfoData = [[XKFDataService() userService] queryUserInfoFromCacheWithId:userId];
            userInfoData.isPayPassword = @1;
            [userInfoData updateToDB];
            XKShowToastCompletionBlock(@"设置成功", ^{
                if ([self popToViewController:NSClassFromString(@"CMPaymentOrderVC")]) return;
                [self popToViewController:[MIRedBagVC class]];
            });
        }else{
            [response showError];
        }
    }];
}


#pragma mark button action

#pragma mark getter or setter
- (UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordTextField.placeholder = @"设置6位纯数字的支付密码";
        _passwordTextField.tintColor = HexRGB(0xcccccc, 1.0f);
        _passwordTextField.font = [UIFont systemFontOfSize:15.0f];
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}

- (UITextField *)confirmPasswordTextField{
    if (!_confirmPasswordTextField) {
        _confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _confirmPasswordTextField.placeholder = @"再次确认支付密码";
        _confirmPasswordTextField.tintColor = HexRGB(0xcccccc, 1.0f);
        _confirmPasswordTextField.font = [UIFont systemFontOfSize:15.0f];
        _confirmPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _confirmPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        _confirmPasswordTextField.secureTextEntry = YES;
        _confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
        _confirmPasswordTextField.delegate = self;
    }
    return _confirmPasswordTextField;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.layer.cornerRadius = 4.0f;
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:HexRGB(0x444444, 1.0f)];
        [[_confirmBtn titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
        
    }
    return _confirmBtn;
}


- (UIView *)line1{
    if (!_line1) {
        _line1 = [UIView new];
        _line1.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _line1;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [UIView new];
        _line2.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _line2;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:16.0f];
        _label.textColor = HexRGB(0x999999, 1.0f);
    }
    return _label;
}

@end
