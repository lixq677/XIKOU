//
//  LoginThirdVC.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MILoginVC.h"
#import "XKUnitls.h"
#import "XKUIUnitls.h"
#import "XKDataService.h"
#import <AFViewShaker.h>
#import "WXApiManager.h"
#import "NSError+XKNetwork.h"
#import "MIBindVC.h"
#import "XKCustomAlertView.h"
#import "MIUserProtocolVC.h"

static NSString *const kTelKey = @"XiKou_TelKey";

#define kUserProtocol 0

@interface MILoginVC ()
<UITextFieldDelegate,
XKUserServiceDelegate,
MIUserProtocolVCDelegate>
/*logo*/
@property (nonatomic,strong,readonly)UIImageView *icon;
/*标识*/
@property (nonatomic,strong,readonly)UILabel *label;
//电话号码
@property (nonatomic,strong,readonly)UITextField *telTextField;
//验证码
@property (nonatomic,strong,readonly)UITextField *vcTextField;
//邀请码
@property (nonatomic,strong,readonly)UITextField *icTextField;

//登录
@property (nonatomic,strong,readonly)UIButton *loginBtn;

#if kUserProtocol
//protocol提示
@property (nonatomic,strong,readonly)UILabel *protocolHintLabel;

@property (nonatomic,strong,readonly)UIButton *protocolBtn;

@property (nonatomic,strong,readonly)UIButton *checkBox;

#endif

@property (nonatomic,assign)BOOL checkAgree;



//第三方提示
@property (nonatomic,strong,readonly)UILabel *thirdHintLabel;
//微信
@property (nonatomic,strong,readonly)UIButton *wechatBtn;
@property (nonatomic,strong,readonly)UILabel *wechatLabel;

@property (nonatomic,strong,readonly)UIView *line1;
@property (nonatomic,strong,readonly)UIView *line2;
@property (nonatomic,strong,readonly)UIView *line3;

@property (nonatomic,strong,readonly)UIButton *getCodeBtn;

@property (nonatomic,strong,readonly)UIScrollView *scrollView;

/*判断*/
@property (nonatomic,assign)BOOL regist;

@property (nonatomic,strong)dispatch_source_t timer;

@end

@implementation MILoginVC
@synthesize icon = _icon;
@synthesize label = _label;
@synthesize telTextField = _telTextField;
@synthesize vcTextField = _vcTextField;
@synthesize icTextField = _icTextField;
@synthesize loginBtn = _loginBtn;

#if kUserProtocol

@synthesize protocolHintLabel = _protocolHintLabel;
@synthesize protocolBtn = _protocolBtn;
@synthesize checkBox = _checkBox;

#endif



@synthesize thirdHintLabel = _thirdHintLabel;
@synthesize wechatBtn = _wechatBtn;
@synthesize wechatLabel = _wechatLabel;
@synthesize line1 = _line1;
@synthesize line2 = _line2;
@synthesize line3 = _line3;
@synthesize getCodeBtn = _getCodeBtn;
@synthesize scrollView = _scrollView;

