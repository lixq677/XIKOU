//
//  MineViewController.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MineViewController.h"
#import "MISettingVC.h"
#import "MIPersonalInfoVC.h"
#import "MIRedBagVC.h"
#import "MIPreferenceVC.h"
#import "MIConcernVC.h"
#import "MIAddressVC.h"
#import "MITaskVC.h"
#import "MIOrderBaseVC.h"
#import "MICanConsignOrderListVC.h"
#import "MIConsigningVC.h"
#import "MIAdvertisingVC.h"
#import "MIOtoVC.h"
#import "MISocialDataVC.h"
#import "MIMatterVC.h"
#import "MIVerifyVC.h"
#import "MIVerifiedVC.h"

#import "UIImage+XKCommon.h"
#import "XKUnitls.h"
#import "XKUIUnitls.h"
#import "MineScrollView.h"
#import "MineContentView.h"

#import <SDWebImage/UIButton+WebCache.h>
#import <MeiQiaSDK/MQManager.h>
#import "MQChatViewManager.h"
#import "NSError+XKNetwork.h"
#import "XKAccountManager.h"
#import "XKAddressService.h"
#import "XKPropertyService.h"
#import "MIOrderPayForAnotherBaseVC.h"

@interface MineViewController ()
<UIScrollViewDelegate,
MineContentViewDelegate,
XKUserServiceDelegate,
XKPropertyServiceDelegate>

@property (nonatomic,strong,readonly)NSMutableArray<MIFunctionDesc *> *functionDescs;

@property (nonatomic,strong,readonly)UIView *navigationView;//导航栏

@property (nonatomic,strong,readonly)UIButton *settingBtn;//设置

@property (nonatomic,strong,readonly)UIButton *loginBtn;//登录

@property (nonatomic,strong,readonly)UIButton *qualificationBtn;//认证

@property (nonatomic,strong,readonly)UILabel *loginHintLabel;//登录提示标签

@property (nonatomic,strong,readonly)UILabel *welcomeLabel;//登录提示标签

@property (nonatomic,strong,readonly)UILabel *redBagAmountLabel;//红包金额标签

@property (nonatomic,strong,readonly)UILabel *redBagHintLabel;//红包提示标签

@property (nonatomic,strong,readonly)UIButton *redBagBtn;//红包按钮

@property (nonatomic,strong,readonly)UILabel *preferenceAmountLabel;//优惠券数量标签

@property (nonatomic,strong,readonly)UILabel *preferenceHintLabel;//优惠券提示标签

@property (nonatomic,strong,readonly)UIButton *preferenceBtn;//优惠券按钮

@property (nonatomic,strong,readonly)UIView *spreadLine;//间隔线

@property (nonatomic,strong,readonly)UIImageView *beVipImageView;

@property (nonatomic,strong,readonly)MineScrollView *scrollView;
@property (nonatomic,strong,readonly)MineContentView *contentView;

@property (nonatomic,strong,readonly)UIButton *beVipBtn;

@property (nonatomic,strong,readonly)UIImageView *avImageView;

@property (nonatomic,strong,readonly)XKUserInfoData *userInfoData;

@end

