//
//  MIBankChooseVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIBankChooseVC.h"
#import "XKUIUnitls.h"
#import "MIBankInfoVC.h"

@interface MIBankChooseVC ()<UITableViewDelegate,UITableViewDataSource>
    
@property (strong, nonatomic) UITableView *tableView;
    
@end

@implementation MIBankChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
//    [self creatNavigation];

    self.title = @"选择账号类型";
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
}

- (void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = Font(14.f);
        cell.textLabel.textColor = COLOR_TEXT_BLACK;
        cell.detailTextLabel.font = Font(12.f);
        cell.detailTextLabel.textColor = COLOR_TEXT_GRAY;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"微信账号";
        cell.detailTextLabel.text = @"只能绑定实名认证同名账号";
        cell.imageView.image = [UIImage imageNamed:@"cash_wexin"];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"支付宝账号";
        cell.detailTextLabel.text = @"只能绑定实名认证同名账号";
        cell.imageView.image = [UIImage imageNamed:@"cash_zhifubao"];
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"银行卡-个人账号 ";
        cell.detailTextLabel.text = @"";
        cell.imageView.image = [UIImage imageNamed:@"yinhangka"];
    }else{
        cell.textLabel.text = @"银行卡-对公账号 ";
        cell.detailTextLabel.text = @"";
        cell.imageView.image = [UIImage imageNamed:@"cash_yinhangka"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKBankChannel channel = XKBankChannelBank;
    if (indexPath.row == 0) {
        channel = XKBankChannelWexin;
    }else if (indexPath.row == 1){
        channel = XKBankChannelZhifubao;
    }else if (indexPath.row == 2){
        channel = XKBankChannelBank;
    }
    MIBankInfoVC *controller = [[MIBankInfoVC alloc] initWithBankChannel:channel];
    [self.navigationController pushViewController:controller animated:YES];
        
}

- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.rowHeight      = 60;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 20);
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
@end
