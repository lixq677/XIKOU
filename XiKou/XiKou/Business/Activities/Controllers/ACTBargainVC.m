//
//  ACTBargainVC2.m
//  XiKou
//
//  Created by L.O.U on 2019/8/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTBargainVC.h"
#import "ACTTitleView.h"
#import "ACTBannerCollectionCell.h"
#import "ACTBargainGoodCell.h"
#import "ACTGoodCardCell.h"
#import "MJDIYFooter.h"

#import "XKBargainGoodDetailVC.h"
#import "ACTBargainDetailVC.h"
#import "XKShareTool.h"

#import "UILabel+NSMutableAttributedString.h"
#import "XKActivityService.h"
#import "XKUserService.h"
#import "XKOrderService.h"
#import "TABAnimated.h"

@interface ACTBargainVC ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
XKUserServiceDelegate,
XKOrderServiceDelegate,
ACTBrainCardCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<XKBannerData *> *bannerArray;

@property (nonatomic, strong) NSMutableArray<ACTMoudleModel *> *sectionArray;

@property (nonatomic, strong) XKBannerData *middleImgData;

@property (nonatomic,assign)NSUInteger curPage;

@end

static const CGFloat space = 10;
static const int kPageCount =   10;

@implementation ACTBargainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAnimation];
    [self instanceUI];
    [self addRefresh];
    [[XKFDataService() userService] addWeakDelegate:self];
    [[XKFDataService() orderService] addWeakDelegate:self];
    // Do any additional setup after loading the view.
}

#pragma mark UI
- (void)instanceUI{
    
    self.title = @"砍立得";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addNavigationItemWithImageName:@"hm_share" isLeft:NO target:self action:@selector(shareAction)];
    
}

- (void)initAnimation{
    
    NSArray *classArray = @[[ACTBannerCollectionCell class],
                            [ACTGoodCardCell class],
                            [ACTBargainGoodCell class]];
    NSArray *sizeArray  = @[[NSValue valueWithCGSize:CGSizeMake(kScreenWidth, scalef(180))],
                            [NSValue valueWithCGSize:CGSizeMake((kScreenWidth - space*4)/3-0.1, (kScreenWidth - space*4)/3-0.1)],
                            [NSValue valueWithCGSize:CGSizeMake(kScreenWidth - space*2, 140)]
                            ];
    
    self.collectionView.tabAnimated = [TABCollectionAnimated animatedWithCellClassArray:classArray
                                                                          cellSizeArray:sizeArray
                                                                     animatedCountArray:@[@1,@3,@1]];
    [self.collectionView.tabAnimated addFooterViewClass:[ACTImageFootView class]
                                               viewSize:CGSizeMake(kScreenWidth, scalef(110.f))
                                              toSection:1];
    self.collectionView.tabAnimated.superAnimationType   = TABViewSuperAnimationTypeOnlySkeleton;
    self.collectionView.tabAnimated.animatedCornerRadius = 5;
    self.collectionView.tabAnimated.animatedSectionCount = 3;
    self.collectionView.tabAnimated.adjustWithClassBlock = ^(TABComponentManager * _Nonnull manager, Class  _Nonnull __unsafe_unretained targetClass) {
        if (targetClass == ACTBargainGoodCell.class) {
            manager.animation(2).down(5);
            manager.animation(4).width(CGFLOAT_MIN);
            manager.animation(6).width(CGFLOAT_MIN);
            manager.animation(8).width(CGFLOAT_MIN);
        }
        if (targetClass == ACTTitleView.class || targetClass == ACTImageFootView.class) {
            manager.animatedBackgroundColor = COLOR_VIEW_GRAY;
        }
    };
    [self.collectionView tab_startAnimationWithCompletion:^{
        [self initData];
    }];
}

- (void)initData{
    
    self.curPage = 1;
    self.bannerArray = [NSMutableArray array];
    self.sectionArray = [NSMutableArray array];
    
    /*从服务器获取模块信息*/
    [self getMoudleData];
}

#pragma mark Datarequest
- (void)addRefresh{
    @weakify(self);
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self getMoudleData];
    }];
    self.collectionView.mj_footer = [MJDIYFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.sectionArray.count < 2) return;
        [self loadMoreData];
    }];
}

