//
//  HMSearchGoodsVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMSearchGoodsVC.h"
#import "XKHomeService.h"
#import "MJDIYFooter.h"
#import "HMSearchResultVC.h"
#import "XKSortButton.h"
#import "HMViews.h"
#import "UILabel+NSMutableAttributedString.h"
#import "BCTools.h"
#import "XKCustomAlertView.h"
#import "XKSearchVC.h"

static const int kPageCount =   50;

@interface HMSearchFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,strong) NSArray *attrs;

@end

@implementation HMSearchFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (CGSize)collectionViewContentSize{
    UICollectionViewLayoutAttributes *attr = [self.attrs lastObject];
    CGFloat H = CGRectGetMaxY(attr.frame);
    CGFloat W = CGRectGetWidth(self.collectionView.frame);
    return CGSizeMake(W, H);
}

- (void)prepareLayout{
    [super prepareLayout];

    NSMutableArray<UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray array];

    CGFloat y = 10.0f;
    CGFloat cellX = 15.0f;
    CGFloat goodsCellW = (kScreenWidth-45.0f)*0.5f;
    CGFloat goodsCellH = (kScreenWidth-45.0f)*0.5f+75.0f;
    CGFloat goodsSpaceH = 15.0f;
    CGFloat goodsSpaceW = 15.0f;
    CGFloat goodsX = cellX;
    CGFloat goodsY = y;
    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    for (int row = 0; row < cellCount; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        NSUInteger line = indexPath.row /2;
        NSUInteger col = indexPath.row % 2;
        attr.frame = CGRectMake(goodsX+(goodsCellW + goodsSpaceW)*col, goodsY+(goodsCellH+goodsSpaceH)*line, goodsCellW, goodsCellH);
        [attributes addObject:attr];
    }
    self.attrs = attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrs;
}

@end




@interface HMSearchGoodsVC ()
<UISearchControllerDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
HMSearchResultDelegate>


@property (nonatomic, strong)XKSearchVC *searchController;

@property (nonatomic, strong)NSString *searchText;

@property (nonatomic, strong,readonly) UICollectionView *collectionView;

@property (nonatomic, strong)HMSearchFlowLayout *flowLayout;

@property (nonatomic, strong,readonly) NSMutableArray<XKGoodsSearchData *> *goods;

@property (nonatomic,assign)NSUInteger curPage;

@property (nonatomic,assign)XKSortResult salesNumFlag;//销量排序 销量;1-从多到少;2-从少到多

@property (nonatomic,assign)XKSortResult priceFlag;//价格;1-从多到少;2-从少到多

@property (nonatomic,assign)XKSortResult nwFlag;//上新;1-从新到旧到少;2-从旧到新

@property (nonatomic,strong)UIView *historyView;

@property (nonatomic,strong)UIView *hotView;

@property (nonatomic, strong)UIView *sortView;



@end

@implementation HMSearchGoodsVC
@synthesize goods = _goods;
@synthesize collectionView = _collectionView;

- (instancetype)initWithSearchText:(NSString *)searchText{
    if(self = [super init]){
        _searchText = searchText;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupNavigationBar];
    [self setupUI];
    [self loadNewData];
    
    self.searchController.searchBar.text = self.searchText;
}

- (void)setupUI{
    self.view.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.sortView];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backgroundView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wdz"]];
    imageView.frame = CGRectMake(CGRectGetMidX(backgroundView.frame)-35.0f, 95.0f, 70.f, 55.0f);
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"没有找到相关商品";
    hintLabel.font = [UIFont systemFontOfSize:12.0f];
    hintLabel.textColor = HexRGB(0x999999, 1.0f);
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [hintLabel sizeToFit];
    hintLabel.frame = CGRectMake(CGRectGetMidX(imageView.frame)-hintLabel.width*0.5f, imageView.bottom+8.0f, hintLabel.width, hintLabel.height);
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:hintLabel];
    
    self.collectionView.backgroundView = backgroundView;
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.collectionView);
    }];
    [self.sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(kTopHeight);
        make.height.mas_equalTo(45.0f);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.sortView.mas_bottom).offset(10.0f);
    }];
     [self.collectionView registerClass:[CGSearchGoodsCell class] forCellWithReuseIdentifier:@"CGSearchGoodsCell"];
    
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setupNavigationBar{
    HMSearchResultVC *controller = [[HMSearchResultVC alloc] initWithDelegate:self];
    self.searchController = [[XKSearchVC alloc] initWithSearchResultsController:controller];
    self.searchController.searchResultsUpdater = controller;
    self.searchController.extendedLayoutIncludesOpaqueBars = YES;
    self.searchController.searchBar.delegate = controller;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"搜索喜扣优品，享实惠，更赚钱！";
    self.definesPresentationContext = YES;
    self.navigationItem.titleView = self.searchController.searchBar;
}


/****************collectionView 数据展示*****************/

