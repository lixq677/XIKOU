//
//  HMWgLimitBuyHeaderView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/18.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMWgLimitBuyHeaderView.h"
#import "XKBannerView.h"
#import "HMViews.h"
#import "XKActivityData.h"
#import "UILabel+NSMutableAttributedString.h"
#import "BCTools.h"

@interface HMWgLimitBuyHeaderView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) XKBannerView *bannerView;

@property (nonatomic,strong) UIView *sellView;

@property (nonatomic,strong) UILabel *sellLabel;

@property (nonatomic,strong) UIImageView *adView;

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) ACTMoudleModel *moudleModel;
@end

@implementation HMWgLimitBuyHeaderView
@synthesize collectionView = _collectionView;
- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    if (self) {
        [self layout];
        self.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
    }
    return self;
}

- (void)layout{
    [self addSubview:self.bannerView];
    [self addSubview:self.sellView];
    [self addSubview:self.adView];
    [self.sellView addSubview:self.sellLabel];
    [self.sellView addSubview:self.collectionView];
    [self.collectionView registerClass:[CGWgCell class] forCellWithReuseIdentifier:@"CGWgCell"];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(scalef(180));
    }];
    [self.sellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(-30);
    }];
    
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(10);
        make.right.equalTo(self).mas_offset(-10);
        make.top.mas_equalTo(self.sellView.mas_bottom).offset(10);
        make.height.mas_equalTo(scalef(100));
        make.bottom.equalTo(self);
    }];
    
    [self.sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21.0f);
        make.left.mas_equalTo(15.0f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sellLabel.mas_bottom).offset(15.0f);
        make.left.mas_equalTo(5.0f);
        make.right.equalTo(self.sellView).offset(-5.0f);
        make.height.mas_equalTo(scalef(170.0f));
        make.bottom.equalTo(self.sellView).offset(-10);
    }];
    self.adView.layer.masksToBounds = YES;
    self.adView.layer.cornerRadius  = 7.f;
    self.sellView.layer.masksToBounds = YES;
    self.sellView.layer.cornerRadius  = 7.f;
    
    self.height  = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
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
    if (self.adView.image) {
        [self.adView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.height.mas_equalTo(scalef(100.0f));
        }];
        self.height  = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }else{
        [self.adView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGFLOAT_MIN);
        }];
        self.height  = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height - 10;
    }
    _bannerView.dataSource = dataArray;
}

- (void)reloadMoudleData:(ACTMoudleModel *)model{
    _moudleModel  = model;
    _sellLabel.text = model.categoryName;
    [self.collectionView reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _moudleModel.commodityList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGWgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGWgCell" forIndexPath:indexPath];
    CGFloat hspace = 0.5*(CGRectGetWidth(collectionView.frame)-CGRectGetWidth(cell.frame)*3);
    if (hspace < 0) {
        hspace = 0;
    }
    CGFloat x = -0.5*hspace + (hspace+ CGRectGetWidth(cell.frame)) * indexPath.row;
    do{
        if (x <= 0)break;
        UIView *horizontalLine = [collectionView viewWithTag:100+indexPath.row];
        if (horizontalLine)break;
        horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(x,0, 0.5, scalef(100.0f))];
        horizontalLine.tag  = 100+indexPath.row;
        horizontalLine.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
        [collectionView addSubview:horizontalLine];
    }while (0);
    
    XKGoodListModel *model = _moudleModel.commodityList[indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    cell.textLabel.text = model.commodityName;
    cell.detailLabel.text  = [NSString stringWithFormat:@" 赠券%.2f ",[model.couponValue floatValue]/100];
  
    cell.priceLabel.attributedText = PriceDef([model.salePrice doubleValue]/100.00f);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XKGoodListModel *gModel = _moudleModel.commodityList[indexPath.item];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_WG),@"id":gModel.id} completion:nil];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = scale_size(100.0f, 170.0f);
        flowLayout.minimumLineSpacing = 0.5*(kScreenWidth-30.0f-3*scalef(100.0f));
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc] init];
    }
    return _bannerView;
}

- (UIImageView *)adView{
    if (!_adView) {
        _adView = [[UIImageView alloc]init];
        _adView.clipsToBounds = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _adView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _headerView;
}

- (UIView *)sellView{
    if (!_sellView) {
        _sellView = [[UIView alloc] init];
        _sellView.layer.cornerRadius = 5.0f;
        _sellView.backgroundColor = HexRGB(0xffffff, 1.0f);
    }
    return _sellView;
}

- (UILabel *)sellLabel{
    if (!_sellLabel) {
        _sellLabel = [[UILabel alloc] init];
        _sellLabel.text = @"最新寄卖";
        _sellLabel.textColor = COLOR_TEXT_BLACK;
        _sellLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    }
    return _sellLabel;
}

@end