// 获取模块信息
- (void)getMoudleData{
    [[XKFDataService() actService]getActivityMoudleByActivityType:Activity_Bargain Complete:^(ACTMoudleResponse * _Nonnull response) {
        if ([response isSuccess]) {
            [self handleData:response.data];
        }else{
            [response showError];
        }
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)handleData:(ACTMoudleData *)data{
    [self.bannerArray removeAllObjects];
    for (XKBannerData *model in data.bannerList) {
        if (model.position == XKBannerPositionTop) {
            [self.bannerArray addObject:model];
        }
        if (model.position == XKBannerPositionMiddle) {
            self.middleImgData = model;
        }
    }
    NSUInteger page = 1;
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    NSMutableArray<ACTMoudleModel *> *modules = [NSMutableArray array];
    dispatch_group_t  group = dispatch_group_create();
    for (int i = 0; i< data.sectionList.count; i++) {
        dispatch_group_enter(group);
        ACTMoudleModel *moudle= data.sectionList[i];
        [[XKFDataService() actService]getGoodListByActivityType:Activity_Bargain andCategoryId:moudle.id andPage:page andLimit:kPageCount andUserId:userId Complete:^(ACTGoodListRespnse * _Nonnull response) {
            if ([response isSuccess]) {
                self.curPage = page;
                ACTGoodListData *listData = response.data;
                [moudle.commodityList addObjectsFromArray:listData.result];
                if (i >= modules.count) {
                    [modules addObject:moudle];
                }else{
                    [modules insertObject:moudle atIndex:i];
                }
                if(i == data.sectionList.count-1){
                    if (listData.result.count < kPageCount) {
                        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.collectionView.mj_footer endRefreshing];
                    }
                }
            }else{
                [response showError];
            }
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
        [self.sectionArray removeAllObjects];
        [self.sectionArray addObjectsFromArray:modules];
        [self.collectionView reloadData];
        [self.collectionView tab_endAnimation];
    });
    if (!self.collectionView.ly_emptyView) {
        self.collectionView.ly_emptyView = [XKEmptyView goodListNoDataView];
    }
}

//获取砍立得最新商品信息
- (void)getMoudleGoodData:(ACTMoudleModel *)model andIndex:(NSInteger)index{
    
}

//请求网络数据
- (void)loadMoreData{
    if (self.sectionArray.count < 2) {
        return;
    }
    ACTMoudleModel *moudle= self.sectionArray.lastObject;
    @weakify(self);
    [self.collectionView ly_startLoading];
    
    NSUInteger page = 1;
    page = self.curPage + 1;
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    [[XKFDataService() actService]getGoodListByActivityType:Activity_Bargain andCategoryId:moudle.id andPage:page andLimit:10 andUserId:userId Complete:^(ACTGoodListRespnse * _Nonnull response) {
        @strongify(self);
        [self.collectionView ly_endLoading];
        if (response.isSuccess) {
            NSArray<XKGoodListModel *> *results = [response.data result];
            [moudle.commodityList addObjectsFromArray:results];
            [self.collectionView reloadData];
            self.curPage = page;
            if (results.count < 10) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.collectionView.mj_footer endRefreshing];
            }
        }else{
            [self.collectionView.mj_footer endRefreshing];
            [response showError];
        }
    }];
}

/**
 下面俩个方法 登录状态改变刷新页面

 */
- (void)loginWithService:(XKUserService *)service userInfo:(XKAccountData *)data{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)logoutWithService:(XKUserService *)service userId:(NSString *)userId{//退出登录 代理
    [self.collectionView.mj_header beginRefreshing];
}

/**
 生成订单成功
 */
- (void)creatOrderSuccessComplete{
    [self getMoudleData];
}

