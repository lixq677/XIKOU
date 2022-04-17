//
//  XKHorizonPageView.m
//  XiKou
//
//  Created by L.O.U on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKHorizonPageView.h"
#import "XKHorizonPageLayout.h"
#import "XKPageControl.h"

@interface XKHorizonPageView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) XKPageControl *pageControl;

@property (nonatomic, strong) XKHorizonPageLayout * flowLayout;
@end

static NSString * const identify = @"cellIdentify";
@implementation XKHorizonPageView
@synthesize collectionView = _collectionView;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _maxColumn = 3;
        _maxRow = 1;
 
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat cellheight = [_pageDelegate heightOfitemsInPageView:self];
    CGRect rect = self.frame;
    rect.size.height = cellheight * _maxRow + pageSpace * (_maxRow - 1) + controlHeight;
    self.frame = rect;
    
    CGFloat height = rect.size.height;
    CGFloat width  = rect.size.width;
    
    CGFloat itemW = (width - pageInsert*2 - pageSpace * (_maxColumn - 1)) / _maxColumn - 1;
    CGFloat itemH = (height - controlHeight - pageSpace * (_maxRow - 1)) / _maxRow -1;
    
    self.flowLayout.pageInset = UIEdgeInsetsMake(0, pageInsert, 0, pageInsert);
    self.flowLayout.numberOfItemsInPage = _maxRow *_maxColumn;
    self.flowLayout.columnsInPage = _maxColumn;
    self.flowLayout.itemSize = CGSizeMake(itemW, itemH);
    self.flowLayout.minimumLineSpacing = pageSpace;
    self.flowLayout.minimumInteritemSpacing = pageSpace;
    
    self.pageControl.frame = CGRectMake(0, height - controlHeight, width, controlHeight);
    self.collectionView.frame = CGRectMake(0, 0, width, height - controlHeight);
    
    [self.collectionView reloadData];
}

- (void)setPageDelegate:(id<HorizonPageDelegate>)pageDelegate{
    _pageDelegate = pageDelegate;
    
    if (_pageDelegate && [_pageDelegate customCollectionViewCellClassForPageView:self]) {
        Class className = [_pageDelegate customCollectionViewCellClassForPageView:self];
        [self.collectionView registerClass:className forCellWithReuseIdentifier:identify];
    }
    
}
#pragma mark collcetionView delegate && dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_pageDelegate && [_pageDelegate respondsToSelector:@selector(numberOfItemsInPageView:)]) {
        NSInteger items = [_pageDelegate numberOfItemsInPageView:self];
        self.pageControl.numberOfPages = items % _maxColumn == 0 ? items/_maxColumn : items/_maxColumn + 1;
        return [_pageDelegate numberOfItemsInPageView:self];
    };
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [self.pageDelegate setupCustomCell:cell forIndex:indexPath.item pageView:self];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger items = [_pageDelegate numberOfItemsInPageView:self];
    if (items == 0) {
        return;
    }
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = self.bounds.size.width;
    int currentPage = (int)(x/width);
    _pageControl.currentPage = currentPage;
    
}

#pragma mark lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (XKHorizonPageLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[XKHorizonPageLayout alloc]init];
    }
    return _flowLayout;
}

- (XKPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[XKPageControl alloc]initWithFrame:CGRectZero];
        _pageControl.pageIndicatorTintColor = COLOR_HEX(0xEDEDED);
        _pageControl.currentPageIndicatorTintColor = COLOR_TEXT_RED;
    }
    return _pageControl;
}
@end
