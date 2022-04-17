//
//  MIBindVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/18.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIBindVC.h"
#import "MIUserProtocolVC.h"

#import "XKUnitls.h"
#import "XKUIUnitls.h"
#import <AFViewShaker.h>
#import <UMShare/UMShare.h>
#import "NSError+XKNetwork.h"
#import "XKUserService.h"

@interface MIBindVC () <UITextFieldDelegate,MIUserProtocolVCDelegate>

//电话号码
@property (nonatomic,strong,readonly)UITextField *telTextField;
//验证码
@property (nonatomic,strong,readonly)UITextField *vcTextField;
//邀请码
@property (nonatomic,strong,readonly)UITextField *icTextField;

//登录
@property (nonatomic,strong,readonly)UIButton *bindBtn;

@property (nonatomic,strong,readonly)UIView *line1;
@property (nonatomic,strong,readonly)UIView *line2;
@property (nonatomic,strong,readonly)UIView *line3;

@property (nonatomic,strong,readonly)UIButton *getCodeBtn;

@property (nonatomic,strong,readonly)UITapGestureRecognizer *tapGesture;

@property (nonatomic,strong,readonly)NSString *thirdId;

@property (nonatomic,assign,readonly)XKThirdPlatformType platformType;

/*判断*/
@property (nonatomic,assign)BOOL regist;

@property (nonatomic,assign)BOOL checkAgree;

@end

@implementation MIBindVC
@synthesize telTextField = _telTextField;
@synthesize vcTextField = _vcTextField;
@synthesize icTextField = _icTextField;
@synthesize bindBtn = _bindBtn;
@synthesize line1 = _line1;
@synthesize line2 = _line2;
@synthesize line3 = _line3;
@synthesize getCodeBtn = _getCodeBtn;
@synthesize tapGesture = _tapGesture;
@synthesize thirdId = _thirdId;
@synthesize platformType = _platformType;

- (instancetype)initWithThirdId:(NSString *)thirdId type:(XKThirdPlatformType)platformType{
    if (self = [super init]) {
        _thirdId = thirdId;
        _platformType = platformType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定手机";
    [self setupUI];
    
    NSString *mobile =  [[XKAccountManager defaultManager] mobile];
    if ([[XKAccountManager defaultManager] isLogin] && NO == [NSString isNull:mobile]) {
        [self.telTextField xk_setText:mobile];
        self.telTextField.enabled = NO;
    }
    
    [self.bindBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.getCodeBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc{
    
}


-(void)setupUI{
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.telTextField];
    [self.view addSubview:self.vcTextField];
    [self.view addSubview:self.icTextField];
    [self.view addSubview:self.bindBtn];
    [self.view addSubview:self.getCodeBtn];
    [self.view addSubview:self.line1];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.line3];
    [self layout];
}


- (void)layout{

    [self.telTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50.f);
        make.left.mas_equalTo(38.0f);
        make.right.equalTo(self.view).offset(-38.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.telTextField);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.line1);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.bottom.equalTo(self.line1).mas_offset(60.0f);
        
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.line2);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.bottom.equalTo(self.line2).mas_offset(60.0f);
        
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
    
    [self.icTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.line3);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.line2);
        make.top.mas_equalTo(self.line2.mas_bottom).mas_offset(20.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
}

#pragma mark private