#pragma mark action
- (void)shareAction{
    NSString *activityId = @"";
    for (ACTMoudleModel *model in self.sectionArray) {
        for (XKGoodListModel *gModel in model.commodityList) {
            activityId = gModel.activityId;
            break;
        }
        if (activityId.length > 0) break;
    }

    if (activityId.length == 0) {
        XKShowToast(@"获取分享数据失败");
        return;
    };

    XKShareRequestModel *model = [XKShareRequestModel new];
    model.shopId = @"";//不要问我为什么，不传系统就要溜号了
    model.activityId = activityId;
    model.shareUserId = [XKAccountManager defaultManager].account.userId ? [XKAccountManager defaultManager].account.userId : @"";
    model.popularizePosition = SPActivityBargain;

    [[XKShareTool defaultTool]shareWithModel:model andTitle:@"分享到好友" andContent:nil andNeedPhoto:NO andUIType:ShareUIBottom];
}

#pragma mark collcetionView delegate && dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
 
    return self.bannerArray.count > 0 ? self.sectionArray.count + 1 : self.sectionArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else{
        ACTMoudleModel *moudleModel = self.sectionArray[section - 1];
        return moudleModel.commodityList.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ACTBannerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTBannerCollectionCell identify] forIndexPath:indexPath];
        [cell.bannerView setDataSource:self.bannerArray];
        return cell;
    }else if (indexPath.section == 1) {
        ACTBrainCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTBrainCardCell identify] forIndexPath:indexPath];
        cell.delegate = self;
        ACTMoudleModel *model = self.sectionArray[0];
        [cell setDataSource:model.commodityList];
        
        return cell;
    }else{
        ACTBargainGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTBargainGoodCell identify] forIndexPath:indexPath];
        
        ACTMoudleModel *model = self.sectionArray[indexPath.section - 1];
        cell.model = model.commodityList[indexPath.item];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        ACTTitleView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[ACTTitleView identify] forIndexPath:indexPath];
        headView.tag          = indexPath.section;
        headView.needIndicate = NO;
        
        if (indexPath.section > 0) {
            ACTMoudleModel *model = self.sectionArray[indexPath.section - 1];
            headView.title        = model.categoryName;
        }
        return headView;
    }
    
    ACTImageFootView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[ACTImageFootView identify] forIndexPath:indexPath];
     if (self.middleImgData && indexPath.section == 1) {
          [foot loadFootImageView:self.middleImgData.imageUrl];
      }
    return foot;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, scalef(200));
    }
    if (indexPath.section == 1) {
        CGFloat width = (kScreenWidth - space*4)/3.f;
        return CGSizeMake(kScreenWidth-space*2, width);
    }
    return CGSizeMake(kScreenWidth - space*2, 140);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0){
        return CGSizeMake(kScreenWidth, CGFLOAT_MIN);
    }
    return CGSizeMake(kScreenWidth, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == 1 && self.middleImgData){
        return CGSizeMake(kScreenWidth, scalef(110));
    }
    return CGSizeMake(kScreenWidth, CGFLOAT_MIN);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (section == 0){
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    if (section == 1){
        return UIEdgeInsetsMake(0, space, space, space);
    }
    
    return UIEdgeInsetsMake(0, space, 0, space);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    
    ACTMoudleModel *model = self.sectionArray[indexPath.section - 1];
    XKGoodListModel *gModel = model.commodityList[indexPath.item];
    
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Bargain),@"id":gModel.id} completion:nil];
}

- (void)clickGoodsCell:(ACTBrainCardCell *)cell atIndex:(NSUInteger)index{
    ACTMoudleModel *model = self.sectionArray[0];
    XKGoodListModel *gModel = model.commodityList[index];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Bargain),@"id":gModel.id} completion:nil];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = space;
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = COLOR_VIEW_GRAY;
        [_collectionView registerClass:[ACTBrainCardCell class]
            forCellWithReuseIdentifier:[ACTBrainCardCell identify]];
        [_collectionView registerClass:[ACTBargainGoodCell class]
            forCellWithReuseIdentifier:[ACTBargainGoodCell identify]];
        [_collectionView registerClass:[ACTBannerCollectionCell class]
            forCellWithReuseIdentifier:[ACTBannerCollectionCell identify]];
        [_collectionView registerClass:[ACTTitleView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:[ACTTitleView identify]];
        [_collectionView registerClass:[ACTImageFootView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:[ACTImageFootView identify]];
    }
    return _collectionView;
}

- (void)dealloc{
    [[XKFDataService() userService]removeWeakDelegate:self];
    [[XKFDataService() orderService]removeWeakDelegate:self];
}
@end
