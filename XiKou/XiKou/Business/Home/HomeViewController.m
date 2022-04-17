//
//  HomeViewController.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HomeViewController.h"
#import "HMSearchGoodsVC.h"
#import "CTHallVC.h"
#import "MITaskVC.h"
#import "HMXkProfitVC.h"
#import "HMMessageVC.h"
#import "HMSearchResultVC.h"

#import "UIView+XKUnitls.h"
#import <MJRefresh.h>
#import <SDWebImage.h>
#import "HMQRVC.h"
#import "UIBarButtonItem+Badge.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKUIUnitls.h"
#import "XKUnitls.h"
#import "XKBannerView.h"
#import "HMViews.h"
#import "HMFlowLayout.h"

#import "XKHomeService.h"
#import "XKMessageService.h"
#import "XKAccountManager.h"
#import "BCTools.h"
#import "XKGoodModel.h"
#import "HMQualityView.h"
#import "XKCustomAlertView.h"
#import "XKUserService.h"
#import "XKSearchVC.h"

@import Photos;

@interface HomeViewController ()
<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
HMCellDelegate,
HMReusableViewDelegate,
XKMessageServiceDelegate,
UISearchControllerDelegate,
HMSearchResultDelegate,
HMFlowLayoutDelegate,
XKUserServiceDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)UIView *headerView;

@property (nonatomic, strong)XKBannerView *bannerView;

@property (nonatomic, strong)HMFlowLayout *flowLayout;

@property (nonatomic, strong)XKSearchVC *searchController;

@property (nonatomic,strong)UIView *historyView;

@property (nonatomic,strong)UIView *hotView;

@property (nonatomic,strong)UIButton *searchBtn;

/*数据模型*/
@property (nonatomic,strong,readonly)XKHomeActivityModel *activityModel;

@property (nonatomic,strong,readonly)NSMutableArray<XKHomeActivityBaseModel *> *activityModels;

@property (nonatomic,strong,readonly)XKMsgUnReadData *msgUnreadData;

@property (nonatomic,strong)NSArray<XKBannerData *> *middleBanners;

@property (nonatomic,strong)HMQualityView *qualityView;

@property (nonatomic,strong)UITapGestureRecognizer *tapGesture;

@property (nonatomic,assign)XKNavigationBarStyle currentBarStyle;

@end

@implementation HomeViewController
@synthesize activityModel = _activityModel;
@synthesize activityModels = _activityModels;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.edgesForExtendedLayout = self.edgesForExtendedLayout & ~UIRectEdgeBottom;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self setNavigationBar];
    [self setupUI];
    [self autolayout];
    [self setSearchBarController];
    [self scrollViewDidScroll:self.collectionView];
    [[XKFDataService() userService] addWeakDelegate:self];
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [self initDataFromCache];
    [self initDataFromServer];
    [self queryBannerFromCacheWithPostion:XKBannerPositionTop];
    [self queryBannerFromServerWithPostion:XKBannerPositionTop];
    
//    [self queryBannerFromCacheWithPostion:XKBannerPositionMiddle];
//    [self queryBannerFromServerWithPostion:XKBannerPositionMiddle];
    
    [[XKFDataService() messageService] addWeakDelegate:self];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeMemory completion:^{
            NSLog(@"清除缓存");
        }];
    }];
    
}

- (void)didReceiveMemoryWarning{
    //[super didReceiveMemoryWarning];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.searchController.active){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)dealloc{
    [[XKFDataService() messageService] removeWeakDelegate:self];
    [[XKFDataService() userService] removeWeakDelegate:self];
}


