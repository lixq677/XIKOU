//
//  MICashoutDetailVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MICashoutDetailVC.h"
#import "MIRedCells.h"
#import "MICashoutDetailInfoVC.h"
#import "XKPropertyService.h"
#import "MJDIYFooter.h"
#import "NSDate+Extension.h"
#import "XKDatePickerView.h"
#import "XKAccountManager.h"

static const int kPageCount =   20;

@interface MICashoutDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong,readonly) XKAmountMonthlyTotalData *monthlyTotalData;

@property (nonatomic,strong,readonly)NSMutableArray<XKCashOutData *> *amountDatas;

@property (nonatomic,assign)NSUInteger curPage;

@property (nonatomic,strong) NSDate *selectDate;

@end

@implementation MICashoutDetailVC
@synthesize tableView = _tableView;
@synthesize amountDatas = _amountDatas;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现明细";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(screenIt)];
    [self.view addSubview:self.tableView]; 
    
    [self.tableView registerClass:[MIRedCell class] forCellReuseIdentifier:@"MIRedCell"];
    [self.tableView registerClass:[MIRedRecordHeaderView class] forHeaderFooterViewReuseIdentifier:@"MIRedRecordHeaderView"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self loadNewData];
}


#pragma mark tableview 代理和数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.amountDatas.count >= kPageCount) {
        tableView.mj_footer.hidden = NO;
    }else{
        tableView.mj_footer.hidden = YES;
    }
    return self.amountDatas.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIRedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIRedCell" forIndexPath:indexPath];
    XKCashOutData *amountData = [self.amountDatas objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"ic_redbag"];
    cell.textLabel.text = [NSString stringWithFormat:@"提现金额:%.2f",amountData.cashAmount/100.00f];
    NSString *card = nil;
    if (amountData.cashBankCard.length > 4) {
        card = [amountData.cashBankCard substringFromIndex:amountData.cashBankCard.length-4];
    }else{
        card = amountData.cashBankCard;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"银行卡尾号:%@",card];
    cell.timeLabel.text = amountData.cashTime;
    if (amountData.state == XKAmountCashStatusApproving || amountData.state == XKAmountCashStatusWillCash) {
        cell.amountLabel.text = @"到账中";
        cell.amountLabel.textColor = HexRGB(0x444444, 1.0f);
        cell.amountLabel.font = [UIFont systemFontOfSize:15.0f];
    }else if (amountData.state == XKAmountCashStatusArrived){
        cell.amountLabel.text = @"已到账";
        cell.amountLabel.textColor = HexRGB(0xcccccc, 1.0f);
        cell.amountLabel.font = [UIFont systemFontOfSize:15.0f];
    }else{
        cell.amountLabel.text = @"提现失败";
        cell.amountLabel.textColor = HexRGB(0xf94119, 1.0f);
        cell.amountLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MIRedRecordHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MIRedRecordHeaderView"];
    NSDate *date = self.selectDate ?:[NSDate date];
    if ([date isThisMonth]) {
        headerView.textLabel.text = @"本月";
    }else if ([date isThisYear]){
        NSString *dateString = [date stringWithFormater_CStyle:@"%m月"];
        headerView.textLabel.text = dateString;
    }else{
        NSString *dateString = [date stringWithFormater_CStyle:@"%Y年-%m月"];
        headerView.textLabel.text = dateString;
    }
    headerView.detailTextLabel.text = [NSString stringWithFormat:@"已提现¥%.2f 提现中¥%.2f",self.monthlyTotalData.haveCashAmount/100.00f,self.monthlyTotalData.onWayAmount/100.00f];
    headerView.contentView.backgroundColor = HexRGB(0xffffff, 1.0f);
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKCashOutData *cashOutData = [self.amountDatas objectAtIndex:indexPath.row];
    MICashoutDetailInfoVC *controller = [[MICashoutDetailInfoVC alloc] initWithCashOutData:cashOutData];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark action
- (void)screenIt{
    XKDatePickerView *popView = [[XKDatePickerView alloc] init];
    NSDate *sdate = self.selectDate ?:[NSDate date];
    [popView showWithTitle:@"选择月份" andSelectDate:sdate andComplete:^(NSDate * _Nonnull date) {
        if ([self.selectDate isSameWeekAsDate:date]) return;
        MIRedRecordHeaderView *headerView = (MIRedRecordHeaderView *)[self.tableView headerViewForSection:0];
        headerView.detailTextLabel.text = [NSString stringWithFormat:@"已提现¥%.2f 提现中¥%.2f",0.00f,0.00f];
        if ([date isThisMonth]) {
            headerView.textLabel.text = @"本月";
        }else if ([date isThisYear]){
            NSString *dateString = [date stringWithFormater_CStyle:@"%m月"];
            headerView.textLabel.text = dateString;
        }else{
            NSString *dateString = [date stringWithFormater_CStyle:@"%Y年-%m月"];
            headerView.textLabel.text = dateString;
        }
        self.selectDate = date;
        [self loadNewData];
    }];
}


#pragma mark 向服务器请求
- (void)queryMonthlyTotalStatistics {//查询提现月统计
    XKAmountMonthlyTotalParams *params = [[XKAmountMonthlyTotalParams alloc] init];
    NSString *userId = [[XKAccountManager defaultManager] userId];
    if ([NSString isNull:userId]) return;
    
    NSString *searchTime = nil;
    if (self.selectDate) {
        searchTime = [self.selectDate stringWithFormater_CStyle:@"%Y-%m"];
    }else{
        searchTime =  [[NSDate date] stringWithFormater_CStyle:@"%Y-%m"];
    }
    params.userId = userId;
    params.searchTime = searchTime;
    @weakify(self);
    [[XKFDataService() propertyService] queryAccountCashoutMonthlyTotalWithParams:params completion:^(XKAmountMonthlyTotalResponse * _Nonnull response) {
        @strongify(self);
        if ([response isSuccess]) {
            self->_monthlyTotalData = response.data;
            [self.tableView reloadData];
            
        }else{
            [response showError];
        }
    }];
}


- (void)loadNewData{
    [self loadDataForUpdate:YES];
    [self queryMonthlyTotalStatistics];
}


- (void)loadMoreData{
    [self loadDataForUpdate:NO];
}


//请求红包明细数据
- (void)loadDataForUpdate:(BOOL)update{
    NSUInteger page = 1;
    if (!update) {
        page = self.curPage + 1;
    }
    XKCashOutParams *params = [[XKCashOutParams alloc] init];
    params.page = @(page);
    params.limit = @(kPageCount);
    params.userId = [[XKAccountManager defaultManager] userId];
    NSDate *date = self.selectDate ?:[NSDate date];
    params.cashTime = [date stringWithFormater_CStyle:@"%Y-%m"];
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() propertyService] queryAccountCashoutWithParams:params completion:^(XKCashOutResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([response isSuccess]) {
            NSArray<XKCashOutData *> *results = response.data;
            //刷新数据时，需要清理旧的数据
            if (update) {
                [self.amountDatas removeAllObjects];
            }
            self.curPage = page;
            [self.amountDatas addObjectsFromArray:results];
            [self.tableView reloadData];
            if (results.count < kPageCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            if(!update){
                [self.tableView.mj_footer endRefreshing];
            }
            [response showError];
        }
    }];
}


#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 120.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
        _tableView.ly_emptyView = [XKEmptyView amountListNoDataView];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray<XKCashOutData *> *)amountDatas{
    if (!_amountDatas) {
        _amountDatas = [NSMutableArray array];
    }
    return _amountDatas;
}


@end
