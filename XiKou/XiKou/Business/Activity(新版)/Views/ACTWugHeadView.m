//
//  ACTWugHeadView.m
//  XiKou
//
//  Created by L.O.U on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTWugHeadView.h"
#import "XKBannerView.h"
#import "XKHorizonPageView.h"
#import "ACTWugGoodCell.h"

#import "XKActivityData.h"

@interface ACTWugHeadView ()<HorizonPageDelegate>

@property (nonatomic, strong) XKBannerView *bannerView;

@property (nonatomic, strong) XKHorizonPageView *pageCollectionView;

@property (nonatomic, strong) UIImageView *adView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *contenView;

@property (nonatomic,strong) ACTMoudleModel *moudleModel;

@end

static NSInteger const pageColumn = 3; //collection 列数

@implementation ACTWugHeadView
{
    CGFloat itemWidth;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_VIEW_GRAY;
        [self.contenView xk_addSubviews:@[self.pageCollectionView,self.titleLabel]];
        [self xk_addSubviews:@[self.bannerView,self.contenView,self.adView]];
        [self reloadFrame];
    }
    return self;
}

- (void)reloadFrame{
    self.bannerView.frame = CGRectMake(0, 0, self.width, scalef(181.f));
    
    CGFloat insert = 15;
    CGFloat space  = 10;
    
    self.titleLabel.frame = CGRectMake(insert, 0, self.width - insert*2, 44);
    
    self.pageCollectionView.frame = CGRectMake(0, self.titleLabel.bottom + 15, self.width, 0);
    
    itemWidth = (self.pageCollectionView.width - pageInsert*2 - pageSpace*2)/pageColumn;
    
    self.pageCollectionView.height = itemWidth + [ACTWugGoodCell desHeight] + controlHeight;

    self.contenView.frame = CGRectMake(space, scalef(124.f), self.width - space*2, self.pageCollectionView.bottom);
    
    self.adView.frame = CGRectMake(space, self.contenView.bottom + 12, self.width - space*2, scalef(90));
    
    self.height = self.adView.bottom + space;
    
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
    _moudleModel = model;
    _titleLabel.text = model.categoryName;
    [self.pageCollectionView.collectionView reloadData];
}

#pragma mark  HorizonPageDelegate
- (Class)customCollectionViewCellClassForPageView:(XKHorizonPageView *)view{
    return [ACTWugGoodCell class];
}

- (NSInteger)numberOfItemsInPageView:(XKHorizonPageView *)pageView{
    return _moudleModel.commodityList.count;
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index pageView:(XKHorizonPageView *)view{
    ACTWugGoodCell *goodCell = (ACTWugGoodCell *)cell;
    goodCell.fontStyle = FontSmall;
    goodCell.model = _moudleModel.commodityList[index];
}

- (CGFloat)heightOfitemsInPageView:(XKHorizonPageView *)view{
    return itemWidth + [ACTWugGoodCell desHeight];
}

- (void)pageView:(XKHorizonPageView *)pageView didSelectItemAtIndex:(NSInteger)index{
    
}

- (UIScrollView *)scrollView{
    return self.pageCollectionView.collectionView;
}

#pragma mark  lazy
- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc]init];
    }
    return _bannerView;
}

- (UIImageView *)adView{
    if (!_adView) {
        _adView = [[UIImageView alloc]init];
        _adView.layer.masksToBounds = YES;
        _adView.layer.cornerRadius  = 5.f;
        _adView.image = [UIImage imageNamed:kPlaceholderImg];
    }
    return _adView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel               = [UILabel new];
        _titleLabel.font          = FontMedium(17.f);
        _titleLabel.textColor     = COLOR_TEXT_BLACK;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor     = [UIColor whiteColor];
        _titleLabel.layer.shadowColor   = COLOR_RGB(228, 228, 228, 1).CGColor;
        _titleLabel.layer.shadowOffset  = CGSizeMake(0,0.5);
        _titleLabel.layer.shadowOpacity = 1;
        _titleLabel.layer.shadowRadius  = 0;
    }
    return _titleLabel;
}

- (XKHorizonPageView *)pageCollectionView{
    if (!_pageCollectionView) {
        _pageCollectionView = [[XKHorizonPageView alloc]initWithFrame:CGRectZero];
        _pageCollectionView.pageDelegate = self;
    }
    return _pageCollectionView;
}

- (UIView *)contenView{
    if (!_contenView) {
        _contenView = [UIView new];
        _contenView.backgroundColor = [UIColor whiteColor];
        _contenView.layer.masksToBounds = YES;
        _contenView.layer.cornerRadius  = 7;
        _contenView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        _contenView.layer.shadowOffset = CGSizeMake(0,0);
        _contenView.layer.shadowOpacity = 1;
        _contenView.layer.shadowRadius = 15;
    }
    return _contenView;
}
@end
