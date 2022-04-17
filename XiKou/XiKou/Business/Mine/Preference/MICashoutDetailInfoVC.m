//
//  MICashoutDetailInfoVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MICashoutDetailInfoVC.h"
#import "MIRedCells.h"
#import "XKPropertyService.h"

@interface MICashoutDetailInfoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong)UIView *headerView;

@property (nonatomic,strong)UIView *line;

@property (nonatomic,strong)UILabel *explainLabel;

@property (nonatomic,strong)UILabel *accountLabel;

@property (nonatomic,strong)UILabel *statusLabel;

@property (nonatomic,strong,readonly)XKCashOutData *cashoutData;

@property (nonatomic,strong,readonly)XKCashOutDetailData *cashoutDetailData;

@property (nonatomic,strong,readonly)NSArray<NSString *> *keys;

@end

@implementation MICashoutDetailInfoVC
@synthesize tableView = _tableView;

- (instancetype)initWithCashOutData:(XKCashOutData *)cashoutData{
    if (self = [super init]) {
        _cashoutData = cashoutData;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现明细详情";
    [self.view addSubview:self.tableView];
    
    [self.headerView addSubview:self.explainLabel];
    [self.headerView addSubview:self.accountLabel];
    [self.headerView addSubview:self.line];
    [self.headerView addSubview:self.statusLabel];
    [self setupUI];
    [self dealData];
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 145.0f);
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
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.mas_equalTo(self.accountLabel.mas_bottom).offset(13.0f);
        make.width.mas_equalTo(50.0f);
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
    [self queryDetail];
}

- (void)setupUI{
    self.explainLabel.text = @"提现金额";
    self.accountLabel.text = [NSString stringWithFormat:@"%.2f",self.cashoutData.cashAmount/100.00];
    if (self.cashoutData.state == XKAmountCashStatusApproving || self.cashoutData.state == XKAmountCashStatusWillCash) {
           self.statusLabel.text = @"到账中";
    }else if (self.cashoutData.state == XKAmountCashStatusArrived){
        self.statusLabel.text = @"已到账";
    }else{
        self.statusLabel.text = @"提现失败";
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.keys.count;
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
    NSString *text = [self.keys objectAtIndex:indexPath.row];
    cell.textLabel.text = text;
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = self.cashoutDetailData.cashTime;
    }else if (indexPath.row == 1){
        cell.detailTextLabel.text = self.cashoutDetailData.cashBankCard;
    }else if (indexPath.row == 2){
        cell.detailTextLabel.text = self.cashoutDetailData.cashType;
    }else if (indexPath.row == 3){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",self.cashoutDetailData.cashCommission/100.00f];
    }else if (indexPath.row == 4){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",self.cashoutDetailData.amount/100.00f];
    }else{
        if ([text isEqualToString:@"实际到账时间"] || [text isEqualToString:@"更新时间"]) {
            cell.detailTextLabel.text = self.cashoutDetailData.updateTime;
        }else{
            cell.detailTextLabel.text = self.cashoutDetailData.cashContent;
        }
        
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)queryDetail{
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() propertyService] queryAccountCashoutDetailWithId:self.cashoutData.cashId completion:^(XKCashOutDetailResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if (response.isSuccess) {
            self->_cashoutDetailData = response.data;
            [self dealData];
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}

- (void)dealData{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:@[@"申请提现时间",@"提现账户",@"提现类型",@"手续费",@"实际到账金额"]];
    if (![NSString isNull:self.cashoutDetailData.updateTime]) {
        if(self.cashoutDetailData.state == XKAmountCashStatusArrived){
            [array addObject:@"实际到账时间"];
        }else if(self.cashoutDetailData.state == XKAmountCashStatusFailed){
            [array addObject:@"更新时间"];
        }
    }
    if (![NSString isNull:self.cashoutDetailData.cashContent]) {
        [array addObject:@"失败原因"];
    }
    _keys = array;
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

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.layer.cornerRadius = 1.0f;
        _statusLabel.textColor = COLOR_TEXT_BROWN;
        _statusLabel.font = [UIFont systemFontOfSize:12.0f];
        _statusLabel.layer.borderWidth = 0.5f;
        _statusLabel.layer.borderColor = COLOR_TEXT_BROWN.CGColor;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}


@end