#pragma mark collectionView 的代理和数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.goods.count > 0) {
        collectionView.backgroundView.hidden = YES;
    }else{
        collectionView.backgroundView.hidden = NO;
    }
    if (self.goods.count < kPageCount) {
        collectionView.mj_footer.hidden = YES;
    }else{
        collectionView.mj_footer.hidden = NO;
    }
    return self.goods.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XKGoodsSearchData *data = [self.goods objectAtIndex:indexPath.row];
    CGSearchGoodsCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"CGSearchGoodsCell" forIndexPath:indexPath];
    cell.backgroundColor = HexRGB(0xffffff, 1.0f);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    
    cell.textLabel.text = data.commodityName;
    cell.textLabel.numberOfLines = 0;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    if (data.activityType == Activity_WG) {
        [attr appendAttributedString:Price(data.salePrice/(double)100.0f,[UIFont boldSystemFontOfSize:17.0f])];
    }else{
        [attr appendAttributedString:Price(data.commodityPrice/(double)100.0f,[UIFont boldSystemFontOfSize:17.0f])];
        [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
        [attr appendAttributedString:Price_line(data.salePrice/(double)100.0f,[UIFont systemFontOfSize:10.0f])];
    }
    cell.priceLabel.attributedText = attr;
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XKGoodsSearchData *data = [self.goods objectAtIndex:indexPath.row];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(data.activityType),@"id":data.id} completion:nil];
}



- (void)willPresentSearchController:(UISearchController *)searchController{
    [self setupSearch];
}

- (void)didDismissSearchController:(UISearchController *)searchController{
    self.searchController.searchBar.text = self.searchText;
}

#pragma mark - UISearchResultsUpdating

- (void)searchResult:(UIViewController *)controller searchText:(NSString *)text{
    [self search:text];
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
    XKGoodsSearchParams *params = [[XKGoodsSearchParams alloc] init];
    params.page = (int)page;
    params.limit = kPageCount;
    params.commodityName = self.searchText;
    if (self.priceFlag != XKSortNone) {
        params.priceFlag = @(self.priceFlag);
    }else{
        params.priceFlag = nil;
    }
    if (self.salesNumFlag != XKSortNone) {
        params.salesNumFlag = @(self.priceFlag);
    }else{
        params.salesNumFlag = nil;
    }
    if (self.nwFlag!= XKSortNone) {
        params.nwFlag = @(self.nwFlag);
    }else{
        params.nwFlag = nil;
    }
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() homeService] searchGoodsWithParams:params completion:^(XKGoodsSearchResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if ([response isSuccess]) {
            NSArray<XKGoodsSearchData *> *results = response.data;
            //刷新数据时，需要清理旧的数据
            if (update) {
                [self.goods removeAllObjects];
            }
            self.curPage = page;
            [self.goods addObjectsFromArray:results];
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
        [self.collectionView.mj_header endRefreshing];
    }];
}



#pragma mark search
- (UIView *)createViewSectionTitle:(NSString *)sectionTitle searchtitles:(NSArray<NSString *> *)searchTitles canDelete:(BOOL)delete{
    if (searchTitles.count <= 0) {
        return nil;
    }
    CGFloat width = kScreenWidth-30.0f;
    UIView *view = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0, 200, 15.0f)];
    titleLabel.text = sectionTitle;
    titleLabel.textColor = HexRGB(0x999999, 1.0f);
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:titleLabel];
    if (delete) {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
        [deleteBtn setFrame:CGRectMake(width-15.0f, CGRectGetMidY(titleLabel.frame)-7.5f, 15.0f, 15.0f)];
        [view addSubview:deleteBtn];
        @weakify(self);
        [[deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            XKCustomAlertView *alert = [[XKCustomAlertView alloc] initWithType:CanleNoTitle andTitle:nil andContent:@"清空历史搜索记录" andBtnTitle:@"确定"];
            [alert setSureBlock:^{
                [[XKFDataService() homeService] deleteKeywordFromCache];
                [self.historyView removeFromSuperview];
                self.historyView = nil;
            }];
            [alert show];
        }];
    }
    __block UIButton *lastBtn = nil;
    CGFloat space = 10.0f;
    [searchTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 2.0f;
        button.tag = idx;
        [button setTitle:obj forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        button.backgroundColor = COLOR_VIEW_GRAY;
        [button setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        [button sizeToFit];
        button.width+=20.0f;
        if (idx == 0) {
            button.frame = CGRectMake(0.0f, CGRectGetMaxY(titleLabel.frame)+space, button.width, 35.0f);
        }else{
            if(lastBtn.right + button.width + space < width){
                button.x = lastBtn.right + space;
                button.y = lastBtn.y;
                button.height = lastBtn.height;
            }else{
                button.x = 0;
                button.y = lastBtn.bottom + space;
                button.height = lastBtn.height;
            }
        }
        [view addSubview:button];
        @weakify(button);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(button);
            if ([NSString isNull:button.titleLabel.text] == NO) {
                [self search:button.titleLabel.text];
            }
        }];
        lastBtn = button;
    }];
    view.size = CGSizeMake(width, lastBtn.bottom);
    return view;
}

