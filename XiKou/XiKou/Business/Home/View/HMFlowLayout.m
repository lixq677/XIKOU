//
//  HMFlowLayout.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMFlowLayout.h"
#import "XKUIUnitls.h"

@interface HMFlowLayout ()

@property (nonatomic,strong) NSArray *attrs;

@end

@implementation HMFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (CGSize)collectionViewContentSize{
    UICollectionViewLayoutAttributes *attr = [self.attrs lastObject];
    CGFloat H = CGRectGetMaxY(attr.frame);
    CGFloat W = CGRectGetWidth(self.collectionView.frame);
    return CGSizeMake(W, H+10);
}

- (void)prepareLayout{
    [super prepareLayout];
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray array];
    CGFloat y = self.yInset;
    CGFloat w= CGRectGetWidth(self.collectionView.frame);
    CGFloat cellW =  w-20.0f;
    CGFloat cellX = 10.0f;
    CGFloat lineSpace = 10.0f;
    CGFloat headerH = 51.0f;
    
    CGFloat orY = y;
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section< sectionsCount; section++) {
        XKActivityType activityType = [self.delegate activityTypeWithSection:section];
        NSInteger rowsCount = [self.collectionView numberOfItemsInSection:section];
        if (rowsCount == 0) continue;
        CGSize size = [self.delegate sizeForItemAtSection:section];
        if (activityType == Activity_Discount || activityType == Activity_Global) {
            UICollectionViewLayoutAttributes *headerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            headerAttr.frame = CGRectMake(cellX, orY, w-2*cellX, headerH);
            [attributes addObject:headerAttr];
            
            orY = orY + headerH;
            
            CGFloat spaceW = cellW - 2*size.width;
            for (int row = 0; row < rowsCount; row++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                NSUInteger line = indexPath.row/2;
                NSUInteger col = indexPath.row % 2;
                attr.frame = CGRectMake(cellX+(size.width + spaceW)*col, orY+(size.height+lineSpace)*line, size.width, size.height);
                [attributes addObject:attr];
            }
            UICollectionViewLayoutAttributes *attr = [attributes lastObject];
            orY = CGRectGetMaxY(attr.frame);
            
        }else{
            for (int row = 0; row < rowsCount; row++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                CGSize size = [self.delegate sizeForItemAtSection:section];
                attr.frame = CGRectMake(cellX, orY+lineSpace, size.width, size.height);
                orY = orY + size.height + lineSpace;
                [attributes addObject:attr];
            }
        }
    }
    self.attrs = attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrs;
}



@end


