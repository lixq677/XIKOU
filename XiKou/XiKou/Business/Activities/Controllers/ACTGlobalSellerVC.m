//
//  ACTGlobalSellerVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTGlobalSellerVC.h"
#import "ACTGlobalGoodListVC.h"

#import "ACTGlobalCouponGoodCell.h"
#import "ACTGlobalScrollGoodCell.h"
#import "ACTBannerCollectionCell.h"
#import "ACTGloalCardCell.h"
#import "ACTTitleView.h"
#import "XKBannerView.h"
#import "XKShareTool.h"

#import "XKActivityService.h"
#import "XKAccountManager.h"
#import "MJDIYHeader.h"
#import <SDImageCache.h>

@interface ACTGlobalSellerVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *bannerArray;

@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) XKBannerData *middleImgData;
@end

static CGFloat const space = 15;
@implementation ACTGlobalSellerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self instanceUI];
    [self initData];
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self
                                                           refreshingAction:@selector(dataRequest)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

#pragma mark Datarequest

- (void)initData{
    ACTGlobalHomeModel *model = [[XKFDataService() actService] queryGlobalHomeModelFromCache];
    if (model) {
        [self handleData:model];
    }
    [self dataRequest];
}

- (void)dataRequest{
    [self.collectionView ly_startLoading];
    [[XKFDataService() actService] getGlobalHomePageDataComplete:^(ACTGlobalHomeRespnse * _Nonnull response) {
        if ([response isSuccess]) {
            [self handleData:response.data];
        }else{
            [response showError];
        }
        [self.collectionView ly_endLoading];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)handleData:(ACTGlobalHomeModel *)model{
    _bannerArray  = [NSMutableArray array];
    _sectionArray = [NSMutableArray array];
    for (XKBannerData *data in model.bannerList) {
        if (data.position == XKBannerPositionTop) {
            [_bannerArray addObject:data];
        }
        if (data.position == XKBannerPositionMiddle) {
            self.middleImgData = data;
        }
    }
    
    for (ACTGlobalPlateModel *subModel  in model.sectionCommodityList) {
        if (subModel.commodityList.result.count > 0) {
            [self.sectionArray addObject:subModel];
        }
    }
    [self.collectionView reloadData];
}
#pragma mark action
#pragma mark ---------------------获取分享的数据
- (void)shareClick{
    NSString *activityId = @"";
    for (ACTGlobalPlateModel *model in self.sectionArray) {
        if (model.commodityList.result.count > 0) {
            XKGoodListModel *gModel = model.commodityList.result[0];
            activityId = gModel.activityId;
            break;
        }
    }
    if (activityId.length == 0) {//自己动手，丰衣足食，到处取需要的数据
        XKShowToast(@"获取分享数据失败");
        return;
    };
    
    XKShareRequestModel *model = [XKShareRequestModel new];
    model.shopId = @"";//不要问我为什么，不传系统就要溜号了
    model.activityId = activityId;
    model.shareUserId = [XKAccountManager defaultManager].account.userId ? [XKAccountManager defaultManager].account.userId : @"";
    model.popularizePosition = SPActivityGloabl;
  
    [[XKShareTool defaultTool]shareWithModel:model andTitle:@"分享到好友" andContent:nil andNeedPhoto:NO andUIType:ShareUIBottom];
}

- (void)headClick:(UITapGestureRecognizer *)tap{
    
    ACTGlobalPlateModel *model = self.sectionArray[tap.view.tag - 1];
    
    NSString *activityId = @"";
    for (XKGoodListModel *gModel in model.commodityList.result) {
        activityId = gModel.activityId;
        break;
    } 
    ACTGlobalGoodListVC *vc = [[ACTGlobalGoodListVC alloc]initWithClassID:model.categoryId andActivityId:activityId];
    vc.className = model.categoryName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UI
- (void)instanceUI{
    
    self.title = @"全球买手";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.collectionView reloadData];
    [self addNavigationItemWithImageName:@"hm_share" isLeft:NO target:self action:@selector(shareClick)];
    
}

#pragma mark collcetionView delegate && dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionArray.count + 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return 1;
    }
    ACTGlobalPlateModel *plateModel = self.sectionArray[section - 1];
    return plateModel.commodityList.result.count > 10 ? 10 : plateModel.commodityList.result.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        ACTBannerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTBannerCollectionCell identify] forIndexPath:indexPath];
        [cell.bannerView setDataSource:self.bannerArray];
        return cell;
    }
    ACTGlobalPlateModel *plateModel = self.sectionArray[indexPath.section - 1];
    if (indexPath.section == 2) {
        ACTGloalCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTGloalCardCell identify] forIndexPath:indexPath];
        cell.goodlist = plateModel.commodityList.result;
        return cell;
    }
