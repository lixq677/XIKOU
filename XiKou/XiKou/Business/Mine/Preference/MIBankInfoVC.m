//
//  MIBankInfoVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIBankInfoVC.h"
#import <AFViewShaker.h>
#import "MICashAccountVC.h"
#import "NSString+Common.h"
#import "XKPropertyService.h"
#import "XKAccountManager.h"
#import "XKUserService.h"
#import "MIAddressSelectVC.h"
#import "MIBanksVC.h"

@interface MIBkinfCell : UITableViewCell

@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UIButton *button;

@property (nonatomic,copy) void(^clickBlock)(void);

@end

//@class MICashAccountVC;
@implementation  MIBkinfCell
@synthesize textLabel = _textLabel;
@synthesize textField = _textField;
@synthesize button = _button;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.button];
        [self.button addTarget:self action:@selector(clickIt) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(20.0f, CGRectGetMidY(self.contentView.bounds)-15.0f, 110.0f, 30.0f);
    if (self.button.hidden) {
        self.textField.frame = CGRectMake(132.0f, CGRectGetMidY(self.contentView.bounds)-15.0f, CGRectGetWidth(self.contentView.bounds)- 152.0f, 30.0f);
    }else{
        self.button.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds)-91.0f, CGRectGetMidY(self.contentView.bounds)-12.5f, 71.0f, 25.0f);
        self.textField.frame = CGRectMake(132.0f, CGRectGetMidY(self.contentView.bounds)-15.0f, CGRectGetMinX(self.button.frame)- 152.0f, 30.0f);
    }
    
}

- (void)clickIt{
    if (self.clickBlock) {
        self.clickBlock();
    }
}


- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14.0f];
        _textField.textColor = HexRGB(0x666666, 1.0f);
    }
    return _textField;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textLabel;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.cornerRadius = 4.0f;
        _button.clipsToBounds = YES;
    }
    return _button;
}

@end

@interface MIBankInfoVC ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
MIAddressSelectViewControllerDelegate,
MIBankVCDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIButton *addBtn;

@property (nonatomic,strong,readonly) MIAddressSelectVC *addressSelectVC;

@property (nonatomic,assign)XKBankChannel channel;

@property (nonatomic,strong)dispatch_source_t timer;

@property (nonatomic,strong)XKBankListData *bankListData;

@end

@implementation MIBankInfoVC
@synthesize addressSelectVC = _addressSelectVC;

- (instancetype)initWithBankChannel:(XKBankChannel)channel{
    if (self = [super init]) {
        _channel = channel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加银行卡";
    
    /*添加子控制器*/
      [self addChildViewController:self.addressSelectVC];
      [self.view addSubview:self.addressSelectVC.view];
      [self.addressSelectVC didMoveToParentViewController:self];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [self.tableView registerClass:[MIBkinfCell class] forCellReuseIdentifier:@"MIBkinfCell"];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20.0f);
        make.right.equalTo(self.view).offset(-20.0f);
        make.height.mas_equalTo(40.0f);
        make.bottom.equalTo(self.view).offset(-30.0f-[XKUIUnitls safeBottom]);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.addBtn.mas_top).offset(-20.0f);
    }];
    
    [self getVerifyInfo];
    
}

