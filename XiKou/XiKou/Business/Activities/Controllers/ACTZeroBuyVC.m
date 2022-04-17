//
//  ACTZeroBuyVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTZeroBuyVC.h"
#import "ACTZeroBuyChildVC.h"
#import "XKCategoryView.h"
#import "ACTZeroBuyHeadView.h"
#import "XKShareTool.h"
#import "XKActivityService.h"
#import "XKAccountManager.h"

@interface ACTZeroBuyVC ()<XKCategoryDelegate>

@property (nonatomic, strong) ACTZeroBuyHeadView *headInfoView;

@property (nonatomic, strong) XKCategoryView *categoryView;

@property (nonatomic, strong) ACTMoudleModel *topModel;//头部模块

@property (nonatomic, copy) NSArray *rounds;

@property (nonatomic, strong) UILabel *segeTitleLabel;

@property (nonatomic, strong) UIView *headView;

@end

@implementation ACTZeroBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self loadData];
}


- (void)initSubView{
    self.title = @"0元抢";
    [self addNavigationItemWithImageName:@"hm_share" isLeft:NO target:self action:@selector(rightClick)];
    [self setNavigationBarStyle:XKNavigationBarStyleDefault];
    @weakify(self);
    self.pagerView.mainTableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData];
    }];
    [self.pagerView reloadData];
}

- (void)loadData{
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable){
        [self showNoNetworkRelaodSel:@selector(loadData)];
        return;
    }
    [self hideNoNetwork];
    [self getRound];
    [self getMoudleData];
}

// 获取模块信息
- (void)getMoudleData{
    
    [[XKFDataService() actService]getActivityMoudleByActivityType:Activity_ZeroBuy Complete:^(ACTMoudleResponse * _Nonnull response) {
        if ([response isSuccess]) {
            [self handleMoudleAandBannerData:response.data];
        }else{
            [response showError];
        }
    }];
}
//获取时间轮次
- (void)getRound{
    [[XKFDataService() actService]getRoundByType:Activity_ZeroBuy Complete:^(ACTRoundRespnse * _Nonnull response) {
        if ([response isSuccess]) {
            self.rounds = response.data;
            [self handleData];
            [self.pagerView.mainTableView.mj_header endRefreshing];
        }else{
            [response showError];
        }
    }];
}

- (void)handleMoudleAandBannerData:(ACTMoudleData *)data{
    [self.headInfoView reloadBanner:data.bannerList];
}

- (void)handleData{
    if (self.rounds.count > 0) {
        ACTRoundModel *model = [self.rounds firstObject];
        _topModel = [ACTMoudleModel new];
        _topModel.categoryName = @"倒计时专区";
        [self.headInfoView reloadTimer:model.endTime];
        if (model.state == Round_UnBegin) {
            [self.headInfoView.timeView hideCountTime:YES];
        }else{
            [self.headInfoView.timeView hideCountTime:NO];
        }
        [self dataRequestWithId:model.id];
    }
//    else{
//        ACTRoundModel *model = [ACTRoundModel new];
//        model.roundTitle = @"暂无活动";
//        model.state = Round_UnBegin;
//        self.rounds = @[model];
//    }
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self.pagerView reloadData];
    [self.categoryView reloadData];
}

- (void)dataRequestWithId:(NSString *)roundId{
    
    NSMutableArray<XKGoodModel *> *goodModels = [NSMutableArray array];
    NSMutableArray<ACTGoodAuctionModel *> *auctionModels = [NSMutableArray array];
    dispatch_queue_t queueT = dispatch_queue_create("group.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t grpupT = dispatch_group_create();
    
    dispatch_group_async(grpupT, queueT, ^{ //商品列表
        dispatch_group_enter(grpupT);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[XKFDataService() actService]getRoundGoodListByRoundId:roundId Complete:^(ACTRoundGoodListRespnse * _Nonnull response) {
                if ([response isSuccess]) {
                    [goodModels addObjectsFromArray:response.data];
                }else{
                    [response showError];
                }
                dispatch_group_leave(grpupT);
            }];
        });
    });
    dispatch_group_async(grpupT, queueT, ^{//商品竞拍信息列表
        dispatch_group_enter(grpupT);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[XKFDataService() actService]getGoodAuctionInfoByRoundId:roundId Complete:^(ACTGoodAuctionRespnse * _Nonnull response) {
                if ([response isSuccess]) {
                    [auctionModels addObjectsFromArray:response.data];
                }else{
                    [response showError];
                }
                dispatch_group_leave(grpupT);
            }];
        });
    });
    dispatch_group_notify(grpupT, queueT, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [goodModels enumerateObjectsUsingBlock:^(XKGoodModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ACTGoodAuctionModel *auc = nil;
                if (idx < auctionModels.count) {
                    auc = [auctionModels objectAtIndex:idx];
                }
                obj.adctionModel = auc;
            }];
            if (goodModels.count > 0) {
                self.topModel.commodityList = (NSMutableArray<XKGoodListModel *> *)goodModels;
            }
            [self.headInfoView reloadMoudleData:self.topModel];
            [self.pagerView reloadData];
        });
    });
}


