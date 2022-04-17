//
//  NBSearchShopsVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NBSearchShopsVC.h"
#import "XKBannerView.h"
#import "NBHeaderFooterView.h"
#import "NBCells.h"
#import "NBShopDetailVC.h"
#import "XKShopService.h"
#import "MJDIYFooter.h"
#import "NBSearchResultVC.h"
#import "XKAddressData.h"
#import "XKCustomAlertView.h"
#import "XKSearchVC.h"

static const int kPageCount =   50;

@interface NBSearchShopsVC ()
<UISearchControllerDelegate,
UITableViewDataSource,
UITableViewDelegate,
NBSearchResultDelegate>

@property (nonatomic, strong)XKSearchVC *searchController;

@property (nonatomic, strong)NSString *searchText;

@property (nonatomic, strong,readonly) UITableView *tableView;

@property (nonatomic, strong,readonly) NSMutableArray<XKShopBriefData *> *shops;

@property (nonatomic,assign)NSUInteger curPage;

@property (nonatomic,strong)UIView *historyView;

@property (nonatomic,strong)UIView *hotView;

@end

@implementation NBSearchShopsVC
@synthesize shops = _shops;
@synthesize tableView = _tableView;

- (instancetype)initWithSearchText:(NSString *)searchText{
    if(self = [super init]){
        _searchText = searchText;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupUI];
    [self loadNewData];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.searchController.searchBar.text = self.searchText;
}

- (void)setupUI{
    [self.view addSubview:self.tableView];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backgroundView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wdz"]];
    imageView.frame = CGRectMake(CGRectGetMidX(backgroundView.frame)-35.0f, 95.0f, 70.f, 55.0f);
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"没有找到相关店铺";
    hintLabel.font = [UIFont systemFontOfSize:12.0f];
    hintLabel.textColor = HexRGB(0x999999, 1.0f);
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [hintLabel sizeToFit];
    hintLabel.frame = CGRectMake(CGRectGetMidX(imageView.frame)-hintLabel.width*0.5f, imageView.bottom+8.0f, hintLabel.width, hintLabel.height);
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:hintLabel];
    
    self.tableView.backgroundView = backgroundView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(10.0f);
    }];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
    [self.tableView registerClass:[NBShopBriefStyle1Cell class] forCellReuseIdentifier:@"NBShopBriefStyle1Cell"];
    [self.tableView registerClass:[NBShopBriefStyle2Cell class] forCellReuseIdentifier:@"NBShopBriefStyle2Cell"];
   // [self.tableView registerClass:[NBHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"NBHeaderFooterView"];
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setupNavigationBar{
    NBSearchResultVC *controller = [[NBSearchResultVC alloc] initWithDelegate:self];
    controller.offsetY = kTopHeight;
    self.searchController = [[XKSearchVC alloc] initWithSearchResultsController:controller];
    self.searchController.searchResultsUpdater = controller;
    self.searchController.searchBar.delegate = controller;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"搜索店铺";
    self.searchController.delegate = self;
    UITextField *textField = nil;
    for (UIView *view in self.searchController.searchBar.subviews[0].subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            textField = (UITextField *)view;
            break;
        }
    }
    textField.textColor = HexRGB(0x444444, 1.0f);
    textField.font = [UIFont systemFontOfSize:12.0f];
    [self.searchController.searchBar sizeToFit];
    [self.searchController.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"SS_bar"] forState:UIControlStateNormal];
    self.definesPresentationContext = YES;
    if(@available(iOS 11.0, *)) {
        [[self.searchController.searchBar.heightAnchor constraintEqualToConstant:kNavBarHeight] setActive:YES];
    }
    self.searchController.searchBar.frame = CGRectMake(50, 0, kScreenWidth-100, 44);
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchController.searchBar;
}


- (void)willPresentSearchController:(UISearchController *)searchController{
    [self setupSearch];
}

