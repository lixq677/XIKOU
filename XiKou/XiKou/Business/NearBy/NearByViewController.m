//
//  NearByViewController.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NearByViewController.h"
#import "NBSearchResultVC.h"
#import "MIAddressSelectVC.h"
#import "NBIndustrysVC.h"

#import "XKUIUnitls.h"
#import "XKSegmentView.h"
#import "XKShopService.h"
#import "XKCustomAlertView.h"
#import "XKSearchVC.h"

@interface NearByViewController ()
<MIAddressSelectViewControllerDelegate,
UISearchControllerDelegate,
XKSegmentViewDelegate,
NBSearchResultDelegate>

@property (nonatomic,strong,readonly) XKSegmentView *segmentView;

@property (nonatomic,strong,readonly) UIScrollView *scrollView;

@property (nonatomic, strong)XKSearchVC *searchController;
    
@property (nonatomic,strong)UIButton *searchBtn;

@property (nonatomic,strong)UIButton *addressBtn;

@property (nonatomic,strong,readonly) MIAddressSelectVC *addressSelectVC;

@property (nonatomic,strong,readonly)NSMutableArray<XKShopIndustryData *> *industrys;

@property (nonatomic,strong,readonly)NSMutableArray<NBIndustrysVC *> *childControllers;

@property (nonatomic,strong,readonly)XKAddressVoModel *addressVoModel;

@property (nonatomic,strong)UIView *historyView;

@property (nonatomic,strong)UIView *hotView;

@end

@implementation NearByViewController
@synthesize segmentView = _segmentView;
@synthesize scrollView = _scrollView;
@synthesize addressBtn = _addressBtn;
@synthesize addressSelectVC = _addressSelectVC;
@synthesize industrys = _industrys;
@synthesize childControllers = _childControllers;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    /*添加子控制器*/
    [self addChildViewController:self.addressSelectVC];
    [self.view addSubview:self.addressSelectVC.view];
    [self.addressSelectVC didMoveToParentViewController:self];
    
    [self setupNavigationBar];
    [self setupUI];
    [self layout];
    [self querySegmentInfoFromCache];
    [self querySegmentInfoFromServer];
}

- (void)setupNavigationBar{
    [self.addressBtn setTitle:@"长沙市" forState:UIControlStateNormal];
    [self.addressBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
    [self.addressBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.addressBtn addTarget:self action:@selector(selectAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.addressBtn];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
    imageView.contentMode  = UIViewContentModeLeft;
    imageView.width        = 10;
    UIBarButtonItem *noView = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItems = @[leftItem,noView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30.0f)]];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundColor:COLOR_VIEW_GRAY];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateHighlighted];
    [searchBtn setTitle:@" 搜索店铺" forState:UIControlStateNormal];
    [searchBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
    [searchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [searchBtn.titleLabel setFont:Font(12.f)];
    searchBtn.size = CGSizeMake(kScreenWidth - 50, 30);
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius  = 15.f;

    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
   
    self.searchBtn = searchBtn;
    self.navigationItem.titleView = searchBtn;
    
    NBSearchResultVC *controller = [[NBSearchResultVC alloc] initWithDelegate:self];
    controller.offsetY = kTopHeight;
    self.searchController = [[XKSearchVC alloc] initWithSearchResultsController:controller];
    self.searchController.searchResultsUpdater = controller;
    self.searchController.searchBar.delegate = controller;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.searchBar.placeholder = @"搜索店铺";
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = controller;
    self.definesPresentationContext = YES;
    [self.view addSubview:self.searchController.searchBar];
    self.searchController.searchBar.hidden = YES;
    [RACObserve(self.searchController.searchBar, frame) subscribeNext:^(id  _Nullable x) {
        CGRect frame = [(NSValue *)x CGRectValue];
        if (CGRectGetMaxX(frame) > kScreenWidth-20) {
            self.searchController.searchBar.width = kScreenWidth-20.0f;
        }
    }];
}

- (void)searchAction:(id)sender{
    [self.view insertSubview:self.searchController.searchBar atIndex:0];
    [self.searchController setActive:YES];
}

- (void)setupUI{
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.scrollView];
}

- (void)layout{
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(45.0f);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}


- (void)dealVoModel:(XKAddressVoModel *)voModel{
    _addressVoModel = voModel;
    [XKAddressVoModel saveVoModelToCache:voModel];
    [self.childControllers enumerateObjectsUsingBlock:^(NBIndustrysVC * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.addressVoModel = voModel;
        [obj reloadData];
    }];
    [self.addressBtn setTitle:voModel.city forState:UIControlStateNormal];
    [self.addressBtn sizeToFit];
}

#pragma mark 地址选择器代理
- (void)addressSelectViewController:(MIAddressSelectVC *)controller finishEditAddress:(XKAddressVoModel *)voData{
    [self dealVoModel:voData];
}

- (void)addressSelectViewController:(MIAddressSelectVC *)controller finishEditAddress:(XKAddressVoModel *)voData location:(nonnull CLLocation *)location{
    voData.location = location;
    [self dealVoModel:voData];
}