- (void)setNavigationBar{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_message"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction:)];
   // self.navigationItem.leftBarButtonItem.shouldHideBadgeAtZero = YES;
   // self.navigationItem.leftBarButtonItem.shouldAnimateBadge = YES;
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"saoyisao"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundColor:[UIColor whiteColor]];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateHighlighted];
    [searchBtn setTitle:@"  搜索喜扣优品，享实惠，更赚钱！" forState:UIControlStateNormal];
    [searchBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
    [searchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [searchBtn.titleLabel setFont:Font(12.f)];
    searchBtn.size = CGSizeMake(kScreenWidth - 30, 30);
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius  = 15.f;

    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchBtn;
    self.searchBtn = searchBtn;
}

- (void)setSearchBarController{
    HMSearchResultVC *controller = [[HMSearchResultVC alloc] initWithDelegate:self];
    controller.offsetY = kTopHeight;
    self.searchController = [[XKSearchVC alloc] initWithSearchResultsController:controller];
    self.searchController.searchResultsUpdater = controller;
    self.searchController.searchBar.delegate = controller;
    self.searchController.searchBar.placeholder = @"搜索喜扣优品，享实惠，更赚钱！";
    self.searchController.delegate = self;
    self.definesPresentationContext = YES;
   // self.navigationItem.titleView = self.searchController.searchBar;
    [RACObserve(self.searchController.searchBar, frame) subscribeNext:^(id  _Nullable x) {
        CGRect frame = [(NSValue *)x CGRectValue];
        if (CGRectGetMaxX(frame) > kScreenWidth-20) {
            self.searchController.searchBar.width = kScreenWidth-20.0f;
        }
    }];
}

- (void)setupFuctionView:(UIView *)frameView {
    frameView.backgroundColor = [UIColor whiteColor];
    frameView.layer.cornerRadius = 5;
    
    frameView.layer.shadowColor = HexRGB(0X000000, 0.1).CGColor;
    frameView.layer.shadowOffset = CGSizeMake(0,1);
    frameView.layer.shadowOpacity = 1;
    frameView.layer.shadowRadius = 15;
    CGRect shadowRect = CGRectMake(0, frameView.bounds.size.height, frameView.bounds.size.width, 3);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    frameView.layer.shadowPath = path.CGPath;
    NSArray *funImages = @[@"ic_discount",@"ic_wg",@"ic_globle",@"ic_brain",@"ic_free",@"ic_NewbieArea",@"ic_product",@"ic_task"];
    NSArray *funTitles = @[@"多买多折",@"吾G购",@"全球买手",@"砍立得",@"0元抢",@"新人专区",@"新品价到",@"任务中心"];
    CGFloat insert = scalef(24);
    CGFloat vSpace = 10;
    CGFloat width  = 60;
    CGFloat height = 61;
    CGFloat space  = (frameView.width - insert * 2 - width*4)/3;
    
    frameView.height = height*2 + vSpace * 3;
    
    for (int i=0; i<funImages.count; i++) {
        UIButton *funBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i < 4) {
            funBtn.frame = CGRectMake(insert + (space+width)*i, vSpace, width, height);
        }else{
            funBtn.frame = CGRectMake(insert + (space+width)*(i - 4), vSpace*2 + height, width, height);
        }
        funBtn.tag   = i;
        [funBtn setImage:[UIImage imageNamed:funImages[i]] forState:UIControlStateNormal];
        [funBtn setTitle:funTitles[i] forState:UIControlStateNormal];
        [funBtn setTitleColor:HexRGB(0X444444, 1.0) forState:UIControlStateNormal];
        funBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [funBtn setImageEdgeInsets:UIEdgeInsetsMake(-funBtn.titleLabel.intrinsicContentSize.height, 0, 0, -funBtn.titleLabel.intrinsicContentSize.width)];
        [funBtn setTitleEdgeInsets:UIEdgeInsetsMake(funBtn.currentImage.size.height+4, -funBtn.currentImage.size.width, 0, 0)];
        [funBtn addTarget:self action:@selector(clickedFunBtn:) forControlEvents:UIControlEventTouchUpInside];
        [frameView addSubview:funBtn];
        
    }
}