- (void)didDismissSearchController:(UISearchController *)searchController{
    self.searchController.searchBar.text = self.searchText;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.shops.count > 0) {
        tableView.backgroundView.hidden = YES;
    }else{
        tableView.backgroundView.hidden = NO;
    }
    if (self.shops.count < kPageCount) {
        tableView.mj_footer.hidden = YES;
    }else{
        tableView.mj_footer.hidden = NO;
    }
    return self.shops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBShopBriefCell *cell = nil;
    XKShopBriefData *briefData = [self.shops objectAtIndex:indexPath.row];
    if (briefData.style == XKShopCellStyleBig) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NBShopBriefStyle1Cell" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"NBShopBriefStyle2Cell" forIndexPath:indexPath];
    }
    cell.textLabel.text = briefData.shopName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"优惠券买单最高抵扣%@%%",briefData.discountRate];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",briefData.distance.floatValue];
//    if (briefData.distance.floatValue > 1000.0f) {
//        cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",briefData.distance.floatValue/1000.0f];
//    }else{
//        cell.distanceLabel.text = [NSString stringWithFormat:@"%dm",(int)briefData.distance.floatValue];
//    }
    NSMutableArray<NSString *> *imageUrls = [NSMutableArray arrayWithCapacity:briefData.imageList.count];
    [briefData.imageList enumerateObjectsUsingBlock:^(XKShopImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == XKShopImageTypeShow) {
            [imageUrls addObject:obj.imageUrl?:@""];
        }
    }];
    [imageUrls addObject:@""];
    [imageUrls addObject:@""];
    [imageUrls addObject:@""];
    NSString *imageUrl1 = [imageUrls objectAtIndex:0];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl1] placeholderImage:[UIImage imageNamed:@"placeholder_background"]];
    
    NSString *imageUrl2 = [imageUrls objectAtIndex:1];
    [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:imageUrl2] placeholderImage:[UIImage imageNamed:@"placeholder_background"]];
    
    NSString *imageUrl3 = [imageUrls objectAtIndex:2];
    [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:imageUrl3] placeholderImage:[UIImage imageNamed:@"placeholder_background"]];
    return cell;
}


#pragma mark - UISearchResultsUpdating
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKShopBriefData *briefData = [self.shops objectAtIndex:indexPath.row];
    NBShopDetailVC *controller = [[NBShopDetailVC alloc] initWithShopeBriefData:briefData];
    [self.navigationController pushViewController:controller animated:YES];
   
}

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
    
    XKAddressVoModel *voModel = [XKAddressVoModel voModelFromCache];
    XKShopSearchParams *params = [[XKShopSearchParams alloc] init];
    params.page = (int)page;
    params.limit = kPageCount;
    params.shopName = self.searchText;
    params.latitude = @(voModel.location.coordinate.latitude);
    params.longitude = @(voModel.location.coordinate.longitude);
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() shopService] searchShopWithParams:params completion:^(XKShopBriefResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([response isSuccess]) {
            NSArray<XKShopBriefData *> *results = response.data;
            //刷新数据时，需要清理旧的数据
            if (update) {
                [self.shops removeAllObjects];
            }
            self.curPage = page;
            [self.shops addObjectsFromArray:results];
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
        [[deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            XKCustomAlertView *alert = [[XKCustomAlertView alloc] initWithType:CanleNoTitle andTitle:nil andContent:@"清空历史搜索记录" andBtnTitle:@"确定"];
            [alert setSureBlock:^{
                [[XKFDataService() shopService] deleteKeywordFromCache];
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
    NSArray<XKShopSearchText *> *searchText = [[XKFDataService() shopService] searchLastKeywordFromCache];
    NSMutableArray<NSString *> *hostoryTitles = [NSMutableArray array];
    [searchText enumerateObjectsUsingBlock:^(XKShopSearchText * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![NSString isNull:obj.shopName]){
            [hostoryTitles addObject:obj.shopName];
        }
    }];
    if (hostoryTitles.count) {
        self.historyView = [self createViewSectionTitle:@"历史搜索" searchtitles:hostoryTitles canDelete:YES];
        self.historyView.origin = CGPointMake(15.0f, 80.0f+[XKUIUnitls safeTop]);
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
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray<XKShopBriefData *> *)shops{
    if (_shops == nil) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}
@end
