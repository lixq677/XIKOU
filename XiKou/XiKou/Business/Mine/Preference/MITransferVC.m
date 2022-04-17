//
//  MITransferVC.m
//  XiKou
//
//  Created by 李笑清 on 2019/10/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MITransferVC.h"
#import "XKUserData.h"
#import "MIPaySheet.h"
#import <AFViewShaker.h>
#import "XKUserService.h"
#import "XKCustomAlertView.h"
#import "XKPropertyService.h"
#import "CMPayStateVC.h"
#import "MIPaymentPaswSheet.h"
#import "MIPwdResettingVC.h"

@interface MITransferVC ()<MIPaymentPaswSheetDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *detailLabel;

@property (nonatomic,strong)UILabel *hintTextLabel;

@property (nonatomic,strong)UILabel *hintDetailLabel;

@property (nonatomic,strong)UILabel *yuanLabel;

@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,strong)UIView *line;

@property (nonatomic,strong)UITextField *remarkTextField;

@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,strong)XKUserInfoData *userInfoData;

@end

@implementation MITransferVC

- (instancetype)initWithUserInfoData:(XKUserInfoData *)userInfoData{
    if (self = [super init]) {
        self.userInfoData = userInfoData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"转账";
    [self setupUI];
    [self layout];
  //  @weakify(self);
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //@strongify(self);
        if ([NSString isNull:self.textField.text]) {
            AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:self.textField];
            [shaker shake];
            XKShowToast(@"请输入转账金额");
            return;
        }
        if ([self.textField.text doubleValue] <= 0) {
            AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:self.textField];
            [shaker shake];
            XKShowToast(@"请输入有效转账金额");
            return;
        }
        
        MIPaySheet *sheet = [[MIPaySheet alloc] init];
        [sheet setContent:[NSString stringWithFormat:@"￥ %@",self.textField.text]];
        @weakify(self);
        [sheet setSureBlock:^{
            @strongify(self);
            [self payAction];
        }];
        [sheet show];
    }];
    
}

- (void)setupUI{
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailLabel];
    
    [self.contentView addSubview:self.hintTextLabel];
    [self.contentView addSubview:self.hintDetailLabel];
    
    [self.contentView addSubview:self.yuanLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.line];
    
    [self.contentView addSubview:self.remarkTextField];
    
    [self.contentView addSubview:self.confirmBtn];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoData.headUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    self.textLabel.text = self.userInfoData.nickName;
    self.detailLabel.text = self.userInfoData.mobile;
    self.hintDetailLabel.text = [NSString stringWithFormat:@"可转账余额 ¥%.2f",[[XKAccountManager defaultManager].balance doubleValue]/100.00f];
}

- (void)layout{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(354);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(64.0f, 64.0f));
        make.top.mas_equalTo(30);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(7.5f);
        make.height.mas_equalTo(14);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(7.5f);
        make.height.mas_equalTo(14);
    }];
    
    [self.hintTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(26.5f);
        make.height.mas_equalTo(14);
        
    }];
    
    [self.hintDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.bottom.equalTo(self.hintTextLabel);
    }];
    
    [self.yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hintTextLabel);
        make.top.mas_equalTo(self.hintTextLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(30.0f, 30.0f));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yuanLabel.mas_right).offset(5);
        make.centerY.equalTo(self.yuanLabel);
        make.height.mas_equalTo(40.0f);
        make.right.mas_equalTo(-20);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(self.yuanLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(1.0f);
    }];
    
    [self.remarkTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hintTextLabel).offset(10);
        make.top.mas_equalTo(self.line.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(16.5f);
        make.right.mas_equalTo(-20.0f);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.line.mas_bottom).offset(60);
        make.height.mas_equalTo(40.0f);
    }];
    
}


