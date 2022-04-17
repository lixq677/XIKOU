//
//  HMLimitBuyBaseVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/18.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMLimitBuyBaseVC.h"
#import "HMLimitBuyChildVC.h"
#import "HMWgLimitBuyHeaderView.h"
#import "XKCategoryView.h"
#import "XKShareTool.h"
#import "XKActivityService.h"
#import "XKAccountManager.h"
#import "MJDIYHeader.h"

@interface HMLimitBuyBaseVC ()<XKCategoryDelegate>

@property (nonatomic, strong) XKCategoryView *categoryView;

@property (nonatomic, strong) HMWgLimitBuyHeaderView *headerView;

@property (nonatomic, strong) ACTMoudleModel *topModel;//头部模块

@property (nonatomic, strong) ACTMoudleModel *multiChildModel;//多个子分类的模块

@property (nonatomic, strong) UILabel *segeTitleLabel;

@property (nonatomic, strong) UIView *headView;
@end

@implementation HMLimitBuyBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"吾G限量购";
    [self addNavigationItemWithImageName:@"hm_share" isLeft:NO target:self action:@selector(rightClick)];
    [self initData];
    self.pagerView.mainTableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMoudleData)];
}

- (void)rightClick{
    NSString *activityId = @"";
    for (XKGoodListModel *gModel in self.topModel.commodityList) {
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

- (void)initData{
    /*从缓存中获取模块信息*/
    ACTMoudleData *moduleData = [[XKFDataService() actService] queryModuleDataFromCache:Activity_WG];
    [self handleData:moduleData];
    
    /*从服务器获取模块信息*/
    [self getMoudleData];
}

// 获取模块信息
- (void)getMoudleData{
    
    [[XKFDataService() actService]getActivityMoudleByActivityType:Activity_WG Complete:^(ACTMoudleResponse * _Nonnull response) {
        if ([response isSuccess]) {
            [self handleData:response.data];
            
        }else{
            [response showError];
        }
        [self.pagerView.mainTableView.mj_header endRefreshing];
    }];
}

- (void)handleData:(ACTMoudleData *)data{
    [self.headerView reloadBanner:data.bannerList];
    self.headView.height = self.headerView.height + 42;
    
    [self.pagerView reloadData];
    for (int i = 0; i < data.sectionList.count; i++) {
        ACTMoudleModel *model = [data.sectionList objectAtIndex:i];
        if (i == 0) {
            [self getTopModelDataFromCache:model];
            [self getTopGoodData:model];
        }else if (i == 1){
            self.multiChildModel = model;
            [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
            [self.multiChildModel.childSectionList enumerateObjectsUsingBlock:^(ACTMoudleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HMLimitBuyChildVC *vc = [[HMLimitBuyChildVC alloc] init];
                vc.categoryid = obj.id;
                [self addChildViewController:vc];
            }];
        }
    }
    [self.pagerView reloadData];
    [self.categoryView reloadData];
    self.segeTitleLabel.text = self.multiChildModel.categoryName;
    
}

//获取wg头部商品信息
- (void)getTopGoodData:(ACTMoudleModel *)model{
    self.topModel = model;
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    [[XKFDataService() actService]getGoodListByActivityType:Activity_WG andCategoryId:model.id andPage:1 andLimit:10 andUserId:userId Complete:^(ACTGoodListRespnse * _Nonnull response) {
        if ([response isSuccess]) {
            ACTGoodListData *data = response.data;
            [self.topModel.commodityList removeAllObjects];
            [self.topModel.commodityList addObjectsFromArray:data.result];
            [self.headerView reloadMoudleData:self.topModel];
        }else{
            [response showError];
        }
    }];
}

- (void)getTopModelDataFromCache:(ACTMoudleModel *)model{
    self.topModel = model;
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    NSArray<XKGoodListModel *> *list = [[XKFDataService() actService] queryGoodListModelFromCacheByActivityType:Activity_WG andCategoryId:model.id andPage:1 andLimit:10 andUserId:userId];
    [self.topModel.commodityList removeAllObjects];
    [self.topModel.commodityList addObjectsFromArray:list];
    [self.headerView reloadMoudleData:self.topModel];
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headView;
}
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.headView.height;
}
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView.height;
}
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.childViewControllers.count;
}
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    HMLimitBuyChildVC *vc = (HMLimitBuyChildVC *)[self.childViewControllers objectAtIndex:index];
    return vc;
}

#pragma mark xkCategoryDelegate
- (NSInteger)numberOfItems{
    return self.multiChildModel.childSectionList.count;
}
- (NSString *)titleOfSegementAtIndex:(NSInteger)index{
    ACTMoudleModel *model = self.multiChildModel.childSectionList[index];
    return model.categoryName;
}
- (void)categorySelectIndex:(NSInteger)index{
    NSInteger diffIndex = labs(self.categoryView.currentIndex - index);
    if (diffIndex > 1) {
        [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else {
        [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >= self.headView.height) {
        self.categoryView.backgroundColor = [UIColor whiteColor];
    }else{
        self.categoryView.backgroundColor = COLOR_VIEW_GRAY;
    }
}


#pragma mark - JXPagerMainTableViewGestureDelegate
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer ||
        otherGestureRecognizer == self.headerView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (HMWgLimitBuyHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HMWgLimitBuyHeaderView alloc]init];
    }
    return _headerView;
}

- (XKCategoryView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[XKCategoryView alloc]initWithStyle:CategorySingleTitle andDelegate:self andFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
        _categoryView.backgroundColor = COLOR_VIEW_GRAY;
    }
    return _categoryView;
}

- (UILabel *)segeTitleLabel{
    if (!_segeTitleLabel) {
        _segeTitleLabel = [[UILabel alloc]init];
        _segeTitleLabel.font = FontMedium(17.f);
        _segeTitleLabel.textColor = COLOR_TEXT_BLACK;
        _segeTitleLabel.text = @"限时抢购";
    }
    return _segeTitleLabel;
}

- (UIView *)headView{
    if (!_headView) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        headView.backgroundColor = COLOR_VIEW_GRAY;
        [headView xk_addSubviews:@[self.segeTitleLabel,self.headerView]];
        [self.segeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.equalTo(self.headerView.mas_bottom).offset(20);
            make.height.mas_equalTo(17);
            make.bottom.equalTo(headView);
        }];
        headView.height = self.headerView.height + 52;
        _headView = headView;
    }
    return _headView;
}
@end
