//
//  ACTZeroBuyChildVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTZeroBuyChildVC.h"
#import "ACTZeroBuyGoodCell.h"
#import "ACTDiscountGoodCell.h"
#import "MJDIYFooter.h"
#import "XKWeakDelegate.h"
#import "XKUserService.h"
#import "XKActivityService.h"

@interface ACTZeroBuyChildVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XKUserServiceDelegate>

@property (nonatomic, strong) NSArray *auctionArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation ACTZeroBuyChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self dataRequest];
    [[XKFDataService() userService] addWeakDelegate:self];
    // Do any additional setup after loading the view.
}

#pragma mark UI
- (void)initSubView{
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    self.collectionView.backgroundColor = COLOR_VIEW_GRAY;
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ACTZeroBuyGoodCell class]
            forCellWithReuseIdentifier:[ACTZeroBuyGoodCell identify]];

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark dataRequest
- (void)dataRequest{
    dispatch_queue_t queueT = dispatch_queue_create("group.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t grpupT = dispatch_group_create();
    
    dispatch_group_async(grpupT, queueT, ^{ //商品列表
        dispatch_group_enter(grpupT);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[XKFDataService() actService]getRoundGoodListByRoundId:self.roundId Complete:^(ACTRoundGoodListRespnse * _Nonnull response) {
                if ([response isSuccess]) {
                    self.dataArray = response.data;
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
            [[XKFDataService() actService]getGoodAuctionInfoByRoundId:self.roundId Complete:^(ACTGoodAuctionRespnse * _Nonnull response) {
                if ([response isSuccess]) {
                    self.auctionArray = response.data;
                }else{
                    [response showError];
                }
                dispatch_group_leave(grpupT);
            }];
        });
    });
    dispatch_group_notify(grpupT, queueT, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataArray enumerateObjectsUsingBlock:^(XKGoodModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < self.auctionArray.count) {
                    obj.adctionModel = self.auctionArray[idx];
                }
            }];
            if (!self.collectionView.ly_emptyView) {
                self.collectionView.ly_emptyView = [XKEmptyView goodListNoDataView];
            }
            [self.collectionView reloadData];
        });
    });
}

/**
 下面俩个方法 登录状态改变刷新页面
 
 */
- (void)loginWithService:(XKUserService *)service userInfo:(XKAccountData *)data{
    [self dataRequest];
}

- (void)logoutWithService:(XKUserService *)service userId:(NSString *)userId{//退出登录 代理
    [self dataRequest];
}

#pragma mark collcetionView delegate && dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    ACTZeroBuyGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTZeroBuyGoodCell identify] forIndexPath:indexPath];
    cell.model  = _dataArray[indexPath.row];
    return cell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kScreenWidth - 10*3)/2,(kScreenWidth - 10*3)/2+[ACTZeroBuyGoodCell desheight]);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XKGoodListModel *gModel  = _dataArray[indexPath.row];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_ZeroBuy),@"id":gModel.id} completion:nil];;
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
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

#pragma mark getter
- (void)dealloc{
     [[XKFDataService() userService] removeWeakDelegate:self];
}

@end
