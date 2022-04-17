//
//  ACTMutilBuyChildVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTDiscountBuyChildVC.h"
#import "ACTZeroBuyGoodCell.h"
#import "ACTDiscountGoodCell.h"
#import "MJDIYFooter.h"
#import "XKActivityService.h"
#import "XKAccountManager.h"
#import <TABAnimated.h>

static const int kPageCount =   10;

@interface ACTDiscountBuyChildVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSUInteger curPage;

@property (nonatomic, strong) ACTMutilBuyDiscountModel *discountModel;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end
static const CGFloat space = 10;
@implementation ACTDiscountBuyChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    [self initSubView];
    [self addRefresh];
    [self loadNewData];
    
}

#pragma mark UI
- (void)initSubView{

    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark dataRequest
- (void)addRefresh{
    @weakify(self);
    self.collectionView.mj_footer = [MJDIYFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadNewData];
    }];
}

- (void)queryNewDataFromCache{
    
    NSString *userId = [XKAccountManager defaultManager].account.userId;
    NSArray<XKGoodListModel *> *list = [[XKFDataService() actService] queryGoodListModelFromCacheByActivityType:Activity_Discount andCategoryId:self.categoryId andPage:1 andLimit:kPageCount andUserId:userId];
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
    [self.collectionView ly_startLoading];
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    [[XKFDataService() actService]getGoodListByActivityType:Activity_Discount andCategoryId:self.categoryId andPage:self.curPage andLimit:kPageCount andUserId:userId Complete:^(ACTGoodListRespnse * _Nonnull response) {
        @strongify(self);
        [self.collectionView ly_endLoading];
        [self.collectionView tab_endAnimation];
        if (update) {
            [self.collectionView.mj_header endRefreshing];
        }
        if ([response isSuccess]) {
            NSArray<XKGoodListModel *> *results = [response.data result];
            //刷新数据时，需要清理旧的数据
            if (update) {
                [self.dataArray removeAllObjects];
            }
            self.curPage = page;
            [self.dataArray addObjectsFromArray:results];
            [self.collectionView reloadData];
            if (results.count < kPageCount) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.collectionView.mj_footer endRefreshing];
            }
        }else{
            if(!update){
                [self.collectionView.mj_footer endRefreshing];
            }
            [response showError];
        }
    }];
}

#pragma mark collcetionView delegate && dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArray.count < K_REQUEST_PAGE_COUNT ) {
        self.collectionView.mj_footer.hidden = YES;
    }else{
        self.collectionView.mj_footer.hidden = NO;
    }
    return _dataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ACTDiscountGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTDiscountGoodCell identify] forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - space*3)/2.f - 0.1,scalef(154));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XKGoodListModel *gModel  = _dataArray[indexPath.row];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Discount),@"id":gModel.id} completion:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}
- (UIScrollView *)listScrollView {
    return self.collectionView;
}
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = space;
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.ly_emptyView = [XKEmptyView goodListNoDataView];
        [_collectionView registerClass:[ACTDiscountGoodCell class]
            forCellWithReuseIdentifier:[ACTDiscountGoodCell identify]];
    }
    return _collectionView;
}

@end