@implementation MineViewController
@synthesize functionDescs = _functionDescs;
@synthesize navigationView = _navigationView;
@synthesize settingBtn = _settingBtn;
@synthesize loginBtn = _loginBtn;
@synthesize qualificationBtn = _qualificationBtn;
@synthesize loginHintLabel = _loginHintLabel;
@synthesize welcomeLabel = _welcomeLabel;
@synthesize redBagAmountLabel = _redBagAmountLabel;
@synthesize redBagHintLabel = _redBagHintLabel;
@synthesize redBagBtn = _redBagBtn;
@synthesize preferenceAmountLabel = _preferenceAmountLabel;
@synthesize preferenceHintLabel = _preferenceHintLabel;
@synthesize preferenceBtn = _preferenceBtn;
@synthesize spreadLine = _spreadLine;
@synthesize beVipImageView = _beVipImageView;
@synthesize beVipBtn = _beVipBtn;
@synthesize scrollView = _scrollView;
@synthesize contentView = _contentView;
@synthesize avImageView = _avImageView;
@synthesize userInfoData = _userInfoData;

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self removeNavigationBar];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupUI];
    [self initData];
    [self layout];
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    if ([[XKAccountManager defaultManager] isLogin]) {
        XKUserInfoData *userInfoData = [[XKFDataService() userService] queryUserInfoFromCacheWithId:userId];
        if (userInfoData.certification == nil) {
            userInfoData.certification = @(NO);
        }
        if (userInfoData) {
            [self.userInfoData yy_modelSetWithDictionary:[userInfoData yy_modelToJSONObject]];
        }
       // [self queryUserInfoFromServer];
    }
    [self setupWithUserInfoData];
    [self setNavigationBarStyle:XKNavigationBarStyleTranslucent];
    [[XKFDataService() userService] addWeakDelegate:self];
    [[XKFDataService() propertyService] addWeakDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if ([[XKAccountManager defaultManager] isLogin]) {
        [self queryUserInfoFromServer];
    }
}

- (void)dealloc{
    [[XKFDataService() userService] removeWeakDelegate:self];
}