- (void)addressSelectViewController:(MIAddressSelectVC *)controller locationAddress:(XKAddressVoModel *)voData location:(nonnull CLLocation *)location{
    voData.location = location;
    [self dealVoModel:voData];
}

- (void)addressSelectViewController:(MIAddressSelectVC *)controller locationError:(NSError *)error{
    XKAddressVoModel *voModel = [XKAddressVoModel voModelFromCache];
    if (voModel) {
        [self dealVoModel:voModel];
    }
}


#pragma mark action
- (void)selectAddressAction:(UIButton *)sender{
    [self.addressSelectVC show];
}

- (void)querySegmentInfoFromServer{
    @weakify(self);
    [[XKFDataService() shopService] queryShopIndustryWithCompletion:^(XKShopIndustryResponse * _Nonnull response) {
        @strongify(self);
        if (response.isSuccess) {
            [self.industrys removeAllObjects];
            [self.industrys addObjectsFromArray:response.data];
            [self refreshSegment:self.industrys];
            [self refreshTd:YES];
        }else{
            [response showError];
        }
    }];
}

- (void)querySegmentInfoFromCache{
    NSArray<XKShopIndustryData *> *industrys = [[XKFDataService() shopService] queryShopIndustryFromCache];
    [self.industrys removeAllObjects];
    [self.industrys addObjectsFromArray:industrys];
    [self refreshSegment:self.industrys];
    [self refreshTd:NO];
}


#pragma mark 一些通用的方法

- (void)refreshSegment:(NSArray<XKShopIndustryData *> *)industrys{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:industrys.count];
    [industrys enumerateObjectsUsingBlock:^(XKShopIndustryData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.industryName) {
            [items addObject:obj.industryName];
        }
    }];
    [self.segmentView setTitles:items];
}

- (void)refreshTd:(BOOL)load{
    [self.childControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj willMoveToParentViewController:nil];
        [obj.view removeFromSuperview];
        [obj removeFromParentViewController];
    }];
    [self.childControllers removeAllObjects];
    
    [self.industrys enumerateObjectsUsingBlock:^(XKShopIndustryData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /*添加子控制器*/
        NBIndustrysVC *industryVC = [[NBIndustrysVC alloc] init];
        industryVC.industryData = obj;
        industryVC.addressVoModel = self.addressVoModel;
        industryVC.loadDataFromServer = load;
        /*设置view会调用viewDidload*/
      //  dispatch_async(dispatch_get_main_queue(), ^{
            [self addChildViewController:industryVC];
            [self.scrollView addSubview:industryVC.view];
            [industryVC didMoveToParentViewController:self];
            [self.childControllers addObject:industryVC];
            industryVC.view.frame = CGRectMake(idx*CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds)-45.0f);
        
        
      //  });
    }];
    self.scrollView.contentSize = CGSizeMake(self.industrys.count * CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.scrollView.bounds));
}

#pragma mark search

#pragma mark search controller delegate
- (void)willPresentSearchController:(UISearchController *)searchController{
    [self setupSearch];
    self.searchController.searchBar.hidden = NO;
    self.searchBtn.hidden = YES;
}


- (void)willDismissSearchController:(UISearchController *)searchController{
    self.searchController.searchBar.hidden = YES;
    self.searchBtn.hidden = NO;
    self.searchController.searchBar.text = nil;
}

- (void)searchResult:(UIViewController *)controller searchText:(NSString *)text{
    [MGJRouter openURL:kRouterSearchShop withUserInfo:@{@"searchText":text} completion:nil];
}


- (void)segmentView:(XKSegmentView *)segmentView selectIndex:(NSUInteger)index{
    [self.scrollView setContentOffset:CGPointMake(index*CGRectGetWidth(self.scrollView.frame), 0) animated:YES];
}

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
                [MGJRouter openURL:kRouterSearchShop withUserInfo:@{@"searchText":button.titleLabel.text} completion:nil];
            }
        }];
        lastBtn = button;
    }];
    view.size = CGSizeMake(width, lastBtn.bottom);
    return view;
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
- (XKSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[XKSegmentView alloc] init];
        _segmentView.delegate = self;
        _segmentView.contentScrollView = self.scrollView;
    }
    return _segmentView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = COLOR_VIEW_GRAY;
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (MIAddressSelectVC *)addressSelectVC{
    if (!_addressSelectVC) {
        _addressSelectVC = [[MIAddressSelectVC alloc] init];
        _addressSelectVC.addressLevel = XKAddressLevelCity;
        _addressSelectVC.delegate = self;
    }
    return _addressSelectVC;
}

- (UIButton *)addressBtn{
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _addressBtn;
}

- (NSMutableArray<XKShopIndustryData *> *)industrys{
    if (!_industrys) {
        _industrys = [NSMutableArray array];
    }
    return _industrys;
}

- (NSMutableArray<NBIndustrysVC *> *)childControllers{
    if (!_childControllers) {
        _childControllers  = [NSMutableArray array];
    }
    return _childControllers;
}

@end
