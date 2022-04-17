//
//  MIRedBagVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/13.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIRedBagVC.h"
#import "XKUIUnitls.h"
#import "XKDataService.h"
#import "XKPropertyService.h"
#import "MICashOutVC.h"
#import "MIRedBagDetailVC.h"
#import "MIUnsettledDetailVC.h"
#import "MICashoutDetailVC.h"
#import "MIDealDetailVC.h"
#import "MIPwdResettingVC.h"
#import "MIVerifyVC.h"
#import "MIVerifiedVC.h"
#import "MICashAccountVC.h"
#import "XKCustomAlertView.h"
#import "MITransferAccountVC.h"

#define kCashout    1

typedef NS_ENUM(int,MIRedFuncCategory){
    MIRedFuncCategoryUnsettled           =   0,    //待收入
    MIRedFuncCategoryRedbagDetail        =   1,    //红包明细
    MIRedFuncCategoryBusiness            =   2,    //交易明细
    MIRedFuncCategoryCashout             =   3,    //提现明细
    MIRedFuncCategoryPayPwdChanged       =   4,    //支付密码修改
    MIRedFuncCategoryAccountBind         =   5,    //提现账号绑定
    MIRedFuncCategoryVerify              =   6,    //我的认证
};

@interface MIRedRows : NSObject

@property (nonatomic,assign,readonly) MIRedFuncCategory category;

@property (nonatomic,copy,readonly) NSString *text;


- (instancetype)initWithCategory:(MIRedFuncCategory)category text:(NSString *)text;

@end

@implementation MIRedRows

- (instancetype)initWithCategory:(MIRedFuncCategory)category text:(NSString *)text{
    if (self = [super init]) {
        _category = category;
        _text = text;
    }
    return self;
}

@end

@interface MIRedBagVC ()
<UITableViewDelegate,
UITableViewDataSource,
XKPropertyServiceDelegate>

@property (nonatomic,strong,readonly)UIImageView *backImageView;
@property (nonatomic,strong,readonly)UILabel *balanceHintLabel;
@property (nonatomic,strong,readonly)UILabel *balanceLabel;
@property (nonatomic,strong,readonly)UILabel *freezeLabel;
@property (nonatomic,strong,readonly)UILabel *experienceLabel;
@property (nonatomic,strong,readonly)UIButton *eyeBtn;
@property (nonatomic,strong,readonly)UIButton *cashBtn;
@property (nonatomic,strong,readonly)UIButton *transferBtn;
@property (nonatomic,strong,readonly)UITableView *tableView;

@property (nonatomic,strong)XKRedBagData *redBagData;

@property (nonatomic,strong)NSArray<MIRedRows *> *funcRows;

@end

@implementation MIRedBagVC
@synthesize backImageView = _backImageView;
@synthesize balanceHintLabel = _balanceHintLabel;
@synthesize balanceLabel = _balanceLabel;
@synthesize experienceLabel = _experienceLabel;
@synthesize freezeLabel = _freezeLabel;
@synthesize eyeBtn = _eyeBtn;
@synthesize cashBtn = _cashBtn;
@synthesize transferBtn = _transferBtn;
@synthesize tableView = _tableView;
@synthesize funcRows = _funcRows;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的钱包";
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bangzhu"] style:UIBarButtonItemStylePlain target:self action:@selector((helpAction))];
    [self initRows];
    [self setupUI];
    [self autoLayout];
    [self loadData];
    [[XKFDataService() propertyService] addWeakDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self setNavigationBarStyle:XKNavigationBarStyleTranslucent];
}

- (void)dealloc{
    [[XKFDataService() propertyService] removeWeakDelegate:self];
}

- (void)initRows{
    //MIRedRows *row1 = [[MIRedRows alloc] initWithCategory:MIRedFuncCategoryUnsettled text:@"待结算收入"];
    MIRedRows *row2 = [[MIRedRows alloc] initWithCategory:MIRedFuncCategoryRedbagDetail text:@"钱包明细"];
    MIRedRows *row5 = [[MIRedRows alloc] initWithCategory:MIRedFuncCategoryPayPwdChanged text:@"支付密码修改"];
    MIRedRows *row7 = [[MIRedRows alloc] initWithCategory:MIRedFuncCategoryVerify text:@"我的认证"];
#if kCashout
   // MIRedRows *row3 = [[MIRedRows alloc] initWithCategory:MIRedFuncCategoryBusiness text:@"交易明细"];
    MIRedRows *row4 = [[MIRedRows alloc] initWithCategory:MIRedFuncCategoryCashout text:@"提现明细"];
    MIRedRows *row6 = [[MIRedRows alloc] initWithCategory:MIRedFuncCategoryAccountBind text:@"提现账号绑定"];
    
    self.funcRows = @[row2,row4,row5,row6,row7];
#else
    self.funcRows = @[row2,row5,row7];
#endif

}

