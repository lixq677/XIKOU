//
//  XKHorizonPageLayout.m
//  XiKou
//
//  Created by L.O.U on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKHorizonPageLayout.h"

UIKIT_EXTERN NSUInteger numberOfPages(NSUInteger itemsInPage, NSUInteger totalCount) {
    if (totalCount == 0) return 0;
    return (totalCount > itemsInPage) ? ((totalCount - 1) / itemsInPage + 1) : 1;
}

@interface XKHorizonPageLayout (){
    NSUInteger _numberOfPages;
}

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes*> *itemsAttributes;

@end

@implementation XKHorizonPageLayout

- (instancetype)init {
    if ( self = [super init] ) {
        [self _setUp];
    }
    return self;
}

- (void)_setUp {
    // 水平滑动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 初始化数据
    _numberOfItemsInPage = 0;
    _columnsInPage = 0;
    _numberOfPages = 0;
    _pageInset = UIEdgeInsetsZero;
    _itemsAttributes = [NSMutableArray array];
}

- (void)prepareLayout {
    [super prepareLayout];
    // 清除缓存
    [self.itemsAttributes removeAllObjects];
    // 每页配置参数为0，则直接使用系统默认
    if ( self.numberOfItemsInPage == 0 || self.columnsInPage == 0 ) {
        return;
    }
    // 布局
    NSUInteger numbers = [self.collectionView numberOfItemsInSection:0];
    _numberOfPages = numberOfPages(self.numberOfItemsInPage, numbers);
    for (NSInteger i=0; i < numbers; i++) {
        [self.itemsAttributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return (self.itemsAttributes.count > 0) ? self.itemsAttributes : [super layoutAttributesForElementsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes*attributes =  [super layoutAttributesForItemAtIndexPath:indexPath];
    // 第几页
    NSUInteger curPage = indexPath.row / self.numberOfItemsInPage;
    // 当前cell所在当页的index
    NSUInteger curIndex = indexPath.row - curPage * self.numberOfItemsInPage;
    // 当前cell所在当页的行
    NSUInteger curColumn = curIndex % self.columnsInPage;
    // 当前cell所在当页的列
    NSUInteger curRow = curIndex / self.columnsInPage;
    // 调整attributes（大小不变，位置改变）
    CGRect rect = attributes.frame;
    attributes.frame = CGRectMake(self.collectionView.bounds.size.width * curPage + self.pageInset.left + curColumn * self.itemSize.width + curColumn * self.minimumLineSpacing,  self.pageInset.top + curRow * self.itemSize.height + curRow * self.minimumInteritemSpacing, rect.size.width, rect.size.height);
    return attributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width * _numberOfPages, [super collectionViewContentSize].height);
}

@end