#pragma mark UI
- (void)setupUI {
    self.bannerView.frame = CGRectMake(0, 0, kScreenWidth,scalef(200.0f));
    [self.bannerView.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10.0f);
    }];
    //四个模块入口
    UIView *functionView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(self.bannerView.frame)-12.0f, kScreenWidth-20.0f,0)];
    [self setupFuctionView:functionView];
    [self.headerView addSubview:self.bannerView];
    [self.headerView addSubview:functionView];
    CGFloat y = CGRectGetMaxY(functionView.frame);
    
    self.headerView.frame  = CGRectMake(0, 0, kScreenWidth, y);
    
    self.qualityView.frame = CGRectMake(10.0f, y+10.0f, kScreenWidth-20.0f, scalef(28.0f));
    [self.qualityView addGestureRecognizer:self.tapGesture];
    [self.collectionView addSubview:self.qualityView];
    
    self.flowLayout.yInset = CGRectGetMaxY(self.qualityView.frame);
    
    [self.collectionView addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[HMReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HMReusableView"];
    [self.collectionView registerClass:[HMWgCell class] forCellWithReuseIdentifier:@"HMWgCell"];
    [self.collectionView registerClass:[HMBrainCell class] forCellWithReuseIdentifier:@"HMBrainCell"];
    [self.collectionView registerClass:[HMGlobleBuyerCell class] forCellWithReuseIdentifier:@"HMGlobleBuyerCell"];
    
    [self.collectionView registerClass:[HMMultiDiscountCell class] forCellWithReuseIdentifier:@"HMMultiDiscountCell"];
    
    [self.collectionView registerClass:[HMZeroBuyCell class] forCellWithReuseIdentifier:@"HMZeroBuyCell"];
    
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
}

- (void)autolayout{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

/***************************请求数据**********************************/

- (void)dealActivityModel:(XKHomeActivityModel *)activityModel{
    [self.activityModels removeAllObjects];
    if (activityModel.homeBargainActivityModel.homeBargainCommodityModels.count > 0) {
        [self.activityModels addObject:activityModel.homeBargainActivityModel];
    }
    if (activityModel.homeAuctionActivityModel && activityModel.homeAuctionActivityModel.homeAuctionCommodityModels.count > 0) {
        [self.activityModels addObject:activityModel.homeAuctionActivityModel];
    }
//    if (activityModel.homeBuyGiftActivityModel && activityModel.homeBuyGiftActivityModel.homeBuyGiftCommodityModels.count > 0) {
//        [self.activityModels addObject:activityModel.homeBuyGiftActivityModel];
//    }
   
    if (activityModel.homeDiscountActivityModel && activityModel.homeDiscountActivityModel.homeDiscountCommodityModels.count > 0) {
           [self.activityModels addObject:activityModel.homeDiscountActivityModel];
       }
    
    if (activityModel.homePageGlobalBuyerActivityModel && activityModel.homePageGlobalBuyerActivityModel.homeGlobalBuyerCommodityModels.count > 0){
        [self.activityModels addObject:activityModel.homePageGlobalBuyerActivityModel];
    }
}

- (void)initDataFromCache{
    XKHomeActivityModel *activityModel = [[XKFDataService() homeService] activityModelFromCache];
    if (activityModel) {
        _activityModel = activityModel;
        [self dealActivityModel:activityModel];
        [self.collectionView reloadData];
    }
}

- (void)initDataFromServer{
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() homeService] queryHomePageActivityWithCompletion:^(XKHomeActivityResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if (response.isSuccess) {
            self->_activityModel = response.data;
            [self dealActivityModel:response.data];
            [self.collectionView reloadData];
        }else{
            [response showError];
        }
    }];
}

- (void)queryBannerFromServerWithPostion:(XKBannerPosition)position{
    XKBannerParams *params = [[XKBannerParams alloc] init];
    params.moudle = XKBannerMoudleHome;
    params.position = position;
    [[XKFDataService() homeService] queryBannerWithParams:params completion:^(XKBannerResponse * _Nonnull response) {
        if (response.isSuccess) {
            if (response.data.count > 0) {
                if (position == XKBannerPositionTop) {
                    [self.bannerView setDataSource:response.data];
                }
            }
        }
    }];
}

