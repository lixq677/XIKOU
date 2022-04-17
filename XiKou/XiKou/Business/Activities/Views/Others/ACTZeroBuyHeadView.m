//
//  ACTZeroBuyHeadView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTZeroBuyHeadView.h"
#import "XKBannerView.h"
#import "ACTDiscountGoodCell.h"
#import "XKActivityData.h"
#import "NSDate+Extension.h"
#import "TABAnimated.h"

@interface ACTZeroBuyHeadView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) XKBannerView *bannerView;

@property (nonatomic, strong) UIImageView *adView;

@end

@implementation ACTZeroBuyHeadView
{
    HeadType _type;
    CGFloat cellH;
    ACTMoudleModel *_model;
    ACTRoundModel *_roundModel;
}
- (instancetype)initWithType:(HeadType)type{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    if (self) {
        self.backgroundColor = COLOR_VIEW_GRAY;
        _type = type;
        if (_type == Head_ZeroBuy) {
            cellH = scalef(230)+78;
        }else{
            cellH = scalef(144.0f);
        }
        [self initSubViews];
        [self setData];
    }
    return self;
}

#pragma mark init views
- (void)initSubViews{
    
    CGFloat space = scalef(12.5);
    _bannerView = [[XKBannerView alloc]init];
    _bannerView.frame = CGRectMake(0, 0, kScreenWidth, scalef(180));
    
    _timeView = [[ACTTitleView alloc]initWithFrame:CGRectMake(0, _bannerView.bottom + 5, kScreenWidth, 47)];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = space;
    flowLayout.minimumInteritemSpacing = space;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, scalef(10), 0, scalef(10));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _timeView.bottom, kScreenWidth, cellH) collectionViewLayout:flowLayout];
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    if (_type == Head_ZeroBuy) {
        [_collectionView registerClass:[ACTGoodBaseCell class]
            forCellWithReuseIdentifier:[ACTGoodBaseCell identify]];
    }else{
        [_collectionView registerClass:[ACTDiscountGoodCell class]
            forCellWithReuseIdentifier:[ACTDiscountGoodCell identify]];
    }
    _adView = [[UIImageView alloc]initWithFrame:CGRectMake(space, space+self.collectionView.bottom, kScreenWidth - space*2, scalef(100))];
    _adView.layer.masksToBounds = YES;
    _adView.layer.cornerRadius  = 7.f;
    [self xk_addSubviews:@[self.collectionView,self.bannerView,self.timeView,self.adView]];
    
    self.height = _adView.bottom;
//    [self initAnimation];
}

//- (void)initAnimation{
//
//    self.collectionView.tabAnimated = [TABCollectionAnimated animatedWithCellClass:[ACTDiscountGoodCell class] cellSize:CGSizeMake(scalef(155), scalef(155) + [ACTDiscountGoodCell desheight])];
//    self.collectionView.tabAnimated.animatedCount = 2;
////    self.collectionView.tabAnimated.animatedSectionCount = 1;
//    self.collectionView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeOnlySkeleton;
//    self.collectionView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
//        manager.animation(3).left(40);
//        manager.animation(4).width(CGFLOAT_MIN);
//    };
//    [self.collectionView tab_startAnimation];
//
//    self.bannerView.tabAnimated = [TABViewAnimated new];
//    self.bannerView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeOnlySkeleton;
//    [self.bannerView tab_startAnimation];
//
//    self.timeView.tabAnimated = [TABViewAnimated new];
//    self.timeView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeOnlySkeleton;
//    [self.timeView tab_startAnimation];
//}

#pragma mark data
- (void)setData{
    if (_type == Head_ZeroBuy) {
        _timeView.needTimer = YES;
        _timeView.title = @"倒计时专区";
    }
}

- (void)reloadBanner:(NSArray *)banners{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (XKBannerData *data in banners) {
        if (data.position == XKBannerPositionTop) {
            [dataArray addObject:data];
        }else{
            [self.adView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        }
    }
    _bannerView.dataSource = dataArray;
}

- (void)reloadMoudleData:(ACTMoudleModel *)model{
    [self reloadMoudleData:model roundModel:nil];
}

- (void)reloadMoudleData:(ACTMoudleModel *)model roundModel:(ACTRoundModel *)roundModel{
    _model = model;
    _roundModel = roundModel;
    _timeView.title = model.categoryName;
    [self.collectionView reloadData];
}

- (void)reloadTimer:(NSString *)endDate{
    
    NSDate *date = [NSDate date:endDate WithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval dateTime =[date timeIntervalSince1970];
    
    NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowTime =[nowDate timeIntervalSince1970];
    
    if (nowTime < dateTime) {
        NSInteger time = dateTime - nowTime;
        self.timeView.time = time;
    }else{
        self.timeView.time = 0;
    }
    
}

#pragma mark collcetionView delegate && dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _model.commodityList.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_type == Head_ZeroBuy) {
        ACTGoodBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTGoodBaseCell identify] forIndexPath:indexPath];
        XKGoodModel *gModel =  (XKGoodModel *)_model.commodityList[indexPath.item];
        [cell.coverView sd_setImageWithURL:[NSURL URLWithString:gModel.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        cell.nameLabel.text  = gModel.commodityName;
        if (gModel.adctionModel.status == Round_UnBegin) {
            cell.priceLabel.text = [NSString stringWithFormat: @"¥%.2f",[gModel.startPrice
            floatValue]/100.00];
        }else{
            cell.priceLabel.text = [NSString stringWithFormat: @"¥%.2f",[gModel.adctionModel.currentPrice
            floatValue]/100.00];
        }
        
        [cell.priceLabel handleRedPrice:FontSemibold(17.f)];
        cell.sellOutLabel.hidden = YES;
        return cell;
    }
    
    ACTDiscountGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTDiscountGoodCell identify] forIndexPath:indexPath];
    cell.model = _model.commodityList[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == Head_ZeroBuy) {
        return CGSizeMake(cellH - 78,cellH);
    }else{
        return CGSizeMake(scalef(110), scalef(154.0f));
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XKGoodListModel *gModel =  _model.commodityList[indexPath.item];
    if (_type == Head_ZeroBuy) {
        [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_ZeroBuy),@"id":gModel.id} completion:nil];
    }else{
        [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Discount),@"id":gModel.id} completion:nil];
    }
    
}

@end
