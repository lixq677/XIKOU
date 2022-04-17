//
//  MIUnsettledDetailVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIUnsettledDetailVC.h"
#import "MIUnsettledDetailInfoVC.h"
#import "XKPropertyService.h"
#import "MIRedCells.h"
#import "MJDIYFooter.h"
#import "XKAccountManager.h"

static const int kPageCount =   20;

@interface MIUnsettledDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,assign)NSUInteger curPage;

@property (nonatomic,strong,readonly)NSMutableArray<XKAmountData *> *amountDatas;

@end

@implementation MIUnsettledDetailVC
@synthesize tableView = _tableView;
@synthesize amountDatas = _amountDatas;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"待结算明细";
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MIRedCell class] forCellReuseIdentifier:@"MIRedCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

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
    XKAmountData *amountData = [self.amountDatas objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"ic_redbag"];
    cell.textLabel.text = amountData.businessName;
    cell.detailTextLabel.text = amountData.moduleName;
    cell.timeLabel.text = amountData.createTime;
    if (amountData.operateType == XKOperateTypeAdd) {
        cell.amountLabel.text = [NSString stringWithFormat:@"+%.2f",amountData.changeValue/100.00f];
        cell.amountLabel.textColor = HexRGB(0xf94119, 1.0f);
    }else{
        cell.amountLabel.text = [NSString stringWithFormat:@"-%.2f",amountData.changeValue/100.00f];
        cell.amountLabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKAmountData *amountData = [self.amountDatas objectAtIndex:indexPath.row];
    MIUnsettledDetailInfoVC *controller = [[MIUnsettledDetailInfoVC alloc] initWithAmountData:amountData];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loadNewData{
    [self loadDataForUpdate:YES];
}


- (void)loadMoreData{
    [self loadDataForUpdate:NO];
}


//请求网络数据
- (void)loadDataForUpdate:(BOOL)update{
    NSUInteger page = 1;
    if (!update) {
        page = self.curPage + 1;
    }
    XKAmountParams *params = [[XKAmountParams alloc] init];
    params.page = @(page);
    params.limit = @(kPageCount);
    params.userId = [[XKAccountManager defaultManager] userId];
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() propertyService] queryAccountUnSettledWithParams:params completion:^(XKAmountResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([response isSuccess]) {
            NSArray<XKAmountData *> *results = response.data;
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

#pragma mark 私有方法

- (NSString *)stringByBusinessType:(XKBusinessType)businessType{
    NSString *string = nil;
    switch (businessType) {
        case XKBusinessTypeShareBenefit:
            string = @"平台分润";
            break;
        case XKBusinessTypeRedBagUse:
            string = @"使用钱包";
            break;
        case XKBusinessTypeManagerFee:
            string = @"管理费";
            break;
        case XKBusinessTypeRedBagCash:
            string = @"钱包提现";
            break;
        case XKBusinessTypeRedBagCharge:
            string = @"提现手续费";
            break;
        case XKBusinessTypeClusterRefund:
            string = @"拼团退款";
            break;
        case XKBusinessTypeTransport:
            string = @"购物";
            break;
        case XKBusinessTypePaymentExpenditure:
            string = @"代付支出";
            break;
        case XKBusinessTypePaymentIncome:
            string = @"代付收入";
            break;
        case XKBusinessTypePaymentBraign:
            string = @"砍立得收入";
            break;
        case XKBusinessTypePaymentConsignSale:
            string = @"寄卖收入";
            break;
        default:
            break;
    }
    return string;
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

- (NSMutableArray<XKAmountData *> *)amountDatas{
    if (!_amountDatas) {
        _amountDatas = [NSMutableArray array];
    }
    return _amountDatas;
}

@end
