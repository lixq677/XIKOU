//
//  MIProtocoVC.m
//  XiKou
//
//  Created by L.O.U on 2019/8/14.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIProtocoVC.h"
#import "XKWebViewController.h"

@interface MIProtocoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation MIProtocoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的协议";
    [self setupUI];
}

#pragma mark UI
- (void)setupUI{
    self.tableView.rowHeight = 60.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
    self.tableView.tableFooterView = [UIView new];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font   = Font(15.f);
    cell.textLabel.textColor = COLOR_TEXT_BLACK;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"寄卖协议";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"用户服务协议";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        XKWebViewController *webVC = [[XKWebViewController alloc]initWithURL:[NSURL URLWithString:@"https://m.luluxk.com/agreement/sales.html"]];
        webVC.title = @"寄卖协议";
        [self.navigationController pushViewController:webVC animated:YES];
    }else{
        XKWebViewController *webVC = [[XKWebViewController alloc]initWithURL:[NSURL URLWithString:@"https://m.luluxk.com/agreement/service.html"]];
        webVC.title = @"用户服务协议";
        [self.navigationController pushViewController:webVC animated:YES];
    }
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
@end