- (void)queryBannerFromCacheWithPostion:(XKBannerPosition)position{
    NSArray<XKBannerData *> *banners = [[XKFDataService() homeService] queryHomeBannerFromCacheWithPostion:position];
    if (banners.count > 0) {
        if (position == XKBannerPositionTop) {
            self.bannerView.dataSource = banners;
        }
    }
}

- (void)queryUnreadMsg{
    if (NO == [[XKAccountManager defaultManager] isLogin])return;
    @weakify(self);
    [[XKFDataService() messageService] queryUnReadMsgNumWithUserId:[[XKAccountManager defaultManager] userId] completion:^(XKMsgUnReadResponse * _Nonnull response) {
        @strongify(self);
        if ([response isSuccess]) {
            self->_msgUnreadData = response.data;
            self.navigationItem.leftBarButtonItem.shouldHideBadgeAtZero = YES;
            self.navigationItem.leftBarButtonItem.badgeValue = @(response.data.totalUnreadNum).stringValue;
        }
    }];
}

- (void)queryHomeData{
    @weakify(self)
    [[XKFDataService() homeService] queryHomePageActivityWithCompletion:^(XKHomeActivityResponse * _Nonnull response) {
        @strongify(self);
        [self.collectionView.mj_header endRefreshing];
        if (response.isSuccess) {
            self->_activityModel = response.data;
            [self dealActivityModel:response.data];
            [self.collectionView reloadData];
        }else{
            [response showError];
        }
    }];
}

- (void)loadNewData{
    [self queryBannerFromServerWithPostion:XKBannerPositionTop];
    //[self queryBannerFromServerWithPostion:XKBannerPositionMiddle];
    [self queryHomeData];
}

/****************collectionView 数据展示*****************/