- (void)setupUI{
    
    self.navigationBarStyle = XKNavigationBarStyleTranslucent;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.view addSubview:self.backImageView];
    
    self.balanceHintLabel.text = @"余额(元)";
    self.balanceHintLabel.font = [UIFont systemFontOfSize:12.0f];
    self.balanceHintLabel.textColor = HexRGB(0x999999, 1.0f);
    [self.view addSubview:self.balanceHintLabel];
    
    self.balanceLabel.font = [UIFont systemFontOfSize:35.0f];
    self.balanceLabel.textColor = HexRGB(0xffffff, 1.0f);
    [self.view addSubview:self.balanceLabel];
    
    [self.eyeBtn setImage:[UIImage imageNamed:@"eyes_open"] forState:UIControlStateNormal];
    [self.eyeBtn setImage:[UIImage imageNamed:@"eyes_close"] forState:UIControlStateSelected];
    [self.eyeBtn addTarget:self action:@selector(eyeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.eyeBtn];
    
    self.freezeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.freezeLabel.textColor = HexRGB(0xffffff, 1.0f);
    [self.view addSubview:self.freezeLabel];
    self.experienceLabel.font = [UIFont systemFontOfSize:12.0f];
    self.experienceLabel.textColor = HexRGB(0xffffff, 1.0f);
    [self.view addSubview:self.experienceLabel];
    
    NSString *userId = [[XKAccountManager defaultManager] userId];
    BOOL hidden = NO;
    if (![NSString isNull:userId]) {
        hidden = [[XKFDataService() propertyService] amountHiddenByUserId:userId];
    }
    if (hidden) {
        self.eyeBtn.selected = YES;
        self.balanceLabel.text = @"***";
        self.freezeLabel.text = @"审核中:***元";
        self.experienceLabel.text = @"体验金额度:***元";
    }else{
        self.eyeBtn.selected = NO;
        self.balanceLabel.text = @"0.00";
        self.freezeLabel.text = @"审核中:0.00元";
        self.experienceLabel.text = @"体验金额度:0.00元";
    }
    
    [self.cashBtn addTarget:self action:@selector(cashAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cashBtn];
    
    [self.transferBtn addTarget:self action:@selector(transferAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.transferBtn];
    
#if kCashout
    self.cashBtn.hidden = NO;
#else
    self.cashBtn.hidden = YES;
#endif
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    self.tableView.contentInset = UIEdgeInsetsMake(5.0f, 0, 5.0f, 0);
    [self.view addSubview:self.tableView];
}

- (void)autoLayout{
    CGFloat y = [XKUIUnitls safeTop];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(301.0f+[XKUIUnitls safeTop]);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backImageView);
        make.height.mas_equalTo(35.0f);
        make.top.mas_equalTo(67+y);
    }];
    
    [self.eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceLabel.mas_right).offset(10.0f);
        make.centerY.mas_equalTo(self.balanceLabel);
        make.width.mas_equalTo(19.0f);
        make.height.mas_equalTo(14.0f);
    }];
    
    [self.balanceHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12.0f);
        make.top.mas_equalTo(self.balanceLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.backImageView);
    }];
    
    [self.freezeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.balanceHintLabel.mas_left).offset(10);
        make.height.mas_equalTo(17.0f);
        make.top.mas_equalTo(self.balanceHintLabel.mas_bottom).offset(16.0f);
    }];
    
    [self.experienceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceHintLabel.mas_right).offset(-10);
        make.height.mas_equalTo(17.0f);
        make.top.mas_equalTo(self.balanceHintLabel.mas_bottom).offset(16.0f);
    }];
    
    [self.cashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.experienceLabel);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(120.0f);
        make.top.mas_equalTo(self.experienceLabel.mas_bottom).offset(30);
    }];
    
    [self.transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.freezeLabel);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(120.0f);
        make.top.mas_equalTo(self.freezeLabel.mas_bottom).offset(30);
    }];
    
    CGFloat heightRef = self.funcRows.count * 50.0f + 30.0f;
    CGFloat height = kScreenHeight - 196.0f - [XKUIUnitls safeTop] - [XKUIUnitls safeBottom];
    if (height > heightRef) {
        height = heightRef;
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.equalTo(self.view).offset(-15.0f);
        make.top.equalTo(self.view).offset(256.0f+[XKUIUnitls safeTop]);
        make.height.mas_equalTo(height);
    }];
}

