//
//  PasswordResettingVC.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIPwdResettingVC.h"
#import "XKUnitls.h"
#import "XKUIUnitls.h"
#import <Masonry.h>
#import "MIPwdConfirmVC.h"
#import <AFViewShaker.h>
#import "XKUserService.h"

@interface MIPwdResettingVC ()<UITextFieldDelegate,XKUserServiceDelegate>

@property (nonatomic,strong,readonly)UITextField *codeTextField;

@property (nonatomic,strong,readonly)UIButton *nextBtn;

@property (nonatomic,strong,readonly)UIView *line;

@property (nonatomic,strong,readonly)UILabel *label;

@property (nonatomic,strong,readonly)UIButton *getCodeBtn;

@property (nonatomic,strong)dispatch_source_t timer;

@end

@implementation MIPwdResettingVC
@synthesize getCodeBtn = _getCodeBtn;
@synthesize codeTextField = _codeTextField;
@synthesize label = _label;
@synthesize nextBtn = _nextBtn;
@synthesize line = _line;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付密码";
    [self setupUI];
    [[XKFDataService() userService] addWeakDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

- (void)dealloc{
     [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    [[XKFDataService() userService] removeWeakDelegate:self];
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}



-(void)setupUI{
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    [self.view addSubview:self.label];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.line];
    [self.view addSubview:self.getCodeBtn];
    [self layout];
    //设置 action
    [self.nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.getCodeBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *mobile = [[XKAccountManager defaultManager] mobile];
    self.label.text = [NSString stringWithFormat:@"支付密码的账号:%@",mobile];
}


- (void)layout{
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(38.0f);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-38.0f);
        make.top.mas_equalTo(50.0f);
        make.height.mas_equalTo(16.0f);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(38.0f);
        make.right.equalTo(self.view).offset(-38.0f);
        make.top.mas_equalTo(self.label.mas_bottom).mas_offset(75.0f);
        make.height.mas_equalTo(0.5f);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.line);
        make.height.mas_equalTo(60.0f);
        make.right.mas_equalTo(self.getCodeBtn.mas_left).mas_offset(-10.0f);
    }];
    
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line);
        make.height.mas_equalTo(30.0f);
        make.centerY.equalTo(self.codeTextField);
        make.width.mas_equalTo(80.0);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.line);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).mas_offset(27.0f);
        make.height.mas_equalTo(40.0f);
    }];
}




#pragma mark button action

- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCodeAction:(id)sender{
    NSString *mobile = [[XKAccountManager defaultManager] mobile];
    @weakify(self);
    [[XKFDataService() userService] changePayPasswordForGetVerifyCodeWithMobile:mobile completion:^(XKBaseResponse * _Nonnull response) {
        @strongify(self);
        if ([response isSuccess]) {
            [self getVerifyCode];
        }else{
            [response showError];
        }
    }];
}

- (void)nextAction:(id)sender{
    NSString *code = self.codeTextField.text;
    if ([NSString isNull:code]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.codeTextField];
        [viewShaker shake];
        return;
    }
    [XKLoading show];
    NSString *mobile = [[XKAccountManager defaultManager] mobile];
    @weakify(self);
    [[XKFDataService() userService] isValidCodeWithMobile:mobile code:code completion:^(XKBaseResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if ([response isSuccess]) {
            if([(NSNumber *)response.data boolValue]){
                MIPwdConfirmVC *controller = [[MIPwdConfirmVC alloc] initWithMobile:mobile code:code];
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                XKShowToast(@"验证码错误");
            }
        }else{
            [response showError];
        }
    }];
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


#pragma mark getter or setter
- (UITextField *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.tintColor = HexRGB(0xcccccc, 1.0f);
        _codeTextField.font = [UIFont systemFontOfSize:15.0f];
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.keyboardType = UIKeyboardTypePhonePad;
        _codeTextField.returnKeyType = UIReturnKeyDone;
        _codeTextField.delegate = self;
    }
    return _codeTextField;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:16.0f];
        _label.textColor = HexRGB(0x999999, 1.0f);
    }
    return _label;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.layer.cornerRadius = 4.0f;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:HexRGB(0x444444, 1.0f)];
        [[_nextBtn titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
        
    }
    return _nextBtn;
}


- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _line;
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

@end
