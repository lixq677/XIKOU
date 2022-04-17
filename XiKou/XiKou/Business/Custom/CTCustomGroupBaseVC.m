//
//  CTCustomGroupBaseVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CTCustomGroupBaseVC.h"
#import "CTCustomGroupChildVC.h"
#import "XKSegmentView.h"
#import "XKBannerView.h"
#import "XKShareTool.h"
#import "XKActivityService.h"
#import "XKAccountManager.h"

@interface CTCustomGroupBaseVC ()<XKSegmentViewDelegate>

@property (nonatomic,strong) XKSegmentView *segmentView;

@property (nonatomic,strong) XKBannerView *bannerView;

@property (nonatomic,strong) NSArray<ACTMoudleModel *> *moudleArray;

@property (nonatomic,strong) UIView *segmentBaseView;

@property (nonatomic,strong) NSMutableDictionary<NSString*, CTCustomGroupChildVC *> *childControllers;

@end

@implementation CTCustomGroupBaseVC
@synthesize  childControllers = _childControllers;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"定制拼团";
    [self addNavigationItemWithImageName:@"hm_share" isLeft:NO target:self action:@selector(shareClick)];
    [self getMoudleData];
    ACTMoudleData *moduleData = [[XKFDataService() actService] queryModuleDataFromCache:Activity_Custom];
    [self handleData:moduleData];
}

#pragma mark ---------------------获取分享的数据
- (void)shareClick{
    NSString *activityId = @"";//自己动手，丰衣足食，到处取需要的数据
    for (CTCustomGroupChildVC *vc in self.childViewControllers) {
        for (XKGoodListModel *model in vc.dataArray) {
            activityId = model.activityId;
            break;
        }
        if ([NSString isNull:activityId] == NO) {
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
    model.popularizePosition = SPActivityCustom;

    [[XKShareTool defaultTool]shareWithModel:model andTitle:@"分享到好友" andContent:nil andNeedPhoto:NO andUIType:ShareUIBottom];
}

// 获取模块信息
- (void)getMoudleData{
    [[XKFDataService() actService] getActivityMoudleByActivityType:Activity_Custom Complete:^(ACTMoudleResponse * _Nonnull response) {
        if ([response isSuccess]) {
            [self handleData:response.data];
        }else{
            [response showError];
        }
    }];
}

- (void)handleData:(ACTMoudleData *)data{
    [self.bannerView setDataSource:data.bannerList];
    self.moudleArray = data.sectionList;
    NSMutableArray *array = [NSMutableArray array];
    for (ACTMoudleModel *model in _moudleArray) {
        [array addObject:model.categoryName];
    }
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromParentViewController];
    }];
    [self.moudleArray enumerateObjectsUsingBlock:^(ACTMoudleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CTCustomGroupChildVC *vc = [[CTCustomGroupChildVC alloc] init];
        vc.categoryid = obj.id;
        [self addChildViewController:vc];
    }];
    self.segmentView.titles = array;
    [self.pagerView reloadData];
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.bannerView;
}
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.bannerView.height;
}
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.segmentBaseView.height;
}
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.segmentBaseView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.childViewControllers.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    //ACTMoudleModel *model = self.moudleArray[index];
    CTCustomGroupChildVC *vc = (CTCustomGroupChildVC *)[self.childViewControllers objectAtIndex:index];
    return vc;
}


- (void)segmentView:(XKSegmentView *)segmentView selectIndex:(NSUInteger)index{
    [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (XKSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[XKSegmentView alloc] init];
        _segmentView.style = XKSegmentViewStyleDivide;
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, scalef(375.0f), scalef(180.0f))];
    }
    return _bannerView;
}


- (UIView *)segmentBaseView{
    if (!_segmentBaseView) {
        _segmentBaseView = [[UIView alloc]init];
        _segmentBaseView.frame = CGRectMake(0, 0, kScreenWidth, 51);
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15,51 - 0.5/UIScreen.mainScreen.scale, _segmentBaseView.width - 30, 0.5/UIScreen.mainScreen.scale)];
        line.backgroundColor = COLOR_LINE_GRAY;
        
        self.segmentView.frame = CGRectMake(0, 0, kScreenWidth, 51 - 0.5/UIScreen.mainScreen.scale);
        [_segmentBaseView xk_addSubviews:@[self.segmentView,line]];
    }
    return _segmentBaseView;
}

@end