#pragma mark action
- (void)helpAction{
    [MGJRouter openURL:kRouterWeb withUserInfo:@{@"url":@"https://m.luluxk.com/agreement/AccountQuestion.html"} completion:nil];
}

- (void)eyeAction:(id)sender{
    NSString *userId = [[XKAccountManager defaultManager] userId];
    if (self.eyeBtn.isSelected) {//原状态闭眼，改成睁眼，余额可见
        [[XKFDataService() propertyService] setUserId:userId amountHidden:NO];
    }else{
        [[XKFDataService() propertyService] setUserId:userId amountHidden:YES];
    }
}

- (void)cashAction:(id)sender{
    /*未实名认证 实名认证*/
    if([[XKAccountManager defaultManager] isVer] == NO){
        XKShowToast(@"请先实名认证");
        [MGJRouter openURL:kRouterAuthen];
        return;
    }
    
    dispatch_block_t block = ^{
        MICashOutVC *controller = [[MICashOutVC alloc] initWithRedData:self.redBagData];
        [self.navigationController pushViewController:controller animated:YES];
    };
    
    /*已设置密码*/
    if ([[XKAccountManager defaultManager] isPayPassword]) {
        block();
        return;
    }
    [XKLoading show];
    NSString *userId = [[XKAccountManager defaultManager] userId];
    [[XKFDataService() userService] queryPaymentPasswordIsSettingWithUserId:userId completion:^(XKBaseResponse * _Nonnull response) {
        [XKLoading dismiss];
        if (response.isSuccess) {
            if([response.data isKindOfClass:[NSNumber class]] && [response.data boolValue]){
                block();
            }else{
                XKShowToast(@"请先设置支付密码");
                [self.navigationController pushViewController:[MIPwdResettingVC new] animated:YES];
            }
        }else{
            [response showError];
        }
    }];
    
    
}

- (void)transferAction:(id)sender{
    /*未实名认证 实名认证*/
       if([[XKAccountManager defaultManager] isVer] == NO){
           XKShowToast(@"请先实名认证");
           [MGJRouter openURL:kRouterAuthen];
           return;
       }
       
       dispatch_block_t block = ^{
           MITransferAccountVC *controller = [[MITransferAccountVC alloc] init];
           [self.navigationController pushViewController:controller animated:YES];
       };
       
       /*已设置密码*/
       if ([[XKAccountManager defaultManager] isPayPassword]) {
           block();
           return;
       }
       [XKLoading show];
       NSString *userId = [[XKAccountManager defaultManager] userId];
       [[XKFDataService() userService] queryPaymentPasswordIsSettingWithUserId:userId completion:^(XKBaseResponse * _Nonnull response) {
           [XKLoading dismiss];
           if (response.isSuccess) {
               if([response.data isKindOfClass:[NSNumber class]] && [response.data boolValue]){
                   block();
               }else{
                   XKShowToast(@"请先设置支付密码");
                   [self.navigationController pushViewController:[MIPwdResettingVC new] animated:YES];
               }
           }else{
               [response showError];
           }
       }];
}


