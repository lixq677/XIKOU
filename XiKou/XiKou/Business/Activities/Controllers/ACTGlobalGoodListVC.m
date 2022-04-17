//
//  ACTGlobalGoodListVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTGlobalGoodListVC.h"
#import "HMWgGoodsCell.h"
#import "XKSortButton.h"
#import "UILabel+NSMutableAttributedString.h"
#import "MJDIYFooter.h"
#import "TABAnimated.h"

#import "XKActivityService.h"
#import "XKPlaceholdTableCell.h"

@interface ACTGlobalGoodListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *sortView;

@property (nonatomic, copy) NSString *classID;

@property (nonatomic, copy) NSString *activityID;

@property (nonatomic, assign) NSInteger page;//分页

@property (nonatomic, assign) NSInteger sortType;//排序类别（1.价格 2.上新 3.销量 0 全部

@property (nonatomic, assign) NSInteger sortMode;//排序方式（1.升序 2.倒序）

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ACTGlobalGoodListVC

- (instancetype)initWithClassID:(NSString *)classID andActivityId:(nonnull NSString *)activityid{
    self = [super init];
    if (self) {
        _classID = classID;
        _activityID = activityid;
        _page = 1;
        _dataArray = [NSMutableArray array];
        _sortType  = 0;
        _sortMode  = 1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self instanceUI];
    [self addRefresh];
//    [self queryNewDataFromCache];
}
#pragma mark dataRequest
- (void)addRefresh{
    @weakify(self);
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self dataRequest];
    }];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self dataRequest];
    }];
}

- (void)dataRequest{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:@10,@"limit",@(_page),@"page",self.classID,@"categoryId", nil];
    if (_sortType != 0) {
        [param setObject:@(_sortType) forKey:@"sortType"];
        [param setObject:@(_sortMode) forKey:@"sortMode"];
    }
    [[XKFDataService() actService]getGlobalGoodListByClass:param Complete:^(ACTGoodListRespnse * _Nonnull response) {
        if ([response isSuccess]) {
            ACTGoodListData *data = response.data;
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            if (self.page <= data.pageCount && self.dataArray.count < data.totalCount) {
                self.page++;
                [self.dataArray addObjectsFromArray:data.result];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [response showError];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView tab_endAnimationEaseOut];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)queryNewDataFromCache{
    NSArray<XKGoodListModel *> *list = [[XKFDataService() actService] queryGoodListModelFromCacheByActivityType:Activity_Global andCategoryId:self.classID andPage:1 andLimit:10 andUserId:nil];
    [self.dataArray addObjectsFromArray:list];
}


#pragma mark UI
- (void)instanceUI{
    
    [self.view xk_addSubviews:@[self.sortView,self.tableView]];
    [self.sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.sortView.mas_bottom);
    }];
    self.navigationItem.title = _className;
    
    self.tableView.tabAnimated =
    [TABTableAnimated animatedWithCellClass:[XKPlaceholdGoodCell class]
                                 cellHeight:[XKPlaceholdGoodCell cellHeight]];
    
    _tableView.tabAnimated.animatedCount = 1;
    _tableView.tabAnimated.animatedSectionCount = 6;
    
    [self.tableView tab_startAnimationWithCompletion:^{
        [self dataRequest];
    }];
    
}

- (void)setClassName:(NSString *)className{
    _className = className;
}

#pragma mark action
- (void)sortBtnClick:(UIButton *)sender{
    for (int i = 0; i < 4; i++) {
        UIButton *button = [self.sortView viewWithTag:i+100];
        button.selected = (button.tag == sender.tag);
    }
    if (_sortType == sender.tag - 100 && _sortType == 100 && _dataArray.count > 0) {
        return;
    }
    _sortType = sender.tag - 100;
    if (sender.tag > 100) {
        XKSortButton *soreBtn = (XKSortButton *)sender;
        _sortMode = soreBtn.isAscending ? 1 : 2;
    }
    _page = 1;
    [self dataRequest];
}

#pragma mark UITableView
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMWgGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HMWgGoodsCell alloc]initWithCellStyle:CellGlobal reuseIdentifier:@"cell"];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XKGoodListModel *gModel = self.dataArray[indexPath.row];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Global),@"id":gModel.id} completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

- (UIView *)sortView{
    if (!_sortView) {
        
        _sortView = [UIView new];
        _sortView.backgroundColor = [UIColor whiteColor];
        
        UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allBtn.selected = YES;
        [allBtn setTag:100];
        [allBtn setTitle:@"综合" forState:UIControlStateNormal];
        [allBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
        [allBtn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateSelected];
        [allBtn.titleLabel setFont:Font(13.f)];
        [allBtn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sortView addSubview:allBtn];
        NSArray *titles = @[@"价格",@"上新",@"销量"];
        for (int i = 0; i<titles.count; i++) {
            NSString *title = titles[i];
            XKSortButton *btn = [[XKSortButton alloc]init];
            btn.title = title;
            btn.tag   = 101+i;
            btn.selected = NO;
            [btn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_sortView addSubview:btn];
        }
        [_sortView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [_sortView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sortView);
            make.height.mas_equalTo(45);
        }];
        UIView *line = [UIView new];
        line.backgroundColor = COLOR_LINE_GRAY;
        [_sortView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.sortView);
            make.left.equalTo(self.sortView).offset(15);
            make.right.equalTo(self.sortView).offset(-15);
            make.height.mas_equalTo(0.5);
        }];
        [_sortView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(allBtn);
        }];
    }
    return _sortView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
        _tableView.ly_emptyView = [XKEmptyView goodListNoDataView];
        
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, [XKUIUnitls safeBottom] + 10)];
    }
    return _tableView;
}


@end