- (instancetype)initWithParams:(NSDictionary *)params{
    if (self = [super init]) {
        BOOL forRegister = [[params objectForKey:@"forRegister"] boolValue];
        NSString *exCode = [params objectForKey:@"extcode"];
        if (forRegister) {
            self.regist = YES;
            self.icTextField.text = exCode;
        }else{
            self.regist = NO;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete-top"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];

    [self setupUI];
    
    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.getCodeBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatBtn addTarget:self action:@selector(loginByWeChatAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[XKFDataService() userService] addWeakDelegate:self];
    if(self.regist == NO){
        NSString *tel = [[NSUserDefaults standardUserDefaults] objectForKey:kTelKey];
        if (![NSString isNull:tel]) {
            [self.telTextField xk_setText:tel];
        }
    }
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [[[[self.telTextField.rac_textSignal distinctUntilChanged] map:^id _Nullable(NSString * _Nullable value) {
        NSString *tel = [value deleteSpace];
        return tel;
    }]filter:^BOOL(NSString * _Nullable value) {
        if([value isMobileNumber])return YES;
        return NO;
    }] subscribeNext:^(NSString * _Nullable x) {
        [[XKFDataService() userService] isRegisterWithMobile:x completion:^(XKBaseResponse * _Nonnull response) {
            if (response.code.intValue == CodeStatus_RegisterAndBinded || response.code.intValue == CodeStatus_RegisterAndNotBinded) {
                self.regist = NO;
                [self setupInviteCodeAni:YES hideIt:YES];
            }else if([response isSuccess]){
                self.regist = YES;
                [self setupInviteCodeAni:YES hideIt:NO];
            }
        }];
    }];
    
    
    
#if APPSTORE == 0
    UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    pressGesture.minimumPressDuration = 2;
    [self.view addGestureRecognizer:pressGesture];
#endif
}

#if APPSTORE == 0
- (void)longPressAction:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"正式环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[XKNetworkConfig shareInstance] setDomainEnv:XKDomainEnvProduct];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"测试环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[XKNetworkConfig shareInstance] setDomainEnv:XKDomainEnvTest];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"开发环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [[XKNetworkConfig shareInstance] setDomainEnv:XKDomainEnvDevelop];
       }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:action4];
    [self presentViewController:alertController animated:YES completion:nil];
}
#endif

- (void)dealloc{
    [[XKFDataService() userService] removeWeakDelegate:self];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}


-(void)setupUI{
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.icon];
    [self.scrollView addSubview:self.label];
    [self.scrollView addSubview:self.telTextField];
    [self.scrollView addSubview:self.vcTextField];
    [self.scrollView addSubview:self.icTextField];
    [self.scrollView addSubview:self.loginBtn];
#if kUserProtocol
    [self.scrollView addSubview:self.protocolHintLabel];
    [self.scrollView addSubview:self.protocolBtn];
    [self.scrollView addSubview:self.checkBox];
#endif
    [self.scrollView addSubview:self.getCodeBtn];
    [self.scrollView addSubview:self.line1];
    [self.scrollView addSubview:self.line2];
    [self.scrollView addSubview:self.line3];
    [self.scrollView addSubview:self.thirdHintLabel];
    [self.scrollView addSubview:self.wechatBtn];
    [self.scrollView addSubview:self.wechatLabel];
   
    
    [self layout];
}


- (void)layout{
   
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6.f);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(70.0f, 70.0f));
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).offset(10.0f);
        make.centerX.equalTo(self.icon);
        make.size.mas_equalTo(CGSizeMake(200.0f, 20));
    }];
    [self.telTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label.mas_bottom).offset(15.0f);
        make.left.mas_equalTo(38.0f);
        make.right.mas_equalTo(kScreenWidth-38.0f);
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

    if (self.regist) {
        self.line3.hidden = NO;
        self.icTextField.hidden = NO;
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line2.mas_bottom).mas_offset(82.0f);
            make.left.right.equalTo(self.line2);
            make.height.mas_equalTo(40.0f);
        }];
    }else{
        self.line3.hidden = YES;
        self.icTextField.hidden = YES;
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.line2);
            make.top.mas_equalTo(self.line2.mas_bottom).mas_offset(20.0f);
            make.height.mas_equalTo(40.0f);
        }];
    }
    
#if kUserProtocol
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginBtn);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).mas_offset(9.0f);
        make.width.height.mas_equalTo(30.0f);
    }];
    
    [self.protocolHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkBox.mas_right).offset(2.0f);
        make.centerY.mas_equalTo(self.checkBox);
        make.height.mas_equalTo(17.0f);
    }];
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.protocolHintLabel.mas_right).offset(7.0f);
        make.height.mas_equalTo(17.0f);
        make.centerY.equalTo(self.protocolHintLabel);
    }];
#endif
    [self.thirdHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loginBtn);
        make.width.mas_equalTo(300.0f);
        make.height.mas_equalTo(17.0f);