//请求网络数据
- (void)loadData{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    BOOL hidden = [[XKFDataService() propertyService] amountHiddenByUserId:userId];
    @weakify(self);
    [[XKFDataService() propertyService] getRedBagWithUserId:userId completion:^(XKRedBagResponse * _Nonnull response) {
        if ([response isSuccess]) {
            @strongify(self);
            XKRedBagData *redBagData = response.data;
            self.redBagData = redBagData;
            if (hidden == NO) {
                self.eyeBtn.selected = NO;
                self.balanceLabel.text = [NSString stringWithFormat:@"%.2f",[self.redBagData.balance doubleValue]/100.00f];
                self.experienceLabel.text =  [NSString stringWithFormat:@"体验金额度:%.2f元",[self.redBagData.experienceBalance doubleValue]/100.00f];
                self.freezeLabel.text = [NSString stringWithFormat:@"审核中：%.2f元",[self.redBagData.frozen doubleValue]/100.00f];
            }
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}


#pragma mark getter
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.funcRows.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"identifier_%d",(int)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = HexRGB(0x444444, 1.0f);
        cell.separatorInset = UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.textColor = COLOR_TEXT_BROWN;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    if (indexPath.row == 0) {
//        if (self.redBagData.onWay) {
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",self.redBagData.onWay.floatValue];
//        }else{
//            cell.detailTextLabel.text = nil;
//        }
//
//    }
    MIRedRows *row = [self.funcRows objectAtIndex:indexPath.row];
    cell.textLabel.text = row.text;
    if (row.category == MIRedFuncCategoryVerify) {
        if ([[XKAccountManager defaultManager] isVer]) {
            cell.detailTextLabel.text = @"已认证";
        }else{
            cell.detailTextLabel.text = @"未认证";
        }
    }else if (row.category == MIRedFuncCategoryPayPwdChanged){
        if ([[XKAccountManager defaultManager] isPayPassword]) {
            cell.detailTextLabel.text = @"已设置";
        }else{
            cell.detailTextLabel.text = @"未设置";
        }
    }else{
        cell.detailTextLabel.text = nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([[XKAccountManager defaultManager] isLogin] == NO){
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    MIRedRows *row = [self.funcRows objectAtIndex:indexPath.row];
    switch (row.category) {
        case MIRedFuncCategoryUnsettled:{
            MIUnsettledDetailVC *controller = [[MIUnsettledDetailVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIRedFuncCategoryRedbagDetail:{
            MIRedBagDetailVC *controller = [[MIRedBagDetailVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIRedFuncCategoryBusiness:{
            MIDealDetailVC *controller = [[MIDealDetailVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIRedFuncCategoryCashout:{
            MICashoutDetailVC *controller = [[MICashoutDetailVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIRedFuncCategoryPayPwdChanged:{
            MIPwdResettingVC *controller = [[MIPwdResettingVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIRedFuncCategoryAccountBind:{
            MICashAccountVC *controller = [[MICashAccountVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIRedFuncCategoryVerify:{
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
            UIViewController *controller = nil;
            if ([[XKAccountManager defaultManager] isVer]) {//实名认证
                controller = [story instantiateViewControllerWithIdentifier:@"MIVerifiedVC"];
            }else{
                controller = [story instantiateViewControllerWithIdentifier:@"MIVerifyVC"];
            }
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)changeAmountStateWithService:(XKPropertyService *)service userId:(NSString *)userId isHidden:(BOOL)hidden{
    if (hidden) {
        self.balanceLabel.text = @"***";
        self.freezeLabel.text = @"审核中***元";
        self.eyeBtn.selected = YES;
    }else{
        self.balanceLabel.text = [NSString stringWithFormat:@"%.2f",self.redBagData.balance.doubleValue/100.00];
        self.freezeLabel.text = [NSString stringWithFormat:@"审核中：%.2f元",self.redBagData.frozen.doubleValue/100.00];
        self.eyeBtn.selected = NO;
    }
}

- (void)propertyService:(XKPropertyService *)service bindBankCardSuccess:(XKBankBindParams *)params{
    [self loadData];
}

- (void)propertyService:(XKPropertyService *)service cashoutSuccess:(XKCashVoParams *)params{
    [self loadData];
}

#pragma mark getter or setter
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    }
    return _backImageView;
}

- (UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] init];
    }
    return _balanceLabel;
}

- (UILabel *)balanceHintLabel{
    if (!_balanceHintLabel) {
        _balanceHintLabel = [[UILabel alloc] init];
    }
    return _balanceHintLabel;
}

- (UILabel *)freezeLabel{
    if (!_freezeLabel) {
        _freezeLabel = [[UILabel alloc] init];
    }
    return _freezeLabel;
}

- (UILabel *)experienceLabel{
    if (!_experienceLabel) {
        _experienceLabel = [[UILabel alloc] init];
    }
    return _experienceLabel;
}

- (UIButton *)eyeBtn{
    if (!_eyeBtn) {
        _eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _eyeBtn;
}

- (UIButton *)cashBtn{
    if (!_cashBtn) {
        _cashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cashBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_cashBtn setTitle:@"去提现" forState:UIControlStateNormal];
        [_cashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.startPoint = CGPointMake(0.87, 1.47);
        gl.endPoint = CGPointMake(0.14, -0.27);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:181/255.0 green:141/255.0 blue:60/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:195/255.0 green:160/255.0 blue:89/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        gl.cornerRadius = 2.f;
        gl.frame = CGRectMake(0, 0, 120.0f, 40.0f);
        [_cashBtn.layer insertSublayer:gl atIndex:0];
    }
    return _cashBtn;
}

- (UIButton *)transferBtn{
    if (!_transferBtn) {
        _transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _transferBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _transferBtn.layer.cornerRadius = 2.f;
        _transferBtn.layer.borderWidth = 1;
        _transferBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        [_transferBtn setTitle:@"去转账" forState:UIControlStateNormal];
        [_transferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _transferBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.layer.cornerRadius = 5.0f;
        _tableView.rowHeight = 50.0f;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


@end
