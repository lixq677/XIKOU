//
//  LoginCodeVC.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "LoginWithCodeVC.h"
#import "XKUnitls.h"
#import "XKUIUnitls.h"
#import <Masonry.h>
#import "MILoginVC.h"

@interface LoginWithCodeVC () <UITextFieldDelegate>

@property (nonatomic,strong,readonly)UITextField *telTextField;

@property (nonatomic,strong,readonly)UITextField *vcTextField;

@property (nonatomic,strong,readonly)UIButton *loginBtn;

@property (nonatomic,strong,readonly)UIButton *passwordBtn;

@property (nonatomic,strong,readonly)UIImageView *icon;

@property (nonatomic,strong,readonly)UILabel *label;

@property (nonatomic,strong,readonly)UITapGestureRecognizer *tapGesture;

@property (nonatomic,strong,readonly)UIView *line1;
@property (nonatomic,strong,readonly)UIView *line2;
@property (nonatomic,strong,readonly)UIButton *getCodeBtn;

@end

@implementation LoginWithCodeVC
@synthesize telTextField = _telTextField;
@synthesize vcTextField = _vcTextField;
@synthesize loginBtn = _loginBtn;
@synthesize passwordBtn = _passwordBtn;
@synthesize icon = _icon;
@synthesize label = _label;
@synthesize tapGesture = _tapGesture;
@synthesize line1 = _line1;
@synthesize line2 = _line2;
@synthesize getCodeBtn = _getCodeBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self setupUI];
    [self.view addGestureRecognizer:self.tapGesture];
}


-(void)setupUI{
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    // [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.icon];
    [self.view addSubview:self.label];
    [self.view addSubview:self.telTextField];
    [self.view addSubview:self.vcTextField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.passwordBtn];
    [self.view addSubview:self.line1];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.getCodeBtn];
    
    [self layout];
    //设置 action
    [self.passwordBtn addTarget:self action:@selector(passwordLoginAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNavigationBar{
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete-top"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerForLogin:)];

}


- (void)layout{
    CGFloat y = [XKUIUnitls safeTop];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(y+69.0f);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(70.0f, 70.0f));
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).offset(10.0f);
        make.centerX.equalTo(self.icon);
        make.size.mas_equalTo(CGSizeMake(200.0f, 20));
    }];
    
    [self.telTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(37.0f);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-37.0f);
        make.top.mas_equalTo(y+184.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.telTextField);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.line1);
        make.height.mas_equalTo(0.5f);
        make.bottom.equalTo(self.line1).mas_offset(60.0f);        
    }];
    
    [self.vcTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.line2);
        make.height.mas_equalTo(60.0f);
        make.right.mas_equalTo(self.getCodeBtn.mas_left).mas_offset(-10.0f);
    }];
    
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line2);
        make.height.mas_equalTo(30.0f);
        make.centerY.equalTo(self.vcTextField);
        make.width.mas_equalTo(80.0);
    }];

    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.line2);
        make.top.mas_equalTo(self.vcTextField.mas_bottom).mas_offset(53.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginBtn);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(17.0f);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).mas_offset(10.0f);
    }];
}

#pragma mark button action
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerForLogin:(UIButton *)sender{
    MILoginVC *thirdVC = [[MILoginVC alloc] init];
    [self.navigationController pushViewController:thirdVC animated:YES];
}

- (void)passwordLoginAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapAction:(id)sender{
    [self.view endEditing:YES];
}

#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int maxumimLength = 0;
    if (textField == self.telTextField) {
        maxumimLength = 20;
    }else{
        maxumimLength = 6;
    }
    if (textField.text.length > maxumimLength) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}


#pragma mark getter or setter

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    }
    return _icon;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"欢迎您登录喜扣商城";
        _label.textColor = HexRGB(0x999999, 1.0f);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14.0f];
    }
    return _label;
}

- (UITextField *)telTextField{
    if (!_telTextField) {
        _telTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _telTextField.placeholder = @"请输入手机号";
        _telTextField.tintColor = HexRGB(0xcccccc, 1.0f);
        _telTextField.font = [UIFont systemFontOfSize:15.0f];
        _telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _telTextField.keyboardType = UIKeyboardTypePhonePad;
        _telTextField.returnKeyType = UIReturnKeyDone;
        _telTextField.delegate = self;
    }
    return _telTextField;
}

- (UITextField *)vcTextField{
    if (!_vcTextField) {
        _vcTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _vcTextField.placeholder = @"请输入验证码";
        _vcTextField.tintColor = HexRGB(0xcccccc, 1.0f);
        _vcTextField.font = [UIFont systemFontOfSize:15.0f];
        _vcTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _vcTextField.secureTextEntry = YES;
        _vcTextField.returnKeyType = UIReturnKeyDone;
        _vcTextField.delegate = self;
    }
    return _vcTextField;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.layer.cornerRadius = 4.0f;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:HexRGB(0x444444, 1.0f)];
        [[_loginBtn titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
        
    }
    return _loginBtn;
}

- (UIButton *)passwordBtn{
    if (!_passwordBtn) {
        _passwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passwordBtn setTitle:@"手机密码登录" forState:UIControlStateNormal];
        [_passwordBtn setTitleColor:HexRGB(0x999999, 1.0f) forState:UIControlStateNormal];
        [[_passwordBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _passwordBtn;
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

- (UIButton *)getCodeBtn{
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:HexRGB(0xbb9445, 1.0f) forState:UIControlStateNormal];
        _getCodeBtn.layer.cornerRadius = 4.0f;
        _getCodeBtn.layer.borderColor = [HexRGB(0xbb9445, 1.0f) CGColor];
        _getCodeBtn.layer.borderWidth = 1.0f;
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _getCodeBtn;
}


- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    }
    return _tapGesture;
}

@end
