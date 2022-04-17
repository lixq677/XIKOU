//
//  MIReferrerInfoVC.m
//  XiKou
//
//  Created by L.O.U on 2019/8/14.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIReferrerInfoVC.h"
#import "XKUserService.h"

@interface MIReferrerInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XKReferrerData *refrrrerData;

@end

@implementation MIReferrerInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推荐人信息";
    [self setupUI];
    [self getReferrerInfo];
}

#pragma mark UI
- (void)setupUI{
    self.tableView.rowHeight = 60.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
    self.tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
}
- (void)accessoryViewTapAction {
    NSString *mobile = self.refrrrerData.invitationMobile ? self.refrrrerData.invitationMobile : @"";
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
}
- (void)getReferrerInfo{
    [[XKFDataService() userService]getReferrerInfoWithUserId:[XKAccountManager defaultManager].account.userId completion:^(XKReferrerResponse * _Nonnull response) {
        if ([response isSuccess]) {
            self.refrrrerData = response.data;
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}

#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle   = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = COLOR_PRICE_GRAY;
        cell.detailTextLabel.font = Font(14.f);
        cell.textLabel.font   = Font(15.f);
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
    }
    if (indexPath.row == 0) {
        cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *accessoryView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 60)];
        accessoryView.image        = [UIImage imageNamed:@"phone"];
        accessoryView.contentMode  = UIViewContentModeRight;
        accessoryView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accessoryViewTapAction)];
        [accessoryView addGestureRecognizer:tap];
        cell.accessoryView         = accessoryView;
        cell.textLabel.text = @"推荐人联系电话";
        NSString *mobile = self.refrrrerData.invitationMobile ? self.refrrrerData.invitationMobile : @"";
        cell.detailTextLabel.text = mobile;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"所属城市运营商联系电话";
        NSString *mobile = self.refrrrerData.mobile ? [NSString stringWithFormat:@"%@  ",self.refrrrerData.mobile] : @"";
        if (mobile.length > 10) {
          mobile = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        cell.detailTextLabel.text = mobile;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 0) {
//        XKWebViewController *webVC = [[XKWebViewController alloc]initWithURL:[NSURL URLWithString:@"https://m.luluxk.com/agreement/sales.html"]];
//        webVC.title = @"寄卖协议";
//        [self.navigationController pushViewController:webVC animated:YES];
//    }else{
//        XKWebViewController *webVC = [[XKWebViewController alloc]initWithURL:[NSURL URLWithString:@"https://m.luluxk.com/agreement/service.html"]];
//        webVC.title = @"用户服务协议";
//        [self.navigationController pushViewController:webVC animated:YES];
//    }
}

#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

@end
