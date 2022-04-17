//
//  ACTDiscountBuyChild2VC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/26.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTDiscountBuyChild2VC.h"
#import "CGGoodsView.h"
#import "MJDIYFooter.h"
#import "XKActivityService.h"
#import "MJDIYFooter.h"
#import "XKDataService.h"
#import "XKAccountManager.h"
#import <TABAnimated.h>
#import "XKTableView.h"

static const int kPageCount =   10;

@interface ACTDiscountBuyChild2VC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) XKTableView *tableView;

@property (nonatomic, strong) NSMutableArray<XKGoodListModel *> *goods;

@property (nonatomic, assign) NSUInteger curPage;

@property (nonatomic,assign)BOOL allowScroll;

@end

@implementation ACTDiscountBuyChild2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allowScroll:) name:@"kcAllowScroll" object:nil];
    
    [self.tableView registerClass:[CGGoodsListCell class] forCellReuseIdentifier:@"CGGoodsListCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(-10);
    }];

    @weakify(self);
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
    
    self.tableView.tabAnimated =
     [TABTableAnimated animatedWithCellClass:[CGGoodsListCell class]];
    self.tableView.tabAnimated.animatedCount = 3;
    [self.tableView tab_startAnimation];
    
//    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
//        @strongify(self);
//        [self loadNewData];
//    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



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
    CGGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CGGoodsListCell" forIndexPath:indexPath];
    XKGoodListModel *gModel = self.goods[indexPath.section];
    cell.model = gModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKGoodListModel *gModel = self.goods[indexPath.section];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Discount),@"id":gModel.id} completion:nil];
}

- (void)allowScroll:(NSNotification *)notif{
    self.allowScroll = [notif.object boolValue];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    BOOL allowScroll = NO;
    if (scrollView.contentOffset.y > 0) {
        allowScroll = NO;
    }else{
        allowScroll = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ksAllowScroll" object:@(allowScroll)];
    if (self.allowScroll == NO) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
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
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    [[XKFDataService() actService] getGoodListByActivityType:Activity_Discount andCategoryId:self.moduleId andPage:self.curPage andLimit:kPageCount andUserId:userId Complete:^(ACTGoodListRespnse * _Nonnull response) {
        @strongify(self);
        [self.tableView tab_endAnimation];
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

- (void)setModuleId:(NSString *)moduleId{
    if ([_moduleId isEqualToString:moduleId] == NO) {
        _moduleId = moduleId;
        [self loadNewData];
    }
}


- (XKTableView *)tableView{
    if (!_tableView) {
        _tableView = [[XKTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0.0f;
        _tableView.rowHeight = 151.0f;
        _tableView.estimatedRowHeight = 151.0f;
        _tableView.bounces = YES;
       // _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray<XKGoodListModel *> *)goods{
    if (!_goods) {
        _goods = [NSMutableArray array];
    }
    return _goods;
}

@end