- (void)search:(NSString *)text{
    [self.searchController setActive:NO];
    self.searchController.searchBar.text = text;
    self.searchText = text;
    [self loadNewData];
}

- (void)setupSearch{
    if (self.historyView) {
        [self.historyView removeFromSuperview];
    }
    NSArray<XKGoodsSearchText *> *searchText = [[XKFDataService() homeService] searchLastKeywordFromCache];
    NSMutableArray<NSString *> *hostoryTitles = [NSMutableArray array];
    [searchText enumerateObjectsUsingBlock:^(XKGoodsSearchText * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![NSString isNull:obj.commodityName]){
            [hostoryTitles addObject:obj.commodityName];
        }
    }];
    if (hostoryTitles.count) {
        self.historyView = [self createViewSectionTitle:@"历史搜索" searchtitles:hostoryTitles canDelete:YES];
        self.historyView.origin = CGPointMake(15.0f, 10.0f);
    }
    /*
     NSArray<NSString *> *hotitles = @[@"男性护肤",@"美容美发",@"挖掘机与汽修"];
     _hotView = [self createViewSectionTitle:@"热门搜索" searchtitles:hotitles canDelete:NO];
     self.hotView.origin = CGPointMake(15.0f, CGRectGetMaxY(self.historyView.frame)+30.0f);
     */
    @weakify(self);
    [[self.historyView rac_signalForSelector:@selector(removeFromSuperview)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [UIView animateWithDuration:0.2 animations:^{
            self.hotView.origin = CGPointMake(15.0f, 80.0f+[XKUIUnitls safeTop]);
        }];
    }];
    [[self.historyView rac_signalForSelector:@selector(didMoveToView:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        self.hotView.origin = CGPointMake(15.0f, CGRectGetMaxY(self.historyView.frame)+30.0f);
    }];
    [[self.searchController.searchResultsController rac_signalForSelector:@selector(updateSearchResultsForSearchController:) fromProtocol:@protocol(UISearchResultsUpdating)] subscribeNext:^(RACTuple * _Nullable x) {
        UISearchController *searchController = [x objectAtIndex:0];
        if ([NSString isNull:searchController.searchBar.text]) {
            self.historyView.hidden = NO;
            self.hotView.hidden = NO;
        }else{
            self.historyView.hidden = YES;
            self.hotView.hidden = YES;
        }
    }];
    if (self.historyView) {
        [self.searchController.view addSubview:self.historyView];
    }
}


#pragma mark getter
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
        [[allBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            self.salesNumFlag = XKSortNone;
            self.priceFlag = XKSortNone;
            self.nwFlag = XKSortNone;
            [self loadNewData];
        }];
        [_sortView addSubview:allBtn];
        NSArray *titles = @[@"价格",@"上新",@"销量"];
        for (int i = 0; i<titles.count; i++) {
            NSString *title = titles[i];
            XKSortButton *btn = [[XKSortButton alloc]init];
            btn.title = title;
            btn.tag   = 101+i;
            btn.selected = NO;
            @weakify(self);
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                [self->_sortView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![obj isKindOfClass:[XKSortButton class]]) return;
                    if ((XKSortButton *)obj == btn) {
                        [(XKSortButton *)obj setSelected:YES];
                    }else{
                        [(XKSortButton *)obj setSelected:NO];
                    }
                }];
                if (i == 0) {
                    if (btn.ascending) {
                        self.priceFlag = XKSortAscending;
                    }else{
                        self.priceFlag = XKSortDescending;
                    }
                    self.nwFlag = XKSortNone;
                    self.salesNumFlag = XKSortNone;
                    
                }else if (i == 1){
                   if (btn.ascending) {
                       self.nwFlag = XKSortAscending;
                    }else{
                       self.nwFlag = XKSortDescending;
                    }
                    self.priceFlag = XKSortNone;
                    self.salesNumFlag = XKSortNone;
                }else{
                    if (btn.ascending) {
                        self.salesNumFlag = XKSortAscending;
                    }else{
                        self.salesNumFlag = XKSortDescending;
                    }
                    self.nwFlag = XKSortNone;
                    self.priceFlag = XKSortNone;
                }
                [self loadNewData];
            }];
            [_sortView addSubview:btn];
        }
        [_sortView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [_sortView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(33);
        }];
        [_sortView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(allBtn);
        }];
    }
    return _sortView;
}

- (HMSearchFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[HMSearchFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.itemSize = CGSizeMake((kScreenWidth-45)*0.5f, (kScreenWidth-45.0f)*0.5f+75.0f);
        _flowLayout.sectionInset = UIEdgeInsetsMake(15, 15.0f, 15.0f, 15.0f);
        _flowLayout.minimumLineSpacing = 10.0f;
        _flowLayout.minimumInteritemSpacing = 10.0f;
        //_flowLayout.sectionHeadersPinToVisibleBounds = YES;
    }
    return _flowLayout;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSMutableArray<XKGoodsSearchData *> *)goods{
    if (_goods == nil) {
        _goods = [NSMutableArray array];
    }
    return _goods;
}

@end
