//
//  MIRedBagDetailInfoVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIUnsettledDetailInfoVC.h"
#import "MIRedCells.h"
#import "XKPropertyService.h"

@interface MIUnsettledDetailInfoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong)UIView *headerView;

@property (nonatomic,strong)UIView *line;

@property (nonatomic,strong)UILabel *explainLabel;

@property (nonatomic,strong)UILabel *accountLabel;

@property (nonatomic,strong,readonly)XKAmountData *amountData;

@end

@implementation MIUnsettledDetailInfoVC
@synthesize tableView = _tableView;

- (instancetype)initWithAmountData:(XKAmountData *)amountData{
    if (self = [super init]) {
        _amountData = amountData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"待结算明细详情";
    [self.view addSubview:self.tableView];
    
    [self.headerView addSubview:self.explainLabel];
    [self.headerView addSubview:self.accountLabel];
    [self.headerView addSubview:self.line];
    [self setupUI];
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 109.0f);
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20.0f)];
    self.tableView.tableFooterView.backgroundColor = HexRGB(0xffffff, 1.0f);
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.mas_equalTo(33.0f);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.mas_equalTo(self.explainLabel.mas_bottom).offset(10.0f);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(20.0f);
        make.right.equalTo(self.headerView).offset(-20.0f);
        make.height.mas_equalTo(0.5f);
        make.bottom.equalTo(self.headerView).offset(-0.5f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

- (void)setupUI{
    self.explainLabel.text  = self.amountData.businessName;
    if (self.amountData.operateType == XKOperateTypeAdd) {
        self.accountLabel.text = [NSString stringWithFormat:@"+%.2f",self.amountData.changeValue/100.00f];
    }else{
        self.accountLabel.text = [NSString stringWithFormat:@"-%.2f",self.amountData.changeValue/100.00f];
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (!cell) {
        cell = [[MIRedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identifier"];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.textLabel.textColor = HexRGB(0x444444, 1.0f);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"订单号";
        cell.detailTextLabel.text = self.amountData.refKey;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"交易时间";
        cell.detailTextLabel.text = self.amountData.createTime;
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"订单金额";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",self.amountData.changeValue/100.00f];
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"收入类型";
        cell.detailTextLabel.text = self.amountData.businessName;
    }else{
        cell.textLabel.text = @"业务类型";
        cell.detailTextLabel.text = self.amountData.moduleName;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 35.0f;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (UILabel *)explainLabel{
    if (!_explainLabel) {
        _explainLabel = [[UILabel alloc] init];
        _explainLabel.font = [UIFont systemFontOfSize:14.0f];
        _explainLabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return _explainLabel;
}

- (UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.font = [UIFont systemFontOfSize:25.0f];
        _accountLabel.textColor = HexRGB(0x444444, 1.0f);
        _accountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _accountLabel;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = HexRGB(0xffffff, 1.0f);
    }
    return _headerView;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _line;
}


@end
