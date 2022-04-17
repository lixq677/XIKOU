//
//  MISettingVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MISettingVC.h"
#import "MIAboutVC.h"
#import "MIPwdResettingVC.h"
#import "MIProtocoVC.h"

#import "MIBasicCell.h"
#import "XKCustomAlertView.h"
#import "XKAlertController.h"

#import "XKUIUnitls.h"
#import "XKUnitls.h"
#import <UserNotifications/UserNotifications.h>
#import "XKAccountManager.h"
#import "XKUserService.h"

@interface MISettingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong,readonly)UITableView *tableView;

@property (nonatomic,strong,readonly)UISwitch *notifSwitch;

@property (nonatomic,strong,readonly)UIButton *switchBtn;

@property (nonatomic,strong,readonly)UIButton *logoutBtn;

@end

@implementation MISettingVC
@synthesize tableView = _tableView;
@synthesize notifSwitch = _notifSwitch;
@synthesize logoutBtn = _logoutBtn;
@synthesize switchBtn = _switchBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self setupUI];
    [self autoLayout];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSwitch) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark UI
- (void)setupUI{
    self.tableView.rowHeight = 60.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
    
    UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 0, kScreenWidth-30.0f, 0.5f)];
    lineBottom.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    UIView *footerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:lineBottom];
    self.tableView.tableFooterView  = footerView;
    [self.tableView registerClass:[MIBasicCell class] forCellReuseIdentifier:@"MIBasicCell"];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.logoutBtn];
    self.logoutBtn.clipsToBounds = YES;
    self.logoutBtn.layer.cornerRadius = 2.0f;
    [self.logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.logoutBtn setBackgroundColor:HexRGB(0x444444, 1.0f)];
    [[self.logoutBtn titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
    [self.logoutBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    self.logoutBtn.hidden = ![[XKAccountManager defaultManager] isLogin];

}

- (void)autoLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.equalTo(self.view).offset(-20.0f);
        make.height.mas_equalTo(40.0f);
        make.bottom.equalTo(self.view).offset(-100.0f);
    }];
    
}

- (void)swithcClick{
    
}

#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      
#if APPSTORE == 0
    return 6;
#endif
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIBasicCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.notifSwitch removeFromSuperview];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"关于喜扣";
        cell.detailTextLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"清理缓存";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[XKUnitls readCacheSize]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"我的协议";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"版本";
        cell.detailTextLabel.text = [@"v" stringByAppendingFormat:@"%@.%@",APP_VERSION,APP_BUILD];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.row == 4){
        [cell.contentView addSubview:self.notifSwitch];
        [cell.contentView addSubview:self.switchBtn];
        [self refreshSwitch];
        cell.textLabel.text = @"消息通知";
        cell.detailTextLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.row == 5) {
        cell.textLabel.text = @"环境配置";
        cell.detailTextLabel.text = [[XKNetworkConfig shareInstance] mainDomain];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
   if (indexPath.row == 3) {
       self.notifSwitch.centerY = CGRectGetMidY(cell.contentView.frame);
       self.notifSwitch.right = CGRectGetMaxX(cell.contentView.frame)-20.0f;
//       self.notifSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
       self.switchBtn.frame = self.notifSwitch.frame;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        MIAboutVC *aboutVC = [[MIAboutVC alloc] init];
//        [self.navigationController pushViewController:aboutVC animated:YES];
        [MGJRouter openURL:kRouterWeb withUserInfo:@{@"url":@"https://m.luluxk.com/about.html",@"title":@"关于喜扣"} completion:nil];
        
    }else if (indexPath.row == 1){//清理缓存
        [XKUnitls clearFile];
        [tableView reloadData];
    }else if (indexPath.row == 2){
        [self.navigationController pushViewController:[MIProtocoVC new] animated:YES];
    }else if (indexPath.row == 3){
    
    }else if (indexPath.row == 5){
        [XKLoading show];
        if ([[XKNetworkConfig shareInstance] domainEnv] == XKDomainEnvProduct ) {
            [[XKNetworkConfig shareInstance] setDomainEnv:XKDomainEnvTest];
        }else{
            [[XKNetworkConfig shareInstance] setDomainEnv:XKDomainEnvProduct];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [XKLoading dismiss];
            [tableView reloadData];
        });
    }else{
        
    }
    
}

#pragma mark action

- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)notifSwitchAction:(id)sender{
   
    //打开系统设置页面
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (void)refreshSwitch {
    @weakify(self);
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined || settings.authorizationStatus == UNAuthorizationStatusDenied){
                self.notifSwitch.on = NO;
            }else{
                self.notifSwitch.on = YES;
            }
        });
        
    }];
}


- (void)logoutAction:(id)sender{
    XKCustomAlertView *alertView = [[XKCustomAlertView alloc] initWithType:CanleNoTitle andTitle:nil andContent:@"确定退出登录吗?" andBtnTitle:@"确定"];
    @weakify(self);
    alertView.sureBlock= ^{
        NSString *userId = [[[XKAccountManager defaultManager] account] userId];
        [[XKFDataService() userService] logoutWithUserId:userId completion:^(XKBaseResponse * _Nonnull response) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    };
    [alertView show];
}

#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;

    }
    return _tableView;
}
    
- (UISwitch *)notifSwitch{
    if (!_notifSwitch) {
        _notifSwitch = [[UISwitch alloc] init];
        _notifSwitch.tintColor = HexRGB(0xc1c1c1, 1.0f);
        _notifSwitch.backgroundColor = HexRGB(0xc1c1c1, 1.0f);
        _notifSwitch.onTintColor = HexRGB(0xac8336, 1.0f);
        _notifSwitch.thumbTintColor = HexRGB(0xffffff, 1.0f);
        _notifSwitch.layer.masksToBounds = YES;
        _notifSwitch.layer.cornerRadius = 15;
    }
    return _notifSwitch;
}

- (UIButton *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBtn addTarget:self action:@selector(notifSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

- (UIButton *)logoutBtn{
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _logoutBtn;
}

@end

