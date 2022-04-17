//
//  MICashVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/21.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MICashOutVC.h"
#import "XKUIUnitls.h"
#import "MICashSheet.h"
#import "MICashAccountVC.h"
#import "XKPropertyService.h"
#import "MIPaymentPaswSheet.h"
#import "MIPwdResettingVC.h"
#import "XKAccountManager.h"
#import "CMPayStateVC.h"

@interface MICashBankCell : UITableViewCell

@end

@implementation MICashBankCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize imageView = _imageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return self;
}

- (void)setup{
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.imageView];
    self.backgroundColor = COLOR_VIEW_GRAY;
    self.contentView.backgroundColor = COLOR_VIEW_GRAY;
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(60.0f);
        make.top.equalTo(self.contentView).offset(23.0f);
        make.bottom.equalTo(self.contentView).offset(-23.0f);
        
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textLabel.mas_right).offset(20.0f);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(20.0f);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(5.0f);
        make.right.mas_equalTo(-20.0f);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"收款账号";
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _detailTextLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}


@end

@interface MICashMoneyCell : UITableViewCell

@property (nonatomic,strong,readonly)UITextField *textField;
@property (nonatomic,strong,readonly)UIView *bottomLine;
@property (nonatomic,strong,readonly)UILabel *banaceLabel;

@end

@implementation MICashMoneyCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize textField = _textField;
@synthesize bottomLine = _bottomLine;
@synthesize banaceLabel = _banaceLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.textField setXk_monitor:YES];
        [self.textField setXk_maximum:10];
    }
    return self;
}


- (void)setup{
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.banaceLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(25.0f);
        make.width.mas_equalTo(60.0f);
    }];
    [self.banaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textLabel);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(15.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(20.0f);
        make.width.mas_equalTo(30.0f);
        make.height.mas_equalTo(25.0f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_equalTo(-22.0f);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.detailTextLabel);
        make.left.mas_equalTo(self.detailTextLabel.mas_right).offset(10.0f);
        make.right.equalTo(self.contentView).offset(-10.0f);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20.0f);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"提现金额";
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _textLabel;
}

- (UILabel *)banaceLabel{
    if (!_banaceLabel) {
        _banaceLabel = [[UILabel alloc] init];
        _banaceLabel.textColor = HexRGB(0x999999, 1.0f);
        _banaceLabel.font = [UIFont systemFontOfSize:12.0f];
        _banaceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _banaceLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x444444, 1.0f);
        _detailTextLabel.font = [UIFont boldSystemFontOfSize:25.0f];
        _detailTextLabel.text = @"¥";
    }
    return _detailTextLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = HexRGB(0x444444, 1.0f);
        _textField.font = [UIFont boldSystemFontOfSize:25.0f];
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _textField;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = HexRGB(0xe4e4de, 1.0f);
    }
    return _bottomLine;
}

@end

@interface MICashOutTypeCell : UITableViewCell

@property (nonatomic,strong,readonly)UIView *bottomLine;

@end

@implementation MICashOutTypeCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize bottomLine = _bottomLine;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
       // self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


- (void)setup{
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.bottomLine];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.centerY.equalTo(self.contentView);
        make.top.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.0f);
        make.centerY.equalTo(self.contentView);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20.0f);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"提现类型";
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x4a4a4a, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _detailTextLabel;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = HexRGB(0xe4e4de, 1.0f);
    }
    return _bottomLine;
}

@end

@interface MICashBalanceCell : UITableViewCell

@property (nonatomic,strong,readonly)UIButton *button;

@end

@implementation MICashBalanceCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize button = _button;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup{
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.button];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(6.0f);
        make.height.mas_equalTo(17.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(self.textLabel.mas_bottom);
        make.height.mas_equalTo(17.0f);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailTextLabel.mas_bottom).offset(25.0f);
        make.left.equalTo(self.contentView).offset(20.0f);
        make.right.equalTo(self.contentView).offset(-20.0f);
        make.bottom.equalTo(self.contentView).offset(-10.0f);
        make.height.mas_equalTo(40.0f);
    }];
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x4a4a4a, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        _textLabel.text = [NSString stringWithFormat:@"手续费:0.00元"];
    }
    return _textLabel;
}


- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x4a4a4a, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailTextLabel.text = [NSString stringWithFormat:@"实际到账:0.00元"];
    }
    return _detailTextLabel;
}

- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.layer.cornerRadius = 2.0f;
        [_button setEnabled:NO];
        [_button setTitle:@"提现" forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_button setBackgroundImage:[UIImage imageWithColor:HexRGB(0xcccccc, 1.0f)] forState:UIControlStateDisabled];
        [_button setBackgroundImage:[UIImage imageWithColor:HexRGB(0x444444, 1.0f)] forState:UIControlStateNormal];
    }
    return _button;
}


@end

@interface MICashOutVC ()
<UITableViewDelegate,
UITableViewDataSource,
MICashAccountVCDelegate,
MIPaymentPaswSheetDelegate,
XKPropertyServiceDelegate,
UITextFieldDelegate>