- (void)initData{
    //买家
    MIFunctionDesc *zeroYuanBuyDesc = [[MIFunctionDesc alloc] init];
    zeroYuanBuyDesc.image = [UIImage imageNamed:@"0yuanpai"];
    zeroYuanBuyDesc.descText = @"0元抢";
    zeroYuanBuyDesc.functionCategory = MIFunctionCategoryZeroYuanBuy;
    
    MIFunctionDesc *multiBuyDiscountDesc = [[MIFunctionDesc alloc] init];
    multiBuyDiscountDesc.image = [UIImage imageNamed:@"duomaiduozhe"];
    multiBuyDiscountDesc.descText = @"多买多折";
    multiBuyDiscountDesc.functionCategory = MIFunctionCategoryMultiBuyDiscount;
    
    
    MIFunctionDesc *bargainDesc = [[MIFunctionDesc alloc] init];
    bargainDesc.image = [UIImage imageNamed:@"kanlide"];
    bargainDesc.descText = @"砍立得";
    bargainDesc.functionCategory = MIFunctionCategoryBargain;
    
    MIFunctionDesc *globalSellerDesc = [[MIFunctionDesc alloc] init];
    globalSellerDesc.image = [UIImage imageNamed:@"quanqiumaishou"];
    globalSellerDesc.descText = @"全球买手";
    globalSellerDesc.functionCategory = MIFunctionCategoryGlobalSeller;
    
    MIFunctionDesc *wgAreaDesc = [[MIFunctionDesc alloc] init];
    wgAreaDesc.image = [UIImage imageNamed:@"wgarea"];
    wgAreaDesc.descText = @"吾G专区";
    wgAreaDesc.functionCategory = MIFunctionCategoryWgArea;
    
//    MIFunctionDesc *assembleDesc = [[MIFunctionDesc alloc] init];
//    assembleDesc.image = [UIImage imageNamed:@"pintuan-moren"];
//    assembleDesc.descText = @"定制拼团";
//    assembleDesc.functionCategory = MIFunctionCategoryAssemble;
    
    MIFunctionDesc *nwDesc = [[MIFunctionDesc alloc] init];
    nwDesc.image = [UIImage imageNamed:@"newuser"];
    nwDesc.descText = @"新人专区";
    nwDesc.functionCategory = MIFunctionCategoryNewUser;
    
   self.contentView.buyerFuns = @[zeroYuanBuyDesc,multiBuyDiscountDesc,bargainDesc,globalSellerDesc,wgAreaDesc,/*assembleDesc,*/nwDesc];
    
    //卖家
    MIFunctionDesc *canConsignDesc = [[MIFunctionDesc alloc] init];
    canConsignDesc.image = [UIImage imageNamed:@"woyaojimai"];
    canConsignDesc.descText = @"我要寄卖";
    canConsignDesc.functionCategory = MIFunctionCategoryCanConsign;
    
    
    MIFunctionDesc *consigningDesc = [[MIFunctionDesc alloc] init];
    consigningDesc.image = [UIImage imageNamed:@"wodejimai"];
    consigningDesc.descText = @"我的寄卖";
    consigningDesc.functionCategory =  MIFunctionCategoryConsigning;
    
    MIFunctionDesc *consignedDesc = [[MIFunctionDesc alloc] init];
    consignedDesc.image = [UIImage imageNamed:@"jimaidingdan"];
    consignedDesc.descText = @"寄卖订单";
    consignedDesc.functionCategory =  MIFunctionCategoryConsigned;
    
    self.contentView.sellerFuns = @[canConsignDesc,consigningDesc,consignedDesc];
    
    
    //公共功能
    MIFunctionDesc *advertisingDesc = [[MIFunctionDesc alloc] init];
    advertisingDesc.image = [UIImage imageNamed:@"wodetuiguang"];
    advertisingDesc.descText = @"我的推广";
    advertisingDesc.functionCategory = MIFunctionCategoryAdvertising;
    
    MIFunctionDesc *taskDesc = [[MIFunctionDesc alloc] init];
    taskDesc.image = [UIImage imageNamed:@"woderenwu"];
    taskDesc.descText = @"我的任务";
    taskDesc.functionCategory = MIFunctionCategoryTask;
    
    MIFunctionDesc *addressDesc = [[MIFunctionDesc alloc] init];
    addressDesc.image = [UIImage imageNamed:@"wodedizhi"];
    addressDesc.descText = @"我的地址";
    addressDesc.functionCategory = MIFunctionCategoryAddress;
    
    MIFunctionDesc *concernDesc = [[MIFunctionDesc alloc] init];
    concernDesc.image = [UIImage imageNamed:@"wodeguanzhu"];
    concernDesc.descText = @"我的关注";
    concernDesc.functionCategory = MIFunctionCategoryConcern;
    
    MIFunctionDesc *payDesc = [[MIFunctionDesc alloc] init];
    payDesc.image = [UIImage imageNamed:@"daifu"];
    payDesc.descText = @"我的代付";
    payDesc.functionCategory = MIFunctionCategoryPayForOther;
    
    MIFunctionDesc *spendingDesc = [[MIFunctionDesc alloc] init];
    spendingDesc.image = [UIImage imageNamed:@"otoxiaofei"];
    spendingDesc.descText = @"O2O消费";
    spendingDesc.functionCategory = MIFunctionCategoryOTOSpending;
    
    MIFunctionDesc *xiKouMatterDesc = [[MIFunctionDesc alloc] init];
    xiKouMatterDesc.image = [UIImage imageNamed:@"xikousucai"];
    xiKouMatterDesc.descText = @"喜扣素材";
    xiKouMatterDesc.functionCategory = MIFunctionCategoryXiKouMatter;
    
    MIFunctionDesc *socialDataDesc = [[MIFunctionDesc alloc] init];
    socialDataDesc.image = [UIImage imageNamed:@"shejiaoliuliang"];
    socialDataDesc.descText = @"社交流量";
    socialDataDesc.functionCategory = MIFunctionCategorySocialData;
    
    MIFunctionDesc *customerDesc = [[MIFunctionDesc alloc] init];
    customerDesc.image = [UIImage imageNamed:@"lianxikefu"];
    customerDesc.descText = @"联系客服";
    customerDesc.functionCategory = MIFunctionCategoryCustomer;
    
    self.contentView.publicFuns = @[advertisingDesc,taskDesc,addressDesc,concernDesc,payDesc,spendingDesc,xiKouMatterDesc,socialDataDesc,customerDesc];
}

