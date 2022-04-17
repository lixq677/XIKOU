//
//  CTCustomGroupChildVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CTCustomGroupChildVC.h"
#import "CTBaseCell.h"
#import "MJDIYFooter.h"
#import "XKWeakDelegate.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKUserService.h"
#import "XKActivityService.h"
#import "MJDIYHeader.h"

static const int kPageCount =   10;

@interface CTCustomGroupChildVC ()<UITableViewDelegate,UITableViewDataSource,XKUserServiceDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic,assign)NSUInteger curPage;

@end

@implementation CTCustomGroupChildVC
@synthesize dataArray = _dataArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layout];
    [self addRefresh];
    [[XKFDataService() userService] addWeakDelegate:self];
    
    [self queryNewDataFromCache];
    [self loadNewData];
    // Do any additional setup after loading the view.
}

- (void)addRefresh{
    @weakify(self);
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadNewData];
    }];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
}

- (void)layout{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)queryNewDataFromCache{
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    NSArray<XKGoodListModel *> *list = [[XKFDataService() actService] queryGoodListModelFromCacheByActivityType:Activity_Custom andCategoryId:self.categoryid andPage:1 andLimit:10 andUserId:userId];
    [self.dataArray addObjectsFromArray:list];
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
    @weakify(self);
    [self.tableView ly_startLoading];
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    [[XKFDataService() actService]getGoodListByActivityType:Activity_Custom andCategoryId:self.categoryid andPage:self.curPage andLimit:kPageCount andUserId:userId Complete:^(ACTGoodListRespnse * _Nonnull response) {
        @strongify(self);
        [self.tableView ly_endLoading];
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if (response.isSuccess) {
            NSArray<XKGoodListModel *> *results = [response.data result];
            //刷新数据时，需要清理旧的数据
            if (update) {
                [self.dataArray removeAllObjects];
            }
            self.curPage = page;
            [self.dataArray addObjectsFromArray:results];
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

/**
 下面俩个方法 登录状态改变刷新页面
 */
- (void)loginWithService:(XKUserService *)service userInfo:(XKAccountData *)data{
    [self loadNewData];
}

- (void)logoutWithService:(XKUserService *)service userId:(NSString *)userId{//退出登录 代理
    [self loadNewData];
}

#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count < K_REQUEST_PAGE_COUNT ) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTGoodsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    XKGoodListModel *model = _dataArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
    cell.textLabel.text = model.commodityName;
    //    cell.detailTextLabel.text = @"已由78人拼团";
    
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commodityPrice doubleValue]/100];
    cell.origPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
    [cell.priceLabel handleRedPrice:FontSemibold(17.f)];
    [cell.origPriceLabel addMiddleLineWithSubString:cell.origPriceLabel.text];
    
    cell.leftGoodsLabel.text = [NSString stringWithFormat:@"仅剩%ld件",(long)[model.targetNumber integerValue] - (long)[model.currentFightGroupNum integerValue]];
    cell.progressView.progress = [model.currentFightGroupNum integerValue]/[model.targetNumber integerValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XKGoodListModel *gModel = self.dataArray[indexPath.row];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Custom),@"id":gModel.id} completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}
#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}
- (UIScrollView *)listScrollView {
    return self.tableView;
}
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}
- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight  = 140;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.ly_emptyView = [XKEmptyView goodListNoDataView];
        [_tableView registerClass:[CTGoodsCell class] forCellReuseIdentifier:@"CTGoodsCell"];
    }
    return _tableView;
}

#pragma mark getter

- (NSMutableArray<XKGoodListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)dealloc{
     [[XKFDataService() userService] removeWeakDelegate:self];
}
@end