- (void)dealloc{
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }else{
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIBkinfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIBkinfCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        NSArray *titles = @[@"姓名",@"身份证号",@"银行卡",@"银行名称",@"支行名称",@"开户行所在地"];
        NSArray *placeholders = @[@"请输入您的姓名",@"请输入身份证号码",@"请输入银行卡号",@"请选择银行",@"请输入支行名称",@"请选择开户行所在地"];
        cell.textLabel.text = [titles objectAtIndex:indexPath.row];
        cell.textField.placeholder = [placeholders objectAtIndex:indexPath.row];
        cell.button.hidden = YES;
        if (indexPath.row == 0) {
            cell.textField.xk_textFormatter = XKTextFormatterNone;
            cell.textField.xk_maximum = 10;
            cell.textField.xk_supportContent = XKTextSupportContentAll;
            cell.textField.enabled = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == 1) {
            cell.textField.xk_textFormatter = XKTextFormatterID;
            cell.textField.xk_maximum = 18;
            cell.textField.xk_supportContent = XKTextSupportContentNumber | XKTextSupportContentCharacter | XKTextSupportContentSpace;
            cell.textField.enabled = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == 2){
            cell.textField.xk_textFormatter = XKTextFormatterOther;
            cell.textField.xk_maximum = 20;
            cell.textField.xk_supportContent = XKTextSupportContentNumber |  XKTextSupportContentSpace;
            cell.textField.enabled = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if(indexPath.row == 3){
            cell.textField.enabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 5){
            cell.textField.enabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textField.xk_textFormatter = XKTextFormatterNone;
            cell.textField.xk_maximum = 40;
            cell.textField.xk_supportContent = XKTextSupportContentAll;
            cell.textField.enabled = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.clickBlock = nil;
    }else{
        NSArray *titles = @[@"手机号",@"验证码"];
        NSArray *placeholders = @[@"请输入手机号",@"请输入验证码"];
        if (indexPath.row == 1) {
            [cell.button setTitle:@"获取验证码" forState:UIControlStateNormal];
            [cell.button setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
            cell.button.layer.cornerRadius = 4.0f;
            cell.button.layer.borderColor = [COLOR_TEXT_BROWN CGColor];
            cell.button.layer.borderWidth = 1.0f;
            cell.button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            cell.button.hidden = NO;
            cell.textField.xk_textFormatter = XKTextFormatterNone;
            cell.textField.xk_maximum = 8;
            cell.textField.xk_supportContent = XKTextSupportContentNumber | XKTextSupportContentCharacter;
            @weakify(self);
            cell.clickBlock = ^{
                @strongify(self);
                [self getCode];
            };
        }else{
            cell.button.hidden = YES;
            cell.textField.xk_textFormatter = XKTextFormatterMobile;
            cell.textField.xk_maximum = 20;
            cell.textField.xk_supportContent = XKTextSupportContentNumber | XKTextSupportContentCharacter | XKTextSupportContentSpace;
           cell.clickBlock = nil;
        }
        cell.textLabel.text = [titles objectAtIndex:indexPath.row];
        cell.textField.placeholder = [placeholders objectAtIndex:indexPath.row];
    }
    //cell.textField.clearButtonMode = UITextFieldViewModeAlways;
    cell.textField.xk_monitor = YES;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40.0f;
    }else{
        return 0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0f;
    }else{
        return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40.0f)];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0, kScreenWidth-40.0f, 40.0f)];
        textLabel.text = @"为保障您的资金安全，只能绑定实名认证用户本人办理的银行卡";
        textLabel.textColor = HexRGB(0xcccccc, 1.0f);
        textLabel.font = [UIFont systemFontOfSize:10.0f];
        [headerView addSubview:textLabel];
        headerView.backgroundColor = HexRGB(0xffffff, 1.0f);
        return headerView;
    }else{
        return [UIView new];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = COLOR_VIEW_GRAY;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 3) {
        MIBanksVC *controller = [[MIBanksVC alloc] initWithDelegate:self];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 5){
        [self.addressSelectVC show];
    }
}

#pragma mark 地址选择器代理
- (void)addressSelectViewController:(MIAddressSelectVC *)controller finishEditAddress:(XKAddressVoModel *)voData{
    MIBkinfCell *cell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    cell.textField.text = [voData.province stringByAppendingString:voData.city?:@""];
}

- (void)bankVC:(MIBanksVC *)bankVC selectBankListData:(XKBankListData *)bankListData{
    MIBkinfCell *cell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.textField.text = bankListData.name;
    self.bankListData = bankListData;
}




- (void)getVerifyInfo{
    [[XKFDataService() userService]getVerifyInfoWithUserId:[XKAccountManager defaultManager].account.userId completion:^(XKVerifyInfoResponse * _Nonnull response) {
        if ([response isSuccess]) {
            XKVerifyInfoData *data = [response data];
            MIBkinfCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            MIBkinfCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            MIBkinfCell *cell7 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            
            [cell1.textField xk_setText:data.realName];
            [cell2.textField xk_setText:data.idCard];
            [cell7.textField xk_setText:data.mobile];
            cell1.textField.enabled = NO;
            cell2.textField.enabled = NO;
            cell7.textField.enabled = NO;
        }else{
            XKShowToast(@"获取认证信息失败，请退出重试");
        }
    }];
}

//- (NSString *)stringFromRealname:(NSString *)realname{
//    if ([NSString isNull:realname]) return nil;
//    if (realname.length == 1) {
//        return realname;
//    }else if (realname.length == 2){
//        return [@"*" stringByAppendingString:[realname substringFromIndex:1]];
//    }else{
//        NSMutableString *string = [NSMutableString string];
//        NSRange range = NSMakeRange(0, 0);
//        for(int i=0; i<realname.length; i+=range.length){
//            range = [realname rangeOfComposedCharacterSequenceAtIndex:i];
//            if (i == 0 || i+range.length >= realname.length) {
//                 NSString *subStr = [realname substringWithRange:range];
//                [string appendString:subStr];
//            }else{
//                [string appendString:@"*"];
//            }
//        }
//        return string;
//    }
//}
//
//- (NSString *)stringFromCardNumber:(NSString *)cardNumber{
//    if ([NSString isNull:cardNumber]) return nil;
//    if (cardNumber.length <= 4) {
//        return cardNumber;
//    }else{
//        NSMutableString *string = [NSMutableString string];
//        NSRange range = NSMakeRange(0, 0);
//        for(int i=0; i<cardNumber.length; i+=range.length){
//            range = [cardNumber rangeOfComposedCharacterSequenceAtIndex:i];
//            if (i < 0 || i+range.length >= cardNumber.length) {
//                 NSString *subStr = [cardNumber substringWithRange:range];
//                [string appendString:subStr];
//            }else{
//                [string appendString:@"*"];
//            }
//        }
//        return string;
//    }
//}