@property (nonatomic,strong,readonly)UITableView *tableView;

@property (nonatomic,strong,readonly)UILabel *hintLabel;

@property (nonatomic,strong,readonly)XKRedBagData *redBagData;

@property (nonatomic,strong,readonly)XKBankData *bankData;

@end

@implementation MICashOutVC
@synthesize tableView = _tableView;
@synthesize hintLabel = _hintLabel;

- (instancetype)initWithRedData:(XKRedBagData *)redBagData{
    if (self = [super init]) {
        _redBagData = redBagData;
        _bankData = [redBagData.bankCardList firstObject];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的提现";
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationBarStyle = XKNavigationBarStyleTranslucent;
     [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [self setupUI];
    [self autoLayout];
    [[XKFDataService() propertyService] addWeakDelegate:self];
    
}

- (void)dealloc{
     [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    [[XKFDataService() propertyService] removeWeakDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setupUI{
    // gradient
    CGFloat y = [XKUIUnitls safeTop];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,kScreenWidth,kScreenWidth/375.0f*150.0f+y);
    gl.startPoint = CGPointMake(0.85, 1);
    gl.endPoint = CGPointMake(0.31, 0.06);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.view.layer addSublayer:gl];
    
    [self.view addSubview:self.tableView];
    
    //self.hintLabel.text = @"提现规则：单笔不超过5万元，单日不超过20W ，日提现次数8次";
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.hintLabel];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120.0f;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerClass:[MICashBankCell class] forCellReuseIdentifier:@"MICashBankCell"];
    [self.tableView registerClass:[MICashMoneyCell class] forCellReuseIdentifier:@"MICashMoneyCell"];
    [self.tableView registerClass:[MICashOutTypeCell class] forCellReuseIdentifier:@"MICashOutTypeCell"];
    [self.tableView registerClass:[MICashBalanceCell class] forCellReuseIdentifier:@"MICashBalanceCell"];
}


- (void)autoLayout{
    CGFloat y = [XKUIUnitls safeTop];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15.0f);
        make.top.mas_equalTo(y+kNavBarHeight+11.0f);
        make.height.mas_equalTo(341.0f);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tableView);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(20.0f);
    }];
}

#pragma mark action



#pragma mark getter
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MICashBankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MICashBankCell" forIndexPath:indexPath];
        if ([NSString isNull:self.bankData.image]) {
            NSString *imageName = [[XKFDataService() propertyService] imageNameFromBankName:self.bankData.bankName];
            cell.imageView.image = [UIImage imageNamed:imageName];
        }else{
           [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.bankData.image] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
        }
        NSString *imageName = [[XKFDataService() propertyService] imageNameFromBankName:self.bankData.bankName];
        cell.imageView.image = [UIImage imageNamed:imageName];
        
        NSString *cardTail = nil;
        if ([self.bankData.account length] > 4) {
            cardTail = [self.bankData.account substringFromIndex:self.bankData.account.length-4];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)",self.bankData.bankName,cardTail];
        }else{
            cardTail = self.bankData.account;
            if([NSString isNull:cardTail]){
                cell.detailTextLabel.text = self.bankData.bankName;
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)",self.bankData.bankName,cardTail];
            }
        }
        return cell;
    }else if (indexPath.row == 1){
        MICashMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MICashMoneyCell" forIndexPath:indexPath];
        @weakify(self);
        [cell.textField setXk_textDidChangeBlock:^(NSString * _Nonnull text) {
            @strongify(self);
            [self cashChanged:text];
        }];
        cell.textField.delegate = self;
        [cell.textField setXk_textMapBlock:^NSString * _Nonnull(NSString * _Nonnull text) {
            NSArray<NSString *> *array = [text componentsSeparatedByString:@"."];
            if (array.count == 2) {
                NSString *text2 = [array lastObject];
                if (text2.length <= 2)return text;
                NSString *text1 = [array firstObject];
                return  [NSString stringWithFormat:@"%@.%@",text1,[text2 substringToIndex:2]];
            }
            return text;
        }];
        cell.banaceLabel.text = [NSString stringWithFormat:@"余额 ¥%.2f",self.redBagData.balance.doubleValue/100.00f];
        return cell;
    }else if (indexPath.row == 2){
        MICashOutTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MICashOutTypeCell" forIndexPath:indexPath];
        cell.textLabel.text = @"提现类型";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"即时到账 (%@%%)",@(self.redBagData.rate)];
        return cell;
    }else{
        MICashBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MICashBalanceCell" forIndexPath:indexPath];
        [cell.button addTarget:self action:@selector(verifyPassword) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MICashAccountVC *controller = [[MICashAccountVC alloc] init];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 2){
//        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//        MICashSheet *sheet = [[MICashSheet alloc] init];
//        [sheet show];
    }
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


- (void)cashAccountVC:(MICashAccountVC *)viewController selectBankCard:(XKBankData *)bankData{
    _bankData = bankData;
    MICashBankCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([NSString isNull:bankData.image]) {
        NSString *imageName = [[XKFDataService() propertyService] imageNameFromBankName:self.bankData.bankName];
        cell.imageView.image = [UIImage imageNamed:imageName];
    }else{
       [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bankData.image] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
    }
    
    NSString *cardTail = nil;
    if ([bankData.account length] > 4) {
        cardTail = [bankData.account substringFromIndex:bankData.account.length-4];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)",self.bankData.bankName,cardTail];
    }else{
        cardTail = bankData.account;
        if([NSString isNull:cardTail]){
            cell.detailTextLabel.text = self.bankData.bankName;
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)",self.bankData.bankName,cardTail];
        }
    }
}