//    if (indexPath.section == 3) {
//        ACTGlobalScrollGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTGlobalScrollGoodCell identify] forIndexPath:indexPath];
//        cell.goodlist = plateModel.commodityList.result;
//        return cell;
//    }
    ACTGlobalCouponGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTGlobalCouponGoodCell identify] forIndexPath:indexPath];
    cell.coverView.contentMode = UIViewContentModeScaleAspectFit;
    cell.model = plateModel.commodityList.result[indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if (kind == UICollectionElementKindSectionHeader && indexPath.section > 0) {
        ACTTitleView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[ACTTitleView identify] forIndexPath:indexPath];
        headView.tag          = indexPath.section;
        headView.needIndicate = YES;
        headView.userInteractionEnabled = YES;
        [headView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick:)]];
        
        ACTGlobalPlateModel *plateModel = self.sectionArray[indexPath.section - 1];
        headView.title                  = plateModel.categoryName;
        return headView;
    }
    
    ACTImageFootView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[ACTImageFootView identify] forIndexPath:indexPath];
    if (self.middleImgData && indexPath.section == 1) {
        [foot loadFootImageView:self.middleImgData.imageUrl];
    }
    return foot;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return CGSizeMake(kScreenWidth, scalef(200));
    if (indexPath.section == 2) return CGSizeMake(kScreenWidth - space*2, scalef(225));
    //if (indexPath.section == 3) return CGSizeMake(kScreenWidth - space, scalef(300)*0.6 + [ACTGlobalCouponGoodCell desheight]);
    return CGSizeMake((kScreenWidth - space*3)/2,(kScreenWidth - space*3)/2 + [ACTGlobalCouponGoodCell desheight]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) return CGSizeMake(kScreenWidth, CGFLOAT_MIN);
    return CGSizeMake(kScreenWidth, 50);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 1) return CGSizeMake(kScreenWidth, scalef(110));
    return CGSizeMake(kScreenWidth, 5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) return UIEdgeInsetsMake(0, 0, 0, 0);
    if (section == 2) return UIEdgeInsetsMake(0, space, 0, space);
    if (section == 3) return UIEdgeInsetsMake(0, space, 0, space);
    return UIEdgeInsetsMake(0, space, space, space);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return;
    }
    ACTGlobalPlateModel *plateModel = self.sectionArray[indexPath.section - 1];
    XKGoodListModel *gModel = plateModel.commodityList.result[indexPath.row];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Global),@"id":gModel.id} completion:nil];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = space;
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = COLOR_VIEW_GRAY;
        [_collectionView registerClass:[ACTGlobalCouponGoodCell class]
            forCellWithReuseIdentifier:[ACTGlobalCouponGoodCell identify]];
        [_collectionView registerClass:[ACTGlobalScrollGoodCell class]
            forCellWithReuseIdentifier:[ACTGlobalScrollGoodCell identify]];
        [_collectionView registerClass:[ACTGloalCardCell class]
            forCellWithReuseIdentifier:[ACTGloalCardCell identify]];
        [_collectionView registerClass:[ACTBannerCollectionCell class]
            forCellWithReuseIdentifier:[ACTBannerCollectionCell identify]];
        [_collectionView registerClass:[ACTTitleView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:[ACTTitleView identify]];
        [_collectionView registerClass:[ACTImageFootView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:[ACTImageFootView identify]];
        _collectionView.ly_emptyView = [XKEmptyView goodListNoDataView];
    }
    return _collectionView;
}


@end