#if kUserProtocol
        make.top.mas_equalTo(self.protocolHintLabel.mas_bottom).mas_offset(74.0f);
#else
        make.top.mas_equalTo(self.loginBtn.mas_bottom).mas_offset(74.0f);
#endif
        make.bottom.mas_equalTo(self.wechatBtn.mas_top).mas_offset(-25.0f);
    }];

    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loginBtn);
        make.width.height.mas_equalTo(40.0f);
        make.bottom.mas_equalTo(self.wechatLabel.mas_top).offset(-7.0f);
    }];
    
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.wechatBtn);
        make.bottom.mas_equalTo(-49.0f);
        make.height.mas_equalTo(12.0f);
        make.width.mas_equalTo(60.0f);
    }];
}

#pragma mark private

- (void)setupInviteCodeAni:(BOOL)ani hideIt:(BOOL)hide{
    if (hide == self.line3.isHidden)return;
    if (ani) {
        [UIView animateWithDuration:0.2 animations:^{
            self.line3.hidden = hide;
            self.icTextField.hidden = hide;
            if (hide) {
                [self.loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.line2);
                    make.top.mas_equalTo(self.line2.mas_bottom).mas_offset(20.0f);
                    make.height.mas_equalTo(40.0f);
                }];
            }else{
                [self.loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.line2.mas_bottom).mas_offset(82.0f);
                    make.left.right.equalTo(self.line2);
                    make.height.mas_equalTo(40.0f);
                }];
            }
            [self.view layoutIfNeeded];
        }];
    }else{
        self.line3.hidden = hide;
        self.icTextField.hidden = hide;
        if (hide) {
            [self.loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.line2);
                make.top.mas_equalTo(self.line2.mas_bottom).mas_offset(20.0f);
                make.height.mas_equalTo(40.0f);
            }];
        }else{
            [self.loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.line2.mas_bottom).mas_offset(82.0f);
                make.left.right.equalTo(self.line2);
                make.height.mas_equalTo(40.0f);
            }];
        }
        [self.view layoutIfNeeded];
    }
}