- (void)paymentPaswSheet:(MIPaymentPaswSheet *)sheet inputPassword:(NSString *)password{
    if([NSString isNull:password])return;
    NSString *userId = [[XKAccountManager defaultManager] userId];
    @weakify(self);
    [[XKFDataService() propertyService] verifyPayPassword:password userId:userId completion:^(XKBaseResponse * _Nonnull response) {
        if (response.isSuccess) {
            @strongify(self);
            if ([response.data boolValue]) {
                [sheet dismiss];
                [self cashOut];
            }else{
                XKShowToast(@"密码错误");
            }
        }else{
            [response showError];
        }
    }];
    
}

- (void)resetPassword:(MIPaymentPaswSheet *)sheet{
    MIPwdResettingVC *controller = [[MIPwdResettingVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)propertyService:(XKPropertyService *)service deleteBankCardSuccess:(NSString *)bankId{
    NSMutableArray<XKBankData *> *banks = [NSMutableArray array];
    [self.redBagData.bankCardList enumerateObjectsUsingBlock:^(XKBankData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.id != nil && [obj.id isEqualToString:bankId] == NO) {
            [banks addObject:obj];
        }
    }];
    self.redBagData.bankCardList = banks;
    _bankData = [self.redBagData.bankCardList firstObject];
    MICashBankCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([NSString isNull:self.bankData.image]) {
        NSString *imageName = [[XKFDataService() propertyService] imageNameFromBankName:self.bankData.bankName];
        cell.imageView.image = [UIImage imageNamed:imageName];
    }else{
       [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.bankData.image] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
    }
    NSString *imageName = [[XKFDataService() propertyService] imageNameFromBankName:self.bankData.bankName];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    NSString *cardTail = nil;
    if ([self.bankData.account length] > 4) {
        cardTail = [self.bankData.account substringFromIndex:self.bankData.account.length-4];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)",self.bankData.bankName,cardTail];
    }else{
        cardTail = self.bankData.account;
        if([NSString isNull:cardTail]){
            cell.detailTextLabel.text = self.bankData.bankName;
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)",self.bankData.bankName,cardTail];
        }
    }
}


- (void)cashChanged:(NSString *)text{
    MICashBalanceCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if ([text length] > 0) {
        [cell.button setEnabled:YES];
    }else{
        [cell.button setEnabled:NO];
    }
    CGFloat fee = [text floatValue] * self.redBagData.rate *0.01;
    CGFloat cash = [text floatValue]  - fee;
    cell.textLabel.text = [NSString stringWithFormat:@"手续费:%.2f元",fee];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"实际到账: %.2f元",cash];
}

- (void)cashOut{
    if ([NSString isNull:self.bankData.account]) {
        XKShowToast(@"请选择银行卡");
        return;
    }
    
   MICashMoneyCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
   int32_t cashAmount =  floor([cell.textField.text doubleValue] * 100);
   int32_t banance =  self.redBagData.balance.intValue;
   if (cashAmount > banance) {
       XKShowToast(@"余额不足");
       return;
   }

   int32_t fee =  cashAmount * self.redBagData.rate *0.01;
   int32_t amount = cashAmount  - fee;
   
   XKCashVoParams *params = [[XKCashVoParams alloc] init];
   params.amount = amount;
   params.cashAmount = cashAmount;
   params.cashCommission = fee;
   params.cashBankCard = self.bankData.account;
   params.cashType = @"即时到账";
   params.userId = [[XKAccountManager defaultManager] userId];
   [XKLoading showNeedMask:YES];
   [[XKFDataService() propertyService] cashoutWithParams:params completion:^(XKBaseResponse * _Nonnull response) {
       [XKLoading dismiss];
       if (response.isSuccess) {
           CMPayStateVC *controller = [[CMPayStateVC alloc] initWithPayState:CMStateCashSuccess];
           [self.navigationController pushViewController:controller animated:YES];
       }else{
           [response showError];
           CMPayStateVC *controller = [[CMPayStateVC alloc] initWithPayState:CMStateCashFaild];
           [self.navigationController pushViewController:controller animated:YES];
       }
   }];
}

- (void)verifyPassword{
    MIPaymentPaswSheet *sheet = [[MIPaymentPaswSheet alloc] initWithDelegate:self];
    [sheet show];
}


#pragma mark getter or setter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.layer.cornerRadius = 5.0f;
        _tableView.estimatedRowHeight = 80.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.textColor = HexRGB(0xcccccc, 1.0f);
        _hintLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _hintLabel;
}


@end