- (void)payAction{
    NSUInteger banance = [self.textField.text intValue];
    NSNumber *transferBanance = [[XKAccountManager defaultManager] balance];
    if (banance*100 > transferBanance.intValue) {
        XKCustomAlertView *alert = [[XKCustomAlertView alloc] initWithType:CanleNoTitle andTitle:nil andContent:@"转账金额不能大于可转账金额" andBtnTitle:@"确定"];
        [alert show];
        return;
    }
    
    MIPaymentPaswSheet *sheet = [[MIPaymentPaswSheet alloc] initWithDelegate:self];
    [sheet show];
}


- (void)resetPassword:(MIPaymentPaswSheet *)sheet{
    MIPwdResettingVC *controller = [[MIPwdResettingVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)paymentPaswSheet:(MIPaymentPaswSheet *)sheet inputPassword:(NSString *)password{
    if([NSString isNull:password])return;
    [sheet dismiss];
    double banance = [self.textField.text doubleValue];
    XKTransportAccounParams *params = [[XKTransportAccounParams alloc] init];
    params.amount = banance*100;
    params.fromUserId = [[XKAccountManager defaultManager] userId];
    params.toUserId = self.userInfoData.id;
    params.payPassword = password;
    if (NO == [NSString isNull:self.remarkTextField.text]) {
        params.remark = self.remarkTextField.text;
    }
    [[XKFDataService() propertyService] transportAccountWithParams:params completion:^(XKBaseResponse * _Nonnull response) {
        if (response.isSuccess) {
            CMPayStateVC *controller = [[CMPayStateVC alloc] initWithPayState:CMStateTransportSuccess];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [response showError];
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"."] && ([textField.text containsString:@"."] || [NSString isNull:textField.text])) {
        return NO;
    }
    if ([textField.text isEqualToString:@"0"] && [string isEqualToString:@"."] == NO && [string isEqualToString:@""] == NO) {
        return NO;
    }
    return YES;
}



#pragma mark getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 32;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x9b9b9b, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _textLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = HexRGB(0x9b9b9b, 1.0f);
        _detailLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _detailLabel;
}

- (UILabel *)hintTextLabel{
    if (!_hintTextLabel) {
        _hintTextLabel = [[UILabel alloc] init];
        _hintTextLabel.text = @"转账金额";
        _hintTextLabel.textColor = HexRGB(0x444444, 1.0f);
        _hintTextLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _hintTextLabel;
}

- (UILabel *)hintDetailLabel{
    if (!_hintDetailLabel) {
        _hintDetailLabel = [[UILabel alloc] init];
        _hintDetailLabel.textColor = HexRGB(0x999999, 1.0f);
        _hintDetailLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _hintDetailLabel;
}

- (UITextField *)remarkTextField{
    if (!_remarkTextField) {
        _remarkTextField = [[UITextField alloc] init];
        _remarkTextField.font = [UIFont systemFontOfSize:14.0f];
        _remarkTextField.placeholder = @"添加转账说明（50字以内）";
    }
    return _remarkTextField;
}


- (UILabel *)yuanLabel{
    if (!_yuanLabel) {
        _yuanLabel = [[UILabel alloc] init];
        _yuanLabel.text = @"￥";
        _yuanLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    }
    return _yuanLabel;
}


- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
       // _textField.placeholder = @"请输入转账金额";
        _textField.font = [UIFont boldSystemFontOfSize:25.0f];
        _textField.xk_monitor = YES;
        _textField.xk_supportWords = @"^[0-9]{1}[0-9.]*";
        _textField.xk_supportContent = XKTextSupportContentCustom;
        [_textField setXk_textMapBlock:^NSString * _Nonnull(NSString * _Nonnull text) {
            NSArray<NSString *> *array = [text componentsSeparatedByString:@"."];
            if (array.count == 2) {
                NSString *text2 = [array lastObject];
                if (text2.length <= 2)return text;
                NSString *text1 = [array firstObject];
                return  [NSString stringWithFormat:@"%@.%@",text1,[text2 substringToIndex:2]];
            }
            return text;
        }];
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _line;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确认转账" forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0xcccccc, 1.0f)] forState:UIControlStateDisabled];
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x444444, 1.0f)] forState:UIControlStateNormal];
    }
    return _confirmBtn;
}


@end