#pragma mark collectionView 的代理和数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.activityModels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    XKHomeActivityBaseModel *model = [self.activityModels objectAtIndex:section];
    if (model.activityType == Activity_Discount) {
        XKHomeDiscountActivityModel *activityModel = (XKHomeDiscountActivityModel *)model;
        NSInteger count = activityModel.homeDiscountCommodityModels.count;
        return  count;
    }else if (model.activityType == Activity_Global){
        XKHomePageGlobalBuyerActivityModel *activityModel = (XKHomePageGlobalBuyerActivityModel *)model;
        NSInteger count = activityModel.homeGlobalBuyerCommodityModels.count;
        return  count;
    }else{
        return 1;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XKHomeActivityBaseModel *model = [self.activityModels objectAtIndex:indexPath.section];
    if (model.activityType == Activity_WG) {
        HMWgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HMWgCell" forIndexPath:indexPath];
        XKHomeBuyGiftActivityModel *activityModel = (XKHomeBuyGiftActivityModel *)model;
        cell.textLabel.text = activityModel.activityName?:@"吾G限时购";
        cell.detailTextLabel.text = activityModel.activityDesc?:@"购物即送双倍赠券";
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:activityModel.bannerUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        cell.dataSource = activityModel.homeBuyGiftCommodityModels;
        cell.delegate = self;
        return cell;
    }else if (model.activityType == Activity_Bargain){
        HMBrainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HMBrainCell" forIndexPath:indexPath];
        XKHomeBargainActivityModel *bargainActivityModel = (XKHomeBargainActivityModel *)model;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bargainActivityModel.bannerUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        cell.textLabel.text = bargainActivityModel.activityName?:@"砍立得";
        cell.detailTextLabel.text = bargainActivityModel.activityDesc?:@"分享好友 砍价得红包";
        cell.dataSource = bargainActivityModel.homeBargainCommodityModels;
        cell.delegate = self;
        return cell;
    }else if (model.activityType == Activity_ZeroBuy){
        HMZeroBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HMZeroBuyCell" forIndexPath:indexPath];
        XKHomeAuctionActivityModel *activityModel = (XKHomeAuctionActivityModel *)model;
        cell.textLabel.text = activityModel.activityName?:@"零元拍";
       // cell.detailTextLabel.text = activityModel.activityDesc?:@"距离结束";
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:activityModel.endTime.doubleValue/1000.0f];
        [cell startCountDownTime:date];
        
        cell.dataSource = activityModel.homeAuctionCommodityModels;
        cell.delegate = self;
        return cell;
    }else if (model.activityType == Activity_Global){
        HMGlobleBuyerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HMGlobleBuyerCell" forIndexPath:indexPath];
        XKHomePageGlobalBuyerActivityModel *globalBuyerActivityModel = (XKHomePageGlobalBuyerActivityModel *)model;
        XKGoodListModel *commodityModel = [globalBuyerActivityModel.homeGlobalBuyerCommodityModels objectAtIndex:indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[commodityModel.goodsImageUrl appendOSSImageWidth:384 height:384]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        cell.textLabel.text = commodityModel.commodityName;
        cell.couponLabel.value = commodityModel.deductionCouponAmount.doubleValue/100.00f;
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        [attr appendAttributedString:PriceDef(commodityModel.commodityPrice.doubleValue/100.00f)];
        [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
        [attr appendAttributedString:PriceDef_line(commodityModel.salePrice.doubleValue/100.00f)];
        cell.priceLabel.attributedText = attr;
        return cell;
    }else if (model.activityType == Activity_Discount){
        HMMultiDiscountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HMMultiDiscountCell" forIndexPath:indexPath];
        XKHomeDiscountActivityModel *discountActivityModel = (XKHomeDiscountActivityModel *)model;
        XKGoodListModel *commodityModel = [discountActivityModel.homeDiscountCommodityModels objectAtIndex:indexPath.row];
       
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:commodityModel.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        cell.textLabel.text = commodityModel.commodityName;
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        [attr appendAttributedString:PriceDef(commodityModel.commodityPriceOne.doubleValue/100.00f)];
        [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
        [attr appendAttributedString:PriceDef_line(commodityModel.salePrice.doubleValue/100.00f)];
        
        cell.priceLabel.attributedText = attr;
        if (commodityModel.rateThree) {
            cell.discountLabel.text = [NSString stringWithFormat:@" 封顶%@折 ",commodityModel.rateOne];
        }
        cell.saleNumLabel.text = [NSString stringWithFormat:@" 分享赚%.2f ",[commodityModel.shareAmount doubleValue]/100];
       // cell.saleNumLabel.text = [NSString stringWithFormat:@" 热销%ld件 ",commodityModel.salesVolume];
        //cell.saleNumLabel.hidden = YES;
        return cell;
        
    }
    return nil;
}


// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (![kind isEqualToString:UICollectionElementKindSectionHeader])return nil;
    XKHomeActivityBaseModel *model = [self.activityModels objectAtIndex:indexPath.section];
    if (!(model.activityType == Activity_Discount || model.activityType == Activity_Global)){ return nil;
    }
    HMReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HMReusableView" forIndexPath:indexPath];
    reusableView.delegate = self;
    reusableView.tag = indexPath.section;
    switch (model.activityType) {
        case Activity_Global:{
            XKHomePageGlobalBuyerActivityModel *activityModel = [self.activityModel homePageGlobalBuyerActivityModel];
            reusableView.textLabel.text = activityModel.activityName?:@"全球买手";
            reusableView.detailTextLabel.text = activityModel.activityDesc?:@"全球百款品牌大促销";
        }
            break;
        case Activity_Discount:{
            XKHomeDiscountActivityModel *activityModel = [self.activityModel homeDiscountActivityModel];
            reusableView.textLabel.text = activityModel.activityName?:@"多买多折";
            reusableView.detailTextLabel.text = activityModel.activityDesc?:@"多买多折扣 分享折上折";
        }
            break;
        default:
            break;
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XKHomeActivityBaseModel *model = [self.activityModels objectAtIndex:indexPath.section];
    if (model.activityType == Activity_WG) {
        [MGJRouter openURL:kRouterWg];
    }else if (model.activityType == Activity_Bargain){
        [MGJRouter openURL:kRouterBargain];
    }else if (model.activityType == Activity_ZeroBuy){
        [MGJRouter openURL:kRouterZeroBuy];
    }else if (model.activityType == Activity_Global){
        XKHomePageGlobalBuyerActivityModel *activityModel = [self.activityModel homePageGlobalBuyerActivityModel];
        XKGoodListModel *gModel = [activityModel.homeGlobalBuyerCommodityModels objectAtIndex:indexPath.row];
        [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Global),@"id":gModel.id} completion:nil];
    }else if (model.activityType == Activity_Discount){
        XKHomeDiscountActivityModel *activityModel = [self.activityModel homeDiscountActivityModel];
        XKGoodListModel *gModel = [activityModel.homeDiscountCommodityModels objectAtIndex:indexPath.row];
        [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Discount),@"id":gModel.id} completion:nil];
    }
}


