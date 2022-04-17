//
//  HMLimitBuyChildVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/18.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMLimitBuyChildVC.h"
#import "HMWgGoodsCell.h"
#import "MJDIYFooter.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKActivityService.h"
#import "XKAccountManager.h"

static const int kPageCount =   10;

@interface HMLimitBuyChildVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic,assign)NSUInteger curPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HMLimitBuyChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self layout];
    _dataArray = [NSMutableArray array];
    [self queryNewDataFromCache];
    [self loadNewData];
}

- (void)addRefresh{
    @weakify(self);
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadNewData];
    }];
}

- (void)queryNewDataFromCache{
    NSString *userId = [XKAccountManager defaultManager].account.userId;
    NSArray<XKGoodListModel *> *list = [[XKFDataService() actService] queryGoodListModelFromCacheByActivityType:Activity_Discount andCategoryId:self.categoryid andPage:1 andLimit:kPageCount andUserId:userId];
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
    [[XKFDataService() actService] getGoodListByActivityType:Activity_WG andCategoryId:self.categoryid andPage:self.curPage andLimit:kPageCount andUserId:userId Complete:^(ACTGoodListRespnse * _Nonnull response) {
        @strongify(self);
        [self.tableView ly_endLoading];
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([response isSuccess]) {
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



- (void)layout{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count < K_REQUEST_PAGE_COUNT ) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMWgGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HMWgGoodsCell alloc]initWithCellStyle:CellWG reuseIdentifier:@"cell"];
    }
    XKGoodListModel *gModel = self.dataArray[indexPath.row];
    cell.model = gModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XKGoodListModel *gModel = self.dataArray[indexPath.row];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_WG),@"id":gModel.id} completion:nil];
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

#pragma markg getter or setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0.0f;
        _tableView.estimatedRowHeight = 250.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.ly_emptyView = [XKEmptyView goodListNoDataView];
    }
    return _tableView;
}
@end
