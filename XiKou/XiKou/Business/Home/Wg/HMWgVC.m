//
//  HMWgVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMWgVC.h"
#import "HMWgGoodsCell.h"
#import "MJDIYFooter.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKActivityService.h"
#import "XKAccountManager.h"
#import "TABAnimated.h"
#import "XKSortButton.h"
#import "XKShareTool.h"
#import "XKPlaceholdTableCell.h"
#import "XKBannerView.h"
#import "XKHomeService.h"

static const int kPageCount =   10;

typedef NS_ENUM(int,HMSortMethod) {
    HMSortMethodDefault    =  0,
    HMSortMethodPriceAsc   =   1,
    HMSortMethodPriceDesc  =   2
};

@interface HMWgVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UIView *sortView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)XKBannerView *bannerView;



@property (nonatomic, strong) UIButton *sortDefaultBtn;

@property (nonatomic, strong) XKSortButton *sortDirectBtn;

@property (nonatomic, assign)NSUInteger curPage;
@property (nonatomic, strong) NSMutableArray<XKGoodListModel *> *goods;

@property (nonatomic,assign)HMSortMethod sortMethod;


@end

@implementation HMWgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"吾G限量购";
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self addNavigationItemWithImageName:@"hm_share" isLeft:NO target:self action:@selector(rightClick)];
    [self setupUI];
    [self addRefresh];
    [self queryBannerFromCache];
    [self queryBannerFromServer];
   // [self loadNewData];
    
}

- (void)setupUI{
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, scalef(200.0f)+45.0f);
    self.bannerView.frame = CGRectMake(0, 0, kScreenWidth, scalef(200.0f));
    self.sortView.frame = CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), kScreenWidth, 45.0f);
    
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    
    [self.headerView addSubview:self.bannerView];
    [self.headerView addSubview:self.sortView];
    [self.sortView addSubview:self.sortDefaultBtn];
    [self.sortView addSubview:self.sortDirectBtn];
    
    [self.sortDefaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.sortView);
        make.width.mas_equalTo(80.0f);
        make.centerX.mas_equalTo(-kScreenWidth/4.0f);
    }];
    
    [self.sortDirectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.sortView);
        make.width.mas_equalTo(80.0f);
        make.centerX.mas_equalTo(kScreenWidth/4.0f);
    }];
    
   
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    [self.tableView registerClass:[CMGoodsListCell class] forCellReuseIdentifier:@"CMGoodsListCell"];
    
    self.tableView.tabAnimated =
    [TABTableAnimated animatedWithCellClass:[XKPlaceholdGoodCell class]
                                 cellHeight:151];

    self.tableView.tabAnimated.animatedCount = 1;
    self.tableView.tabAnimated.animatedSectionCount = 6;

    [self.tableView tab_startAnimationWithCompletion:^{
        [self loadNewData];
    }];
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
    [self.tableView ly_startLoading];
   // NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    ACTGoodsListParams *params = [[ACTGoodsListParams alloc] init];
    if (self.sortMethod == HMSortMethodPriceAsc) {
        params.sortDirect = @(1);
        params.sort = @(2);//价格
    }else if (self.sortMethod == HMSortMethodPriceDesc){
        params.sortDirect = @(2);
        params.sort = @(2);//价格
    }else{
        params.sortDirect = nil;
    }
    params.page = page;
    params.limit = kPageCount;
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() actService] queryGoodsListForWgWithParams:params completion:^(ACTGoodListRespnse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        [self.tableView tab_endAnimationEaseOut];
        [self.tableView ly_endLoading];
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([response isSuccess]) {
            NSArray<XKGoodListModel *> *results = [response.data result];
            //刷新数据时，需要清理旧的数据
            if (update) {
                [self.goods removeAllObjects];
            }
            self.curPage = page;
            [self.goods addObjectsFromArray:results];
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

- (void)queryBannerFromServer{
    XKBannerParams *params = [[XKBannerParams alloc] init];
    params.moudle = XKBannerMoudleWg;
    params.position = XKBannerPositionTop;
    [[XKFDataService() homeService] queryBannerWithParams:params completion:^(XKBannerResponse * _Nonnull response) {
        if (response.isSuccess) {
            if (response.data.count > 0) {
                [self.bannerView setDataSource:response.data];
            }
        }
    }];
}

- (void)queryBannerFromCache{
    NSArray<XKBannerData *> *banners = [[XKFDataService() homeService] queryActivityBannerFromCacheWithPostion:XKBannerPositionTop moudle:XKBannerMoudleWg];
    if (banners.count > 0) {
        self.bannerView.dataSource = banners;
    }
}


- (void)clickForDefaultSort:(UIButton *)sender{
    if(self.sortDefaultBtn.isSelected)return;
    self.sortMethod = HMSortMethodDefault;
    self.sortDefaultBtn.selected = YES;
    self.sortDirectBtn.selected = NO;
    [self loadNewData];
}

- (void)clickForDirectionSort:(UIButton *)sender{
    if (self.sortDirectBtn.isAscending) {
        self.sortMethod = HMSortMethodPriceDesc;
    }else{
        self.sortMethod = HMSortMethodPriceAsc;
    }
    self.sortDefaultBtn.selected = NO;
    self.sortDirectBtn.selected = YES;
    [self loadNewData];
}

- (void)rightClick{
    NSString *activityId = @"";
    for (XKGoodListModel *gModel in self.goods) {
        activityId = gModel.activityId;
        break;
    }
    if (activityId.length == 0) {//自己动手，丰衣足食，到处取需要的数据
        XKShowToast(@"获取分享数据失败");
        return;
    };
    
    XKShareRequestModel *model = [XKShareRequestModel new];
    model.shopId = @"";//不要问我为什么，不传系统就要溜号了
    model.activityId = activityId;
    model.shareUserId = [XKAccountManager defaultManager].account.userId ? [XKAccountManager defaultManager].account.userId : @"";
    model.popularizePosition = SPActivityWug;
    
    [[XKShareTool defaultTool]shareWithModel:model andTitle:@"分享到好友" andContent:nil andNeedPhoto:NO andUIType:ShareUIBottom];
}


#pragma mark tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.goods.count < kPageCount) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    return self.goods.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CMGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMGoodsListCell" forIndexPath:indexPath];
    XKGoodListModel *gModel = self.goods[indexPath.section];
    cell.model = gModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKGoodListModel *gModel = self.goods[indexPath.section];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_WG),@"id":gModel.id} completion:nil];
}