- (XKActivityType)activityTypeWithSection:(NSInteger)section{
    XKHomeActivityBaseModel *model = [self.activityModels objectAtIndex:section];
    return model.activityType;
}

- (CGSize)sizeForItemAtSection:(NSInteger)section{
    XKHomeActivityBaseModel *model = [self.activityModels objectAtIndex:section];
    CGSize size = CGSizeZero;
    switch (model.activityType) {
        case Activity_WG:{
            size = CGSizeMake(kScreenWidth-20.0f, 252.0f);
        }
            break;
        case Activity_Bargain:{
            size = CGSizeMake(kScreenWidth-20.0f, 252.0f);
        }
            break;
        case Activity_ZeroBuy:{
             size = CGSizeMake(kScreenWidth-20.0f, 234.0f);
        }
            break;
        case Activity_Global:{
            size =   CGSizeMake((kScreenWidth-30.0f)/2.0f, (kScreenWidth-30.0f)/2.0f+78.0f);
        }
            break;
        case Activity_Discount:{
            size =   CGSizeMake((kScreenWidth-30.0f)/2.0f, (kScreenWidth-30.0f)/2.0f+78.0f);
        }
            break;
        default:
            break;
    }
    return size;
}



- (void)reusableView:(HMReusableView *)reusableView clickIt:(id)sender{
    XKHomeActivityBaseModel *model = [self.activityModels objectAtIndex:reusableView.tag];
    if (model.activityType == Activity_Global) {
        [MGJRouter openURL:kRouterGlobalBuy];
    }else if(model.activityType == Activity_Discount){
        [MGJRouter openURL:kRouterMutilBuy];
    }else{
        NSLog(@"其它活动");
    }
}

/**********cell 代理************/
- (void)clickGoodsCell:(CGGoodsCell *)cell atIndex:(NSInteger)index activityType:(XKActivityType)activityType{
    NSString *goodId = nil;
    if (activityType == Activity_WG) {
        XKHomeBuyGiftActivityModel *gifActivityModel = [self.activityModel homeBuyGiftActivityModel];
        XKGoodListModel *gModel = [gifActivityModel.homeBuyGiftCommodityModels objectAtIndex:index];
        goodId = gModel.id;
        
    }else if (activityType == Activity_Bargain){
        XKHomeBargainActivityModel *bargainActivityModel = [self.activityModel homeBargainActivityModel];
        XKGoodListModel *gModel = [bargainActivityModel.homeBargainCommodityModels objectAtIndex:index];
        goodId = gModel.id;
    }else if (activityType == Activity_ZeroBuy){
        XKHomeAuctionActivityModel *auctionActivityModel = [self.activityModel homeAuctionActivityModel];
        XKGoodListModel *gModel = [auctionActivityModel.homeAuctionCommodityModels objectAtIndex:index];
        goodId = gModel.id;
    }
    if (goodId) {
        [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(activityType),@"id":goodId} completion:nil];
    }
}