- (void)requestAddBank{
    MIBkinfCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    MIBkinfCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    MIBkinfCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    MIBkinfCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    MIBkinfCell *cell5 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    MIBkinfCell *cell6 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    MIBkinfCell *cell7 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    MIBkinfCell *cell8 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
   
    if ([NSString isNull:cell1.textField.text]) {
        AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:cell1.textField];
        [shaker shake];
        return;
    }
    
    if ([NSString isNull:cell2.textField.text]) {
        AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:cell2.textField];
        [shaker shake];
        return;
    }
    
    if ([NSString isNull:cell3.textField.text]) {
        AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:cell3.textField];
        [shaker shake];
        return;
    }
    
    if ([NSString isNull:cell4.textField.text]) {
        AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:cell4.textField];
        [shaker shake];
        return;
    }
    
    if ([NSString isNull:cell5.textField.text]) {
        AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:cell5.textField];
        [shaker shake];
        return;
    }
    
    if ([NSString isNull:cell6.textField.text]) {
        AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:cell6.textField];
        [shaker shake];
        return;
    }
    
    if ([NSString isNull:cell7.textField.text]) {
        AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:cell7.textField];
        [shaker shake];
        return;
    }
    
    if ([NSString isNull:cell8.textField.text]) {
        AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:cell8.textField];
        [shaker shake];
        return;
    }
    
    XKBankBindParams *params = [[XKBankBindParams alloc] init];
    params.account = [cell3.textField.text deleteSpace];
    params.bankName = [cell4.textField.text deleteSpace];
    params.branchName = [cell5.textField.text deleteSpace];
    params.bankLocation = [cell6.textField.text deleteSpace];
    params.mobile = [cell7.textField.text deleteSpace];
    params.validaCode = [cell8.textField.text deleteSpace];
    params.channel = self.channel;
    params.userId = [[XKAccountManager defaultManager] userId];
    params.bankCode = self.bankListData.code;
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() propertyService] addBankCardWithParams:params completion:^(XKBaseResponse * _Nonnull response) {
        [XKLoading dismiss];
        @strongify(self);
        if (response.isSuccess) {
            [self popToViewController:[MICashAccountVC class]];
        }else{
            [response showError];
        }
    }];
    
}

- (void)getCode{
    MIBkinfCell *cell7 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if ([NSString isNull:cell7.textField.text]) {
           AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:cell7.textField];
           [shaker shake];
           return;
    }
    NSString *tel = [cell7.textField.text deleteSpace];
    if ([NSString isNull:tel]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:cell7.textField];
        [viewShaker shake];
        return;
    }
    [[XKFDataService() propertyService] getValidCodeWithNumber:tel completion:^(XKBaseResponse * _Nonnull response) {
        if ([response isSuccess]) {
            [self getVerifyCode];
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
                MIBkinfCell *cell8 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                [cell8.button setEnabled:YES];
                [cell8.button setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MIBkinfCell *cell8 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                [cell8.button setEnabled:NO];
                [cell8.button setTitle:[NSString stringWithFormat:@"%ds",timeout] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(self.timer);
}

- (void)addAction:(id)sender{
    [self requestAddBank];
}


#pragma mark getter or settor
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50.0f;
        _tableView.rowHeight = 50.0f;
        _tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
        _tableView.separatorColor = COLOR_VIEW_GRAY;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 20);
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}



- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.backgroundColor =  HexRGB(0x444444, 1.0f);
        [_addBtn setTitle:@"确认验证添加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _addBtn.layer.cornerRadius = 2.0f;
    }
    return _addBtn;
}

- (MIAddressSelectVC *)addressSelectVC{
    if (!_addressSelectVC) {
        _addressSelectVC = [[MIAddressSelectVC alloc] init];
        _addressSelectVC.addressLevel = XKAddressLevelCity;
        _addressSelectVC.autoLocation = NO;
        _addressSelectVC.sheetTitle = @"选择省市";
        _addressSelectVC.delegate = self;
    }
    return _addressSelectVC;
}

@end
