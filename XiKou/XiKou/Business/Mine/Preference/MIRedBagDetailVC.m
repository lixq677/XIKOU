//
//  MIRedBagRecordVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIRedBagDetailVC.h"
#import "MIRedCells.h"
#import "MIRedBagDetailInfoVC.h"
#import "XKPropertyService.h"
#import "MJDIYFooter.h"
#import "NSDate+Extension.h"
#import "XKDatePickerView.h"
#import "XKAccountManager.h"
#import "MIRedbagSheet.h"

static const int kPageCount =   20;

@interface MIRedBagDetailVC () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong,readonly) XKAmountMonthlyTotalData *monthlyTotalData;

@property (nonatomic,strong,readonly)NSMutableArray<XKAmountData *> *amountDatas;

@property (nonatomic,assign)NSUInteger curPage;

@property (nonatomic,strong) NSDate *selectDate;

@property (nonatomic,strong) NSMutableArray<NSNumber *> *businessTypes;

@property (nonatomic,strong)XKRedbagCategoryData *categoryData;

@property (nonatomic,strong)MIRedbagSheet *sheet;

@end

@implementation MIRedBagDetailVC
@synthesize tableView = _tableView;
@synthesize amountDatas = _amountDatas;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.title = @"钱包明细";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled = NO;
    [button setTitle:@"红包明细" forState:UIControlStateNormal];
    [button setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downArrow"]];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleView addSubview:button];
    [titleView addSubview:imageView];
    [button sizeToFit];
    button.centerY = 20;
    button.centerX = titleView.width*0.5;
    imageView.left = button.right+5;
    imageView.centerY = 20;
    self.navigationItem.titleView = titleView;
    
    @weakify(self);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        if ([self.sheet isShow]) {
            [self.sheet dismiss];
        }else{
            [self.sheet showAtView:self.view];
        }

    }];
    [titleView addGestureRecognizer:tapGesture];
    
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
    XKAmountData *amountData = [self.amountDatas objectAtIndex:indexPath.row];
    cell.textLabel.text =  amountData.businessName;//[self stringByBusinessType:amountData.businessType];
    cell.detailTextLabel.text = amountData.moduleName;//[self stringByAmountModuleType:amountData.moduleId];
    cell.timeLabel.text = amountData.createTime;
    if (amountData.operateType == XKOperateTypeAdd) {
        cell.imageView.image = [UIImage imageNamed:@"yinhangka_shou"];
        cell.amountLabel.text = [NSString stringWithFormat:@"+%.2f",amountData.changeValue/100.00f];
        cell.amountLabel.textColor = HexRGB(0xf94119, 1.0f);
    }else{
        cell.imageView.image = [UIImage imageNamed:@"yinhangka_zhi"];
        cell.amountLabel.text = [NSString stringWithFormat:@"-%.2f",amountData.changeValue/100.00f];
        cell.amountLabel.textColor = HexRGB(0x444444, 1.0f);
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
   
    headerView.detailTextLabel.text = [NSString stringWithFormat:@"收¥%.2f 支¥%.2f",self.monthlyTotalData.incomeAmount/100.00f,self.monthlyTotalData.expenditureAmount/100.00f];
    headerView.contentView.backgroundColor = HexRGB(0xffffff, 1.0f);
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKAmountData *amountData = [self.amountDatas objectAtIndex:indexPath.row];
    MIRedBagDetailInfoVC *controller = [[MIRedBagDetailInfoVC alloc] initWithAmountData:amountData];
    [self.navigationController pushViewController:controller animated:YES];
}