- (void)rightClick{
    NSString *activityId = @"";//自己动手，丰衣足食，到处取需要的数据
    for (ACTZeroBuyChildVC *vc in self.childViewControllers) {
        for (XKGoodListModel *model in vc.dataArray) {
            activityId = model.activityId;
            break;
        }
    }
    if (activityId.length == 0) {
        XKShowToast(@"获取分享数据失败");
        return;
    };
    
    XKShareRequestModel *model = [XKShareRequestModel new];
    model.shopId = @"";//不要问我为什么，不传系统就要溜号了
    model.activityId = activityId;
    model.shareUserId = [XKAccountManager defaultManager].account.userId ? [XKAccountManager defaultManager].account.userId : @"";
    model.popularizePosition = SPActivityAuction;
    
    [[XKShareTool defaultTool]shareWithModel:model andTitle:@"分享到好友" andContent:nil andNeedPhoto:NO andUIType:ShareUIBottom];
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headView;
}
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return  self.headView.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return JXheightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.rounds.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    ACTRoundModel *model = _rounds[index];
    ACTZeroBuyChildVC *vc = [[ACTZeroBuyChildVC alloc]init];
    vc.roundId = model.id;
    [self addChildViewController:vc];
    return vc;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >= self.headView.height) {
        self.categoryView.backgroundColor = [UIColor whiteColor];
    }else{
        self.categoryView.backgroundColor = COLOR_VIEW_GRAY;
    }
}

#pragma mark xkSegementDelegate
- (NSInteger)numberOfItems{
    if (self.rounds.count == 0) {
        self.pagerView.mainTableView.contentSize = CGSizeMake(0, self.headView.height);
    }
    return self.rounds.count;
}
- (NSString *)titleOfSegementAtIndex:(NSInteger)index{
    ACTRoundModel *model = _rounds[index];
    return model.roundTitle;
}
- (NSString *)subTitleOfSegementAtIndex:(NSInteger)index{
    ACTRoundModel *model = _rounds[index];
    if (model.state == Round_UnBegin) {
        return @"未开始";
    }
    if (model.state == Round_Ing) {
        return @"进行中";
    }
    return @"已结束";
}
- (void)categorySelectIndex:(NSInteger)index{
    NSInteger diffIndex = labs(self.categoryView.currentIndex - index);
    if (diffIndex > 1) {
        [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else {
        [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - JXPagerMainTableViewGestureDelegate
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer ||
        otherGestureRecognizer == self.headInfoView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (XKCategoryView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[XKCategoryView alloc]initWithStyle:CategorySubTitle andDelegate:self andFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    }
    return _categoryView;
}
- (ACTZeroBuyHeadView *)headInfoView{
    if (!_headInfoView) {
        _headInfoView = [[ACTZeroBuyHeadView alloc]initWithType:Head_ZeroBuy];
        [_headInfoView.timeView hideCountTime:YES];
    }
    return _headInfoView;
}

- (UILabel *)segeTitleLabel{
    if (!_segeTitleLabel) {
        _segeTitleLabel = [UILabel new];
        _segeTitleLabel.textColor = COLOR_TEXT_BLACK;
        _segeTitleLabel.font = FontMedium(17.f);
        _segeTitleLabel.text = @"正在热拍";
    }
    return _segeTitleLabel;
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]init];
        _headView.backgroundColor = COLOR_VIEW_GRAY;
        [_headView xk_addSubviews:@[self.segeTitleLabel,self.headInfoView]];
        _segeTitleLabel.frame = CGRectMake(10, self.headInfoView.bottom + 20, kScreenWidth - 20, 17);
        _headView.frame = CGRectMake(0, 0,kScreenWidth , self.segeTitleLabel.bottom);
    }
    return _headView;
}


@end
