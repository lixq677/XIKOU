//
//  PasswordSettingVC.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "PasswordSettingVC.h"
#import "XKUnitls.h"
#import "XKUIUnitls.h"
#import <Masonry.h>


@interface PasswordSettingVC ()<UITextFieldDelegate>

@property (nonatomic,strong,readonly)UITextField *passwordTextField;

@property (nonatomic,strong,readonly)UITextField *confirmPasswordTextField;

@property (nonatomic,strong,readonly)UIButton *loginBtn;

@property (nonatomic,strong,readonly)UITapGestureRecognizer *tapGesture;

@property (nonatomic,strong,readonly)UIView *line1;
@property (nonatomic,strong,readonly)UIView *line2;


@end

@implementation PasswordSettingVC
@synthesize passwordTextField = _passwordTextField;
@synthesize confirmPasswordTextField = _confirmPasswordTextField;
@synthesize loginBtn = _loginBtn;
@synthesize line1 = _line1;
@synthesize line2 = _line2;
@synthesize tapGesture = _tapGesture;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self setupUI];
    [self.view addGestureRecognizer:self.tapGesture];
}


-(void)setupUI{
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.confirmPasswordTextField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.line1];
    [self.view addSubview:self.line2];
    
    [self layout];
    //设置 action
}

- (void)setNavigationBar{
    self.title = @"设置密码";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Return"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
}


- (void)layout{
    CGFloat y = [XKUIUnitls safeTop];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(38.0f);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-38.0f);
        make.top.mas_equalTo(y+114.0f);
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
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.confirmPasswordTextField);
        make.top.mas_equalTo(self.confirmPasswordTextField.mas_bottom).mas_offset(27.0f);
        make.height.mas_equalTo(40.0f);
    }];
}




#pragma mark button action

- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapAction:(id)sender{
    [self.view endEditing:YES];
}

#pragma mark getter or setter
- (UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordTextField.placeholder = @"请输入登录密码6-12位数字或字母";
        _passwordTextField.tintColor = HexRGB(0xcccccc, 1.0f);
        _passwordTextField.font = [UIFont systemFontOfSize:15.0f];
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.keyboardType = UIKeyboardTypePhonePad;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}

- (UITextField *)confirmPasswordTextField{
    if (!_confirmPasswordTextField) {
        _confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _confirmPasswordTextField.placeholder = @"请再次确认密码";
        _confirmPasswordTextField.tintColor = HexRGB(0xcccccc, 1.0f);
        _confirmPasswordTextField.font = [UIFont systemFontOfSize:15.0f];
        _confirmPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _confirmPasswordTextField.secureTextEntry = YES;
        _confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
        _confirmPasswordTextField.delegate = self;
    }
    return _confirmPasswordTextField;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.layer.cornerRadius = 4.0f;
        [_loginBtn setTitle:@"确认注册及登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:HexRGB(0x444444, 1.0f)];
        [[_loginBtn titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
        
    }
    return _loginBtn;
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


- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    }
    return _tapGesture;
}

@end