- (void)setupUI{
    /*渲染背景色*/
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds)*2/3.0f);
    gl.startPoint = CGPointMake(0.85, 1);
    gl.endPoint = CGPointMake(0.41, 0.03);
    gl.colors = @[(__bridge id)[HexRGB(0X444444, 1.0f) CGColor], (__bridge id)[HexRGB(0X555555, 1.0f) CGColor]];
    gl.locations = @[@(0), @(1.0f)];
    [self.view.layer addSublayer:gl];
    
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    
    /*添加子控件*/
    [self.navigationView addSubview:self.settingBtn];
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.avImageView];
    [self.view addSubview:self.loginHintLabel];
    [self.view addSubview:self.welcomeLabel];
    [self.redBagBtn addSubview:self.redBagAmountLabel];
    [self.redBagBtn addSubview:self.redBagHintLabel];
    [self.view addSubview:self.qualificationBtn];
    [self.view addSubview:self.redBagBtn];
    
    [self.view addSubview:self.spreadLine];
    
    [self.preferenceBtn addSubview:self.preferenceAmountLabel];
    [self.preferenceBtn addSubview:self.preferenceHintLabel];
    [self.preferenceBtn addTarget:self action:@selector(preferenceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.preferenceBtn];
    
    [self.view addSubview:self.beVipImageView];
    
    [self.scrollView addSubview:self.contentView];
    [self.view addSubview:self.scrollView];
    [self.qualificationBtn addTarget:self action:@selector(qualificationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    /*设置属性*/
    [self.navigationView setBackgroundColor:[UIColor clearColor]];
    [self.settingBtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    [self.settingBtn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginBtn setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 30.0f;
    self.loginBtn.clipsToBounds = YES;
    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginHintLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [self.loginHintLabel setTextColor:HexRGB(0xffffff, 1.0f)];
    [self.loginHintLabel setText:@"点击登录/注册"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.loginHintLabel addGestureRecognizer:tapGesture];
    self.loginHintLabel.userInteractionEnabled = YES;
    
    [self.welcomeLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.welcomeLabel setTextColor:HexRGB(0x999999, 1.0f)];
    [self.welcomeLabel setText:@"上喜扣 买越多赚越多"];
    
    [self.redBagAmountLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [self.redBagAmountLabel setTextColor:HexRGB(0xffffff, 1.0f)];
    
    [self.redBagHintLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.redBagHintLabel setTextColor:HexRGB(0x999999, 1.0f)];
    [self.redBagHintLabel setText:@"我的钱包"];
    
    [self.redBagBtn addTarget:self action:@selector(redBagAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.spreadLine];
    
    [self.preferenceAmountLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [self.preferenceAmountLabel setTextColor:HexRGB(0xffffff, 1.0f)];
    
    [self.preferenceHintLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.preferenceHintLabel setTextColor:HexRGB(0x999999, 1.0f)];
    [self.preferenceHintLabel setText:@"我的优惠券"];
    
    [self.preferenceBtn addTarget:self action:@selector(preferenceAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.spreadLine.backgroundColor = HexRGB(0xffffff, 0.2f);
    
    self.beVipBtn.backgroundColor =  [UIColor clearColor];
    [self.beVipBtn setTitle:@"成为会员" forState:UIControlStateNormal];
    [[self.beVipBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [self.beVipBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
    [self.beVipBtn setImage:[UIImage imageNamed:@"vip_arrow"] forState:UIControlStateNormal];
    // button标题的偏移量
    self.beVipBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0.0);
    // button图片的偏移量
      self.beVipBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 120, 0, 0);
    [self.beVipImageView addSubview:self.beVipBtn];
    
    [self.beVipBtn addTarget:self action:@selector(beVipAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.beVipImageView.backgroundColor = HexRGB(0xefe8d8, 1.0f);
    self.scrollView.backgroundColor =  [UIColor clearColor];
}

- (void)layout{
    CGFloat y = [XKUIUnitls safeTop];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(y);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44.0f);
    }];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18.0f);
        make.top.mas_equalTo(14.0f);
        make.right.mas_equalTo(self.navigationView.mas_right).offset(-20.0f);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60.0f);
        make.left.mas_equalTo(30.0f);
        make.top.mas_equalTo(y+31.0f);
    }];
    
    [self.avImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18.0f, 18.0f));
        make.top.right.equalTo(self.loginBtn);
    }];
    
    [self.loginHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginBtn.mas_right).offset(15.0f);
        make.top.mas_equalTo(y+42.0f);
        make.height.mas_equalTo(16.0f);
        make.right.mas_lessThanOrEqualTo(-80.0f);
    }];
    
    [self.qualificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginHintLabel);
        make.top.mas_equalTo(self.loginHintLabel.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(20.0f);
        make.width.mas_equalTo(45.0f);
    }];
    
    [self.welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginHintLabel);
        make.top.mas_equalTo(self.loginHintLabel.mas_bottom).mas_offset(11.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    [self.redBagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(55.0f);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).mas_offset(21.0f);
        make.width.mas_equalTo(CGRectGetWidth(self.view.bounds)/2.0f);
    }];
    
    [self.preferenceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.redBagBtn.mas_height);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).mas_offset(21.0f);
        make.width.mas_equalTo(CGRectGetWidth(self.view.bounds)/2.0f);
    }];
    
    [self.redBagAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.redBagBtn);
        make.top.mas_equalTo(10.0f);
        make.height.mas_equalTo(15.0f);
    }];
    
    [self.redBagHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.redBagAmountLabel);
        make.top.mas_equalTo(self.redBagAmountLabel.mas_bottom).mas_equalTo(5.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    [self.preferenceAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.preferenceBtn);
        make.top.mas_equalTo(10.0f);
        make.height.mas_equalTo(15.0f);
    }];
    
    [self.preferenceHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.preferenceAmountLabel);
        make.top.mas_equalTo(self.preferenceAmountLabel.mas_bottom).mas_equalTo(5.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    [self.spreadLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(29.0f);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.redBagBtn);
    }];
    
    [self.beVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.beVipImageView);
        make.height.mas_equalTo(52.0f);
    }];
    
    [self.beVipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(scalef(335.0f));
        make.height.mas_equalTo(scalef(170.0f));
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.redBagBtn.mas_bottom);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(self.scrollView);
        make.top.mas_equalTo(y+212);
        make.height.mas_equalTo(500.0f);
        make.bottom.mas_equalTo(-20);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    
}

