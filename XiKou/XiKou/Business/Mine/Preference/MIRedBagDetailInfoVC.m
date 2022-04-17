//
//  MIRedBagDetailInfoVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIRedBagDetailInfoVC.h"
#import "MIRedCells.h"
#import "XKPropertyService.h"

@interface MIRedBagDetailInfoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong)UIView *headerView;

@property (nonatomic,strong)UIView *line;

@property (nonatomic,strong)UILabel *explainLabel;

@property (nonatomic,strong)UILabel *accountLabel;

@property (nonatomic,strong,readonly)XKAmountData *amountData;

@end

@implementation MIRedBagDetailInfoVC
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
    self.title = @"钱包明细详情";
    [self.view addSubview:self.tableView];
    if(self.amountData.operateType == XKOperateTypeAdd){
        self.accountLabel.text = [NSString stringWithFormat:@"+%.2f",self.amountData.changeValue/100.0f];
    }else{
        self.accountLabel.text = [NSString stringWithFormat:@"-%.2f",self.amountData.changeValue/100.0f];
    }
    self.explainLabel.text = self.amountData.businessName;
    
    [self.headerView addSubview:self.explainLabel];
    [self.headerView addSubview:self.accountLabel];
    [self.headerView addSubview:self.line];
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 109.0f);
    self.tableView.tableHeaderView = self.headerView;
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
    [self query];
}

- (void)query{
    [XKLoading show];
    XKRedPacketDetailParams *params = [[XKRedPacketDetailParams alloc] init];
    params.id = self.amountData.id;
    params.refKey = self.amountData.refKey;
    @weakify(self);
    [[XKFDataService() propertyService] queryRedPacketDetailWithParams:params completion:^(XKRedPacketDetailResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if (response.isSuccess) {
            self->_amountData = response.data;
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.amountData.businessType == XKBusinessTypeTransport) {
        return 7;
    }else{
        return 4;
    }
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
     if (self.amountData.businessType == XKBusinessTypeTransport) {
          if (indexPath.row == 0) {
              cell.textLabel.text = @"订单号";
              cell.detailTextLabel.text = self.amountData.refKey;
          }else if (indexPath.row == 1){
              cell.textLabel.text = @"交易时间";
              cell.detailTextLabel.text = self.amountData.createTime;
          }else if (indexPath.row == 2){
              cell.textLabel.text = @"转账金额";
              cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",self.amountData.changeValue/100.00f];
          }else if (indexPath.row == 3){
            cell.textLabel.text = @"转账类型";
            cell.detailTextLabel.text = self.amountData.moduleName;
          }else if (indexPath.row == 4){
              cell.textLabel.text = @"到账时间";
              cell.detailTextLabel.text = self.amountData.createTime;
         }else if (indexPath.row == 5){
             cell.textLabel.text = @"收账账号";
             cell.detailTextLabel.text = self.amountData.transferUserName;
         }else if (indexPath.row == 6){
             cell.textLabel.text = @"付款说明";
             cell.detailTextLabel.text = self.amountData.remark;
          }else{
              
          }

     }else{
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
             cell.textLabel.text = @"支持类型";
             cell.detailTextLabel.text = self.amountData.moduleName;
         }else{
             
         }
     }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 35.0f;
    }else{
        return 45.0f;
    }
}

#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //_tableView.rowHeight = 35.0f;
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