- (void)setupInviteCode{
    [UIView animateWithDuration:0.2 animations:^{
        self.line3.hidden = NO;
        self.icTextField.hidden = NO;
        [self.bindBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line2.mas_bottom).mas_offset(82.0f);
            make.left.right.equalTo(self.line2);
            make.height.mas_equalTo(40.0f);
        }];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark action
- (void)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userProtocolAgree:(BOOL)agree{
    self.checkAgree = agree;
    [self registerUser];
}

- (void)loginAction:(id)sender{
    if(self.regist){
        if(self.checkAgree){
            [self registerUser];
        }else{
            MIUserProtocolVC *controller = [[MIUserProtocolVC alloc] initWithDelegate:self];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else{
        [self login];
    }
}

- (void)login{
    NSString *tel  = [self.telTextField.text deleteSpace];
    NSString *code = [self.vcTextField.text deleteSpace];
    if ([NSString isNull:tel]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.telTextField];
        [viewShaker shake];
        return;
    }
    if ([NSString isNull:code]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.vcTextField];
        [viewShaker shake];
        return;
    }
    XKRegisterParams *params = [[XKRegisterParams alloc] init];
    params.mobile = tel;
    params.validCode = code;
    params.thirdId = self.thirdId;
    params.type = @(self.platformType);
    @weakify(self);
    [XKLoading show];
    [[XKFDataService() userService] registerWithParams:params completion:^(XKCodeResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if ([response isSuccess]) {//成功
            XKShowToastCompletionBlock(@"绑定成功", ^{
                if (self.presentingViewController) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        }else if (response.code.intValue == CodeStatus_InviteCode){
            self.regist = YES;
            [self setupInviteCode];
        }else{
            [response showError];
        }
    }];
}

- (void)registerUser{
    NSString *tel = [self.telTextField.text deleteSpace];
    NSString *vCode = [self.vcTextField.text deleteSpace];
    NSString *iCode = [self.icTextField.text deleteSpace];
    if ([NSString isNull:tel]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.telTextField];
        [viewShaker shake];
        return;
    }
    if (![tel isMobileNumber]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.telTextField];
        [viewShaker shake];
        XKShowToast(@"请输入正确的手机号码");
        return;
    }
    if ([NSString isNull:vCode]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.vcTextField];
        [viewShaker shake];
        return;
    }
    if ([NSString isNull:iCode]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.icTextField];
        [viewShaker shake];
        return;
    }
    XKRegisterParams *params = [[XKRegisterParams alloc] init];
    params.mobile = tel;
    params.validCode = vCode;
    params.invitationCode = iCode;
    params.thirdId = self.thirdId;
    params.type = @(self.platformType);
    @weakify(self);
    [XKLoading show];
    [[XKFDataService() userService] registerWithParams:params completion:^(XKCodeResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if ([response isSuccess]) {//成功
            XKShowToastCompletionBlock(@"绑定成功", ^{
                if (self.presentingViewController) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        }else{
            [response showError];
        }
    }];
}




- (void)getCodeAction:(id)sender{
    NSString *tel = [self.telTextField.text deleteSpace];
    if ([NSString isNull:tel]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.telTextField];
        [viewShaker shake];
        return;
    }
    [[XKFDataService() userService] getValidCodeWithNumber:tel completion:^(XKCodeResponse * _Nonnull response) {
        if ([response isSuccess]) {
            [self getVerifyCode];
        }else{
           [response showError];
        }
    }];
}



#pragma mark textfield delegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)getVerifyCode{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setEnabled:YES];
                [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setEnabled:NO];
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ds",timeout] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}


#pragma mark getter
- (UITextField *)telTextField{
    if (!_telTextField) {
        _telTextField = [[UITextField alloc] init];
        _telTextField.placeholder = @"请输入手机号";
        _telTextField.tintColor = COLOR_TEXT_BROWN;
        _telTextField.textColor = HexRGB(0x444444, 1.0f);
        _telTextField.font = [UIFont systemFontOfSize:15.0f];
        _telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _telTextField.keyboardType = UIKeyboardTypePhonePad;
        _telTextField.returnKeyType = UIReturnKeyDone;
        _telTextField.delegate = self;
        _telTextField.xk_monitor = YES;
        _telTextField.xk_textFormatter = XKTextFormatterMobile;
        _telTextField.xk_supportContent = XKTextSupportContentNumber;
        _telTextField.xk_maximum = 20;
    }
    return _telTextField;
}

- (UITextField *)vcTextField{
    if (!_vcTextField) {
        _vcTextField = [[UITextField alloc] init];
        _vcTextField.placeholder = @"请输入验证码";
        _vcTextField.tintColor = COLOR_TEXT_BROWN;
        _vcTextField.font = [UIFont systemFontOfSize:15.0f];
        _vcTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _vcTextField.keyboardType = UIKeyboardTypeDefault;
        _vcTextField.returnKeyType = UIReturnKeyDone;
        _vcTextField.xk_monitor = YES;
        _vcTextField.xk_maximum = 8;
    }
    return _vcTextField;
}

- (UITextField *)icTextField{
    if (!_icTextField) {
        _icTextField = [[UITextField alloc] init];
        _icTextField.placeholder = @"请输入邀请码";
        _icTextField.tintColor = COLOR_TEXT_BROWN;
        _icTextField.font = [UIFont systemFontOfSize:15.0f];
        _icTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _icTextField.keyboardType = UIKeyboardTypeDefault;
        _icTextField.returnKeyType = UIReturnKeyDone;
        _icTextField.hidden = YES;
        _icTextField.xk_monitor = YES;
        _icTextField.xk_maximum = 20;
    }
    return _icTextField;
}

- (UIButton *)getCodeBtn{
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
        _getCodeBtn.layer.cornerRadius = 4.0f;
        _getCodeBtn.layer.borderColor = [COLOR_TEXT_BROWN CGColor];
        _getCodeBtn.layer.borderWidth = 1.0f;
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _getCodeBtn;
}

- (UIButton *)bindBtn{
    if (!_bindBtn) {
        _bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bindBtn.layer.cornerRadius = 4.0f;
        _bindBtn.clipsToBounds = YES;
        [_bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [_bindBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_bindBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x444444, 1.0f)] forState:UIControlStateNormal];
        [_bindBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0xcccccc, 1.0f)] forState:    UIControlStateDisabled];
        [[_bindBtn titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
        // [_bindBtn setEnabled:NO];
        
    }
    return _bindBtn;
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

- (UIView *)line3{
    if (!_line3) {
        _line3 = [UIView new];
        _line3.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
        _line3.hidden = YES;
    }
    return _line3;
}


@end