#pragma mark action
- (void)screenIt{
    if ([self.sheet isShow]) {
        [self.sheet dismiss];
    }
    XKDatePickerView *popView = [[XKDatePickerView alloc] init];
     NSDate *sdate = self.selectDate ?:[NSDate date];
    [popView showWithTitle:@"选择月份" andSelectDate:sdate andComplete:^(NSDate * _Nonnull date) {
        if ([self.selectDate isSameWeekAsDate:date]) return;
        MIRedRecordHeaderView *headerView = (MIRedRecordHeaderView *)[self.tableView headerViewForSection:0];
        headerView.detailTextLabel.text = @"收¥0.00 支¥0.00";
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
- (void)queryMonthlyTotalStatistics {//查询红包收支月统计
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
    NSMutableString *mString = [NSMutableString string];
    [self.businessTypes enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSString isNull:mString]) {
            [mString appendFormat:@"%@",obj];
        }else{
            [mString appendFormat:@",%@",obj];
        }
    }];
    if ([NSString isNull:mString] == NO) {
        params.businessTypeList = mString;
    }

    @weakify(self);
    [[XKFDataService() propertyService] queryAccountIncomeAndExpenditurMonthlyTotalWithParams:params completion:^(XKAmountMonthlyTotalResponse * _Nonnull response) {
        @strongify(self);
        if ([response isSuccess]) {
            MIRedRecordHeaderView *headerView = (MIRedRecordHeaderView *)[self.tableView headerViewForSection:0];
            if (headerView) {
                 headerView.detailTextLabel.text = [NSString stringWithFormat:@"收¥%.2f 支¥%.2f",response.data.incomeAmount/100.00f,response.data.expenditureAmount/100.00f];
            }
            self->_monthlyTotalData = response.data;
        }else{
            [response showError];
        }
    }];
}

- (void)loadRedbagCategory{
    [[XKFDataService() propertyService] queryRedbagCategoryWithCompletion:^(XKRedbagCategoryResponse * _Nonnull response) {
        if (response.isSuccess) {
            self.categoryData = response.data;
            self.sheet.categoryData = self.categoryData;
        }else{
            [response showError];
        }
    }];
}


- (void)loadNewData{
    [self loadDataForUpdate:YES];
    [self queryMonthlyTotalStatistics];
    [self loadRedbagCategory];
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
    XKAmountParams *params = [[XKAmountParams alloc] init];
    params.page = @(page);
    params.limit = @(kPageCount);
    params.userId = [[XKAccountManager defaultManager] userId];
    NSMutableString *mString = [NSMutableString string];
    [self.businessTypes enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSString isNull:mString]) {
            [mString appendFormat:@"%@",obj];
        }else{
            [mString appendFormat:@",%@",obj];
        }
    }];
    if ([NSString isNull:mString] == NO) {
        params.businessTypeList = mString;
    }

    NSDate *date = self.selectDate ?:[NSDate date];
    params.searchTime = [date stringWithFormater_CStyle:@"%Y-%m"];
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() propertyService] queryAccountRedBagWithParams:params completion:^(XKAmountResponse * _Nonnull response) {
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

- (NSString *)stringByAmountModuleType:(XKAmountModuleType)type{
    NSString *string = nil;
    switch (type) {
        case XKAmountModuleTypeWg :
            string = @"吾G限购";
            break;
        case XKAmountModuleTypeGlobleBuyer  :
            string = @"全球买手";
            break;
        case XKAmountModuleTypeZeroBuy :
            string = @"0元抢";
            break;
        case XKAmountModuleTypeMultiBuy :
            string = @"多买多折";
            break;
        case XKAmountModuleTypeBargain :
            string = @"砍立得";
            break;
        case XKAmountModuleTypeCutomAssemble   :
            string = @"定制拼团";
            break;
        case XKAmountModuleTypeOTO  :
            string = @"O2O线下";
            break;
        case XKAmountModuleTypePaymentForOther  :
            string = @"代付";
            break;
        case XKAmountModuleTypeNewUser  :
            string = @"新人专区";
            break;
        default:
            break;
    }
    return string;
}

- (NSMutableArray<XKAmountData *> *)amountDatas{
    if(!_amountDatas){
        _amountDatas = [NSMutableArray array];
    }
    return _amountDatas;
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
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray<NSNumber *> *)businessTypes{
    if (!_businessTypes) {
        _businessTypes = [NSMutableArray array];
    }
    return _businessTypes;
}

- (MIRedbagSheet *)sheet{
    if (!_sheet) {
        _sheet = [[MIRedbagSheet alloc] init];
        @weakify(self);
        _sheet.sureBlock = ^(XKRedbagCategoryTitle *categoryTitleModel){
            @strongify(self);
            [self.businessTypes removeAllObjects];
            [self.businessTypes addObject:categoryTitleModel.id];
            [self loadNewData];
        };
    }
    return _sheet;
}

@end