#pragma markg getter or setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0.0f;
        _tableView.rowHeight = 151.0f;
        _tableView.estimatedRowHeight = 151.0f;
       // _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.ly_emptyView = [XKEmptyView goodListNoDataView];
    }
    return _tableView;
}

- (NSMutableArray<XKGoodListModel *> *)goods{
    if (!_goods) {
        _goods = [NSMutableArray array];
    }
    return _goods;
}

- (UIView *)sortView{
    if (!_sortView) {
        _sortView = [UIView new];
        _sortView.backgroundColor = [UIColor whiteColor];
    }
    return _sortView;
}

- (XKSortButton *)sortDirectBtn{
    if (!_sortDirectBtn) {
        _sortDirectBtn = [[XKSortButton alloc] init];
        _sortDirectBtn.title = @"价格";
        [_sortDirectBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
        [_sortDirectBtn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateSelected];
        [_sortDirectBtn.titleLabel setFont:Font(13.f)];
        _sortDirectBtn.selected = NO;
        [_sortDirectBtn addTarget:self action:@selector(clickForDirectionSort:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortDirectBtn;
}

- (UIButton *)sortDefaultBtn{
    if (!_sortDefaultBtn) {
        _sortDefaultBtn = [[UIButton alloc] init];
        [_sortDefaultBtn setTitle:@"综合" forState:UIControlStateNormal];
        [_sortDefaultBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
        [_sortDefaultBtn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateSelected];
        [_sortDefaultBtn.titleLabel setFont:Font(13.f)];
        [_sortDefaultBtn addTarget:self action:@selector(clickForDefaultSort:) forControlEvents:UIControlEventTouchUpInside];
        [_sortDefaultBtn setSelected:YES];
    }
    return _sortDefaultBtn;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
    }
    return _headerView;
}

- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc] init];
        _bannerView.dataSource = @[[UIImage imageNamed:@"Wg_banner"]];
        _bannerView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerView.clipsToBounds = YES;
    }
    return _bannerView;
}

@end