- (void)seeMoreGoodsWithActivityType:(XKActivityType)activityType{
    if (activityType == Activity_WG) {
        [MGJRouter openURL:kRouterWg];
    }else if (activityType == Activity_Bargain){
        [MGJRouter openURL:kRouterBargain];
    }else if (activityType == Activity_ZeroBuy){
        [MGJRouter openURL:kRouterZeroBuy];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = scalef(260)-33.0f;
    if (scrollView.contentOffset.y > height) {
        if (!self.searchBtn.isSelected) {
            [self.searchBtn setBackgroundColor:COLOR_VIEW_GRAY];
        }
        self.searchBtn.selected = YES;
        if (self.navigationBarStyle != XKNavigationBarStyleDefault) {
            self.navigationBarStyle = XKNavigationBarStyleDefault;
        }
    }else if (scrollView.contentOffset.y + 80 > height){
        CGFloat alpha = (scrollView.contentOffset.y + 80.0f - height)/80.0f;
        alpha = alpha > 1.0f ? 1.0f :alpha;
        [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageWithColor:HexRGB(0xffffff, alpha)] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = YES;
    }else{
        if (self.navigationBarStyle != XKNavigationBarStyleTranslucent) {
            self.navigationBarStyle = XKNavigationBarStyleTranslucent;
        }
        if (self.searchBtn.isSelected) {
            [self.searchBtn setBackgroundColor:[UIColor whiteColor]];
        }
        self.searchBtn.selected = NO;
    }
    if (scrollView.contentOffset.y<0) {
        CGFloat alpha = fabs(scrollView.contentOffset.y)/80.0f;
        self.navigationController.navigationBar.alpha = (1-alpha);
    }else{
        self.navigationController.navigationBar.alpha = 1.0f;
    }
}

- (void)readUnreadMsgWithService:(XKMessageService *)service msgData:(XKMsgData *)msgData{
    if (self.msgUnreadData.totalUnreadNum - 1 >= 0) {
        self.msgUnreadData.totalUnreadNum -= 1;
    }
    self.navigationItem.leftBarButtonItem.badgeValue = @(self.msgUnreadData.totalUnreadNum).stringValue;
}

- (void)readUnreadMsgWithService:(XKMessageService *)service msgTypeModel:(XKMsgTypeModel *)msgModel{
    int num =  self.msgUnreadData.totalUnreadNum - msgModel.unreadNum;
    if (num < 0) {
        num = 0;
    }
    self.msgUnreadData.totalUnreadNum = num;
    [self.msgUnreadData.typesList enumerateObjectsUsingBlock:^(XKMsgTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.id == msgModel.id) {
            obj.unreadNum = 0;
            *stop = YES;
        }
    }];
    self.navigationItem.leftBarButtonItem.badgeValue = @(self.msgUnreadData.totalUnreadNum).stringValue;
}

/*刷新token*/
- (void)refreshTokenWithService:(XKUserService *)service userInfo:(XKAccountData *)data{
    [self queryUnreadMsg];
}

- (void)loginWithService:(XKUserService *)service userInfo:(XKAccountData *)data{
    [self queryUnreadMsg];
}

- (void)logoutWithService:(XKUserService *)service userId:(NSString *)userId{
    self.navigationItem.leftBarButtonItem.badgeValue = @"0";
}