#pragma mark action
- (void)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    NSString *tel = [self.telTextField.text deleteSpace];
    NSString *code = [self.vcTextField.text deleteSpace];
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
    if ([NSString isNull:code]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.vcTextField];
        [viewShaker shake];
        return;
    }
    if (code.length != 4) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.vcTextField];
        [viewShaker shake];
        return;
    }
    [self.view endEditing:YES];
    [[XKFDataService() userService] loginWithNumber:tel code:code completion:^(XKCodeResponse * _Nonnull response) {
        if ([response isSuccess]) {//成功
            [[NSUserDefaults standardUserDefaults] setObject:tel forKey:kTelKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if (response.code.intValue == CodeStatus_NotRegister){
            self.regist = YES;//表示需要注册，界面进入注册
            [self setupInviteCodeAni:YES hideIt:NO];
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
    [self.view endEditing:YES];
    [[XKFDataService() userService] registerWithNumber:tel verifyCode:vCode inviteCode:iCode completion:^(XKCodeResponse * _Nonnull response) {
        if ([response isSuccess]) {//成功
            [[NSUserDefaults standardUserDefaults] setObject:tel forKey:kTelKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.vcTextField becomeFirstResponder];
    [[XKFDataService() userService] getValidCodeWithNumber:tel completion:^(XKCodeResponse * _Nonnull response) {
        if ([response isSuccess]) {
            [self getVerifyCode];
        }else{
            [response showError];
        }
    }];
}

- (void)loginByWeChatAction:(id)sender{
    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        NSString *appId = [[WXApiManager defaultManager] appKey];
        [[WXApiManager defaultManager] getCodeCompletion:^(NSString * _Nonnull code, NSError * _Nonnull error) {
            if (error == nil && code) {
                [[XKFDataService() userService] loginWithWXAppid:appId code:code completion:^(XKCodeResponse * _Nonnull response) {
                    if ([response isSuccess]) {//成功
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else if (response.code.intValue == CodeStatus_WeChatNotBind){
                        MIBindVC *controller = [[MIBindVC alloc] initWithThirdId:response.msg type:XKThirdPlatformTypeWeXin];
                        [self.navigationController pushViewController:controller animated:YES];
                    }else{
                        [response showError];
                    }
                }];
            }else{
                XKShowToast(error.domain);
            }
        }];
    }else{
        //提示：未安装微信应用或版本过低
        XKCustomAlertView *alertView = [[XKCustomAlertView alloc] initWithType:CanleNoTitle andTitle:nil andContent:@"尚未检测到相关客户端，登陆失败" andBtnTitle:@"确定"];
        [alertView show];
    }
}

- (void)protocolAction:(id)sender{
    
    
}

- (void)userProtocolAgree:(BOOL)agree{
    self.checkAgree = YES;
    [self registerUser];
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
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(self.timer);
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
    dispatch_resume(self.timer);
}


#pragma mark getter
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius  = 35.f;
    }
    return _icon;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"欢迎您登录喜扣商城";
        _label.textColor = COLOR_TEXT_GRAY;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = FontMedium(14.f);
    }
    return _label;
}
- (UITextField *)telTextField{
    if (!_telTextField) {
        _telTextField = [[UITextField alloc] init];
        _telTextField.placeholder = @"请输入手机号";
        _telTextField.tintColor = COLOR_TEXT_BROWN;
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
        _vcTextField.delegate = self;
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
        _icTextField.delegate = self;
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

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.layer.cornerRadius = 4.0f;
        _loginBtn.clipsToBounds = YES;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x444444, 1.0f)] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0xcccccc, 1.0f)] forState:    UIControlStateDisabled];
        [[_loginBtn titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
       // [_loginBtn setEnabled:NO];
        
    }
    return _loginBtn;
}

#if kUserProtocol
- (UILabel *)protocolHintLabel{
    if (!_protocolHintLabel) {
        _protocolHintLabel = [[UILabel alloc] init];
        _protocolHintLabel.text = @"我已认真阅读、理解并同意";
        _protocolHintLabel.textColor = HexRGB(0xcccccc, 1.0f);
        _protocolHintLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _protocolHintLabel;
}

- (UIButton *)protocolBtn{
    if (!_protocolBtn) {
        _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _protocolBtn.clipsToBounds = YES;
        _protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_protocolBtn setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
        [_protocolBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
        [_protocolBtn addTarget:self action:@selector(protocolAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _protocolBtn;
}

- (UIButton *)checkBox{
    if (!_checkBox) {
        _checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBox.clipsToBounds = YES;
        _checkBox.layer.cornerRadius = 15.0f;
        [_checkBox setImage:[UIImage imageNamed:@"Oval_deselect"] forState:UIControlStateNormal];
        [_checkBox setImage:[UIImage imageNamed:@"Oval_select"] forState:UIControlStateSelected];
        [[_checkBox rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            x.selected = !x.selected;
        }];
    }
    return _checkBox;
}

#endif

- (UILabel *)thirdHintLabel{
    if (!_thirdHintLabel) {
        _thirdHintLabel = [[UILabel alloc] init];
        _thirdHintLabel.text = @"—— 第三方账号快速登录 ——";
        _thirdHintLabel.textAlignment = NSTextAlignmentCenter;
        _thirdHintLabel.textColor = HexRGB(0xcccccc, 1.0f);
        _thirdHintLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _thirdHintLabel;
}

- (UIButton *)wechatBtn{
    if (!_wechatBtn) {
        _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wechatBtn setImage:[UIImage imageNamed:@"WeChat"] forState:UIControlStateNormal];
    }
    return _wechatBtn;
}

- (UILabel *)wechatLabel{
    if (!_wechatLabel) {
        _wechatLabel = [[UILabel alloc] init];
        _wechatLabel.text = @"微信登录";
        _wechatLabel.textAlignment = NSTextAlignmentCenter;
        _wechatLabel.textColor = HexRGB(0xcccccc, 1.0f);
        _wechatLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _wechatLabel;
}



- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
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