- (void)setupWithUserInfoData{
    BOOL isLogin = [[XKAccountManager defaultManager] isLogin];
    NSString *userId = [[XKAccountManager defaultManager] userId];
    if (isLogin) {
        [self.loginBtn sd_setImageWithURL:[NSURL URLWithString:self.userInfoData.headUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang"] options:SDWebImageAvoidDecodeImage];
        self.qualificationBtn.hidden = NO;
        self.welcomeLabel.hidden = YES;
        [self.loginHintLabel setText:self.userInfoData.nickName];
        if ([self.userInfoData.certification boolValue]) {//实名认证
            [self.qualificationBtn setTitle:@"已认证" forState:UIControlStateNormal];
        }else{
            [self.qualificationBtn setTitle:@"未认证" forState:UIControlStateNormal];
        }
        self.avImageView.hidden = NO;
        [self.beVipBtn setTitle:@"会员权益" forState:UIControlStateNormal];
        
        BOOL hidden = [[XKFDataService() propertyService] amountHiddenByUserId:userId];
        if (hidden) {
            self.redBagAmountLabel.text = @"***";
        }else{
             [self.redBagAmountLabel setText:[NSString stringWithFormat:@"%.2f",[self.userInfoData.balance doubleValue]/100.00f]];
        }
        [self.preferenceAmountLabel setText:[NSString stringWithFormat:@"%@",@([self.userInfoData.couponNum intValue])]];
    }else{
        [self.loginBtn setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
        self.qualificationBtn.hidden = YES;
        self.welcomeLabel.hidden = NO;
        [self.loginHintLabel setText:@"点击登录/注册"];
        [self.welcomeLabel setText:@"上喜扣 买越多赚越多"];
        [self.preferenceAmountLabel setText:@"0"];
        BOOL hidden = [[XKFDataService() propertyService] amountHiddenByUserId:userId];
        if (hidden) {
            self.redBagAmountLabel.text = @"***";
        }else{
            [self.redBagAmountLabel setText:@"0.00"];
        }
        
        
        [self.redBagAmountLabel setText:@"0"];
        self.avImageView.hidden = YES;
        [self.beVipBtn setTitle:@"成为会员" forState:UIControlStateNormal];
    }
}


#pragma mark action
/*设置*/
- (void)settingAction:(id)sender{
    MISettingVC *controller = [[MISettingVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loginAction:(id)sender{
    if ([[XKAccountManager defaultManager] isLogin]) {
        MIPersonalInfoVC *controller = [[MIPersonalInfoVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [MGJRouter openURL:kRouterLogin];
    }
}

- (void)redBagAction:(id)sender{
    if(![[XKAccountManager defaultManager] isLogin]) {
        [MGJRouter openURL:kRouterLogin];
    }else {
        MIRedBagVC *controller = [[MIRedBagVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)preferenceAction:(id)sender{
    if(![[XKAccountManager defaultManager] isLogin]) {
        [MGJRouter openURL:kRouterLogin];
    }else {
        MIPreferenceVC *controller = [[MIPreferenceVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)qualificationAction:(id)sender{
    if(![[XKAccountManager defaultManager] isLogin]) {
        [MGJRouter openURL:kRouterLogin];
    }else {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        UIViewController *controller = nil;
        if ([self.userInfoData.certification boolValue]) {//实名认证
            controller = [story instantiateViewControllerWithIdentifier:@"MIVerifiedVC"];
        }else{
            controller = [story instantiateViewControllerWithIdentifier:@"MIVerifyVC"];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)beVipAction:(id)sender{
    if (![[XKAccountManager defaultManager] isLogin]) {
        [MGJRouter openURL:kRouterLogin];
    }
}

- (void)tapAction:(id)sender{
    if(![[XKAccountManager defaultManager] isLogin]) {
        [MGJRouter openURL:kRouterLogin];
    }
}

#pragma mark 请求用户数据
- (void)queryUserInfoFromServer{
    NSString *userId = [[XKAccountManager defaultManager] userId];
    [[XKFDataService() userService] getUserMineInfomationWithId:userId completion:^(XKUserInfoResponse * _Nonnull response) {
        if (response.isNotSuccess) {
            [response showError];
        }
    }];
}

#pragma mark user info service delegate

- (void)loginWithService:(XKUserService *)service userInfo:(XKAccountData *)data{
    //登录成功获取用户信息
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self queryUserInfoFromServer];
    });
}

- (void)logoutWithService:(XKUserService *)service userId:(NSString *)userId{//退出登录 代理
    [self setupWithUserInfoData];
}

/*查询用户基本信息*/
- (void)queryUserBasicInfoWithService:(XKUserService *)service userInfoData:(XKUserInfoData *)userInfoData{
    if (userInfoData.certification == nil) {
        userInfoData.certification = @(NO);
    }
    [self.userInfoData yy_modelSetWithDictionary:[userInfoData yy_modelToJSONObject]];
    [self setupWithUserInfoData];
}

/*查询用户我的页面信息*/
- (void)queryUserMineInfoWithService:(XKUserService *)service userInfoData:(XKUserInfoData *)userInfoData{
    if (userInfoData.certification == nil) {
        userInfoData.certification = @(NO);
    }
    [self.userInfoData yy_modelSetWithDictionary:[userInfoData yy_modelToJSONObject]];
    [self setupWithUserInfoData];
}

- (void)modifyWithSevice:(XKUserService *)service userInfomation:(XKModifyUserVoParams *)params userId:(NSString *)userId{
    [self queryUserInfoFromServer];
}

- (void)verifySuccessWithSevice:(XKUserService *)service userId:(NSString *)userId{
    if (NO == [NSString isNull:userId] && [[[XKAccountManager defaultManager] userId] isEqualToString:userId]) {
        [self.qualificationBtn setTitle:@"已认证" forState:UIControlStateNormal];
    }
}

- (void)changeAmountStateWithService:(XKPropertyService *)service userId:(NSString *)userId isHidden:(BOOL)hidden{
    if (hidden) {
        self.redBagAmountLabel.text = @"***";
    }else{
       [self.redBagAmountLabel setText:[NSString stringWithFormat:@"%.2f",[self.userInfoData.balance doubleValue]/100.00f]];
    }
}


#pragma mark scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"y:%f",scrollView.contentOffset.y);
    CGFloat offsetY = scrollView.contentOffset.y;
    /*设置最大拖拽*/
    CGFloat Y = scalef(170.0f)-50.0f;
    if(offsetY < -Y){
        scrollView.contentOffset = CGPointMake(0, -Y);
    }else if (offsetY > scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds) + 70){
        scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds) + 70.0f);
    }
    if (offsetY < 0) {
        CGFloat scaleX = fabs(offsetY/3000.0f);
        CGFloat scaleY = fabs(offsetY/1500.0f);
        self.beVipImageView.transform = CGAffineTransformMakeScale(1+scaleX, 1+scaleY);
    }else{
        self.beVipImageView.transform = CGAffineTransformIdentity;
    }
    
}

#pragma mark MineContentViewDelegate

- (void)contentView:(MineContentView *)view functionCategory:(MIFunctionCategory)gategory {
    if(![[XKAccountManager defaultManager] isLogin]) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    switch (gategory) {
        case MIFunctionCategoryZeroYuanBuy:{
            MIOrderBaseVC *vc = [[MIOrderBaseVC alloc] initWithType:OTZeroBuy];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MIFunctionCategoryMultiBuyDiscount:{
            MIOrderBaseVC *vc = [[MIOrderBaseVC alloc] initWithType:OTDiscount];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MIFunctionCategoryBargain:{
            MIOrderBaseVC *vc = [[MIOrderBaseVC alloc] initWithType:OTBargain];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MIFunctionCategoryGlobalSeller:{
            MIOrderBaseVC *vc = [[MIOrderBaseVC alloc] initWithType:OTGlobalSeller];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MIFunctionCategoryWgArea:{
            MIOrderBaseVC *vc = [[MIOrderBaseVC alloc] initWithType:OTWug];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MIFunctionCategoryAssemble:{
            MIOrderBaseVC *vc = [[MIOrderBaseVC alloc] initWithType:OTCustom];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MIFunctionCategoryNewUser:{
            MIOrderBaseVC *vc = [[MIOrderBaseVC alloc] initWithType:OTNewUser];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MIFunctionCategoryConsigned:{
            MIOrderBaseVC *vc = [[MIOrderBaseVC alloc] initWithType:OTConsigned];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MIFunctionCategoryCanConsign:{
            MICanConsignOrderListVC *vc = [[MICanConsignOrderListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MIFunctionCategoryConsigning:{
            MIConsigningVC *vc = [[MIConsigningVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MIFunctionCategoryAdvertising:{
            MIAdvertisingVC *controller = [[MIAdvertisingVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIFunctionCategoryTask:{
            MITaskVC *controller = [[MITaskVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIFunctionCategoryAddress:{
            MIAddressVC *controller = [[MIAddressVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIFunctionCategoryConcern:{
            MIConcernVC *controller = [[MIConcernVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIFunctionCategoryPayForOther:{//代付
            MIOrderPayForAnotherBaseVC *controller = [[MIOrderPayForAnotherBaseVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIFunctionCategoryOTOSpending:{
            MIOtoVC *controller = [[MIOtoVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIFunctionCategoryXiKouMatter:{
            MIMatterVC *controller = [[MIMatterVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIFunctionCategorySocialData:{
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
            MISocialDataVC *controller = [story instantiateViewControllerWithIdentifier:@"MISocialDataVC"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case MIFunctionCategoryCustomer:{
            [MGJRouter openURL:kRouterCustomer];
        }
            break;
        default:
            break;
    }
}


#pragma mark getter or setter

- (NSMutableArray<MIFunctionDesc *> *)functionDescs{
    if (!_functionDescs) {
        _functionDescs = [NSMutableArray array];
    }
    return _functionDescs;
}

- (UIView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[UIView alloc] init];
    }
    return _navigationView;
}

- (UIButton *)settingBtn{
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _settingBtn;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _loginBtn;
}

- (UIButton *)qualificationBtn{
    if (!_qualificationBtn) {
        _qualificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _qualificationBtn.layer.cornerRadius = 10.0f;
        _qualificationBtn.layer.borderWidth = 0.5f;
        _qualificationBtn.layer.borderColor = [HexRGB(0xffffff, 0.3f) CGColor];
        _qualificationBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _qualificationBtn;
}

- (UILabel *)loginHintLabel{
    if (!_loginHintLabel) {
        _loginHintLabel = [[UILabel alloc] init];
    }
    return _loginHintLabel;
}

- (UILabel *)welcomeLabel{
    if (!_welcomeLabel) {
        _welcomeLabel = [[UILabel alloc] init];
    }
    return _welcomeLabel;
}

- (UILabel *)redBagAmountLabel{
    if (!_redBagAmountLabel) {
        _redBagAmountLabel = [[UILabel alloc] init];
    }
    return _redBagAmountLabel;
}

- (UILabel *)redBagHintLabel{
    if (!_redBagHintLabel) {
        _redBagHintLabel = [[UILabel alloc] init];
    }
    return _redBagHintLabel;
}

- (UIButton *)redBagBtn{
    if (!_redBagBtn) {
        _redBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _redBagBtn;
}

- (UILabel *)preferenceAmountLabel{
    if (!_preferenceAmountLabel) {
        _preferenceAmountLabel = [[UILabel alloc] init];
    }
    return _preferenceAmountLabel;
}

- (UILabel *)preferenceHintLabel{
    if (!_preferenceHintLabel) {
        _preferenceHintLabel = [[UILabel alloc] init];
    }
    return _preferenceHintLabel;
}

- (UIButton *)preferenceBtn{
    if (!_preferenceBtn) {
        _preferenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _preferenceBtn;
}

- (UIView *)spreadLine{
    if (!_spreadLine) {
        _spreadLine = [[UIView alloc] init];
    }
    return _spreadLine;
}

- (UIImageView *)beVipImageView{
    if (!_beVipImageView) {
        _beVipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"members"]];
        _beVipImageView.layer.cornerRadius = 5.0f;
        _beVipImageView.clipsToBounds = YES;
        _beVipImageView.userInteractionEnabled = YES;
    }
    return _beVipImageView;
}

- (UIImageView *)avImageView{
    if (!_avImageView) {
        _avImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip"]];
        _avImageView.layer.cornerRadius = 9.0f;
        _avImageView.clipsToBounds = YES;
        _avImageView.hidden = YES;
    }
    return _avImageView;
}

- (UIButton *)beVipBtn{
    if (!_beVipBtn) {
        _beVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _beVipBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _beVipBtn;
}

- (MineScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[MineScrollView alloc] init];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (MineContentView *)contentView{
    if (!_contentView) {
        _contentView = [[MineContentView alloc] init];
        _contentView.delegate = self;
    }
    return _contentView;
}

- (XKUserInfoData *)userInfoData{
    if (!_userInfoData) {
        _userInfoData = [[XKUserInfoData alloc] init];
    }
    return _userInfoData;
}


@end