#pragma mark action
- (void)clickedFunBtn:(UIButton *)btn{
    switch (btn.tag) {
        case 0:{
            [MGJRouter openURL:kRouterMutilBuy];
        }
            break;
        case 1:{
            [MGJRouter openURL:kRouterWg];
        }
            break;
        case 2:{
            [MGJRouter openURL:kRouterGlobalBuy];
        }
            break;
        case 3:{
            [MGJRouter openURL:kRouterBargain];
        }
            break;
        case 4:{
            if (self.activityModel.homeAuctionActivityModel.homeAuctionCommodityModels.count) {
                [MGJRouter openURL:kRouterZeroBuy];
            }else{
                XKShowToast(@"活动正在筹划中");
            }
        }
            break;
        case 5:{
            [MGJRouter openURL:kRouterNewUser];
        }
            break;
        case 6:{
            [MGJRouter openURL:kRouterNewGoods];
        }
            break;
        default:{
            if([[XKAccountManager defaultManager] isLogin] == NO){
                [MGJRouter openURL:kRouterLogin];
                return;
            }
            MITaskVC *controller = [[MITaskVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
    }
}

- (void)leftItemAction:(id)sender{
    if ([[XKAccountManager defaultManager] isLogin]) {
        HMMessageVC *controller = [[HMMessageVC alloc] initWithUnreadData:self.msgUnreadData];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [MGJRouter openURL:kRouterLogin];
    }
}

- (void)actionForQuality{
    [MGJRouter openURL:kRouterWeb withUserInfo:@{@"url":@"https://static.luluxk.com/quality/index.html"} completion:nil];
}

- (void)rightItemAction:(id)sender{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *aleartMsg = @"请在\"设置 - 隐私 - 相机\"选项中，允许喜扣访问您的相机";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:aleartMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    HMQRVC *controller = [[HMQRVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)searchAction:(id)sender{
    [self.view insertSubview:self.searchController.searchBar atIndex:0];
    [self.searchController setActive:YES];
    self.currentBarStyle = self.navigationBarStyle;
    self.navigationBarStyle = XKNavigationBarStyleDefault;
}


/****************搜索**********************/
#pragma mark 搜索控制器 的代理
- (void)willPresentSearchController:(UISearchController *)searchController{
    [self.navigationController setNavigationBarHidden:YES];
    [[self.searchController searchBar] setHidden:NO];
    [self setupSearch];
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    [[self.searchController searchBar] setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self.searchController.searchBar resignFirstResponder];
     self.navigationBarStyle = self.currentBarStyle;
}

- (void)searchResult:(UIViewController *)controller searchText:(NSString *)text{
    if ([NSString isNull:text] == NO) {
        [MGJRouter openURL:kRouterSearchGoods withUserInfo:@{@"searchText":text} completion:nil];
    }
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
        self.historyView.origin = CGPointMake(15.0f, 80.0f+[XKUIUnitls safeTop]);
    }

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

- (UIView *)createViewSectionTitle:(NSString *)sectionTitle searchtitles:(NSArray<NSString *> *)searchTitles canDelete:(BOOL)delete{
    if (searchTitles.count <= 0) {
        return nil;
    }
    CGFloat width = kScreenWidth-30.0f;
    UIView *view = [[UIView alloc] init];
    view.tag = 111;
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
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        button.layer.cornerRadius = 2.0f;
        button.tag = idx;
        [button setTitle:obj forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        button.backgroundColor = COLOR_VIEW_GRAY;
        [button setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10.0f, 0, 10.0f);
        [button sizeToFit];
        if (button.width > (kScreenWidth - 60.0f)) {
            button.width = kScreenWidth-60.0f;
        }
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
                [MGJRouter openURL:kRouterSearchGoods withUserInfo:@{@"searchText":button.titleLabel.text} completion:nil];
            }
        }];
        lastBtn = button;
    }];
    view.size = CGSizeMake(width, lastBtn.bottom);
    return view;
}


#pragma mark getter or setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (HMFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[HMFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.delegate = self;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10.0f, 0, 10.0f);
        //_flowLayout.sectionHeadersPinToVisibleBounds = YES;
    }
    return _flowLayout;
}

- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc] init];
    }
    return _bannerView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}

- (HMQualityView *)qualityView{
    if (!_qualityView) {
        _qualityView = [[HMQualityView alloc] init];
    }
    return _qualityView;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForQuality)];
    }
    return _tapGesture;
}

- (NSMutableArray <XKHomeActivityBaseModel *> *)activityModels{
    if (!_activityModels) {
        _activityModels = [NSMutableArray array];
    }
    return _activityModels;
}

@end
