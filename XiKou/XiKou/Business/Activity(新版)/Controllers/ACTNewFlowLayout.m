//
//  ACTNewFlowLayout.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTNewFlowLayout.h"
#import "XKUIUnitls.h"

static NSString *const ACTNewSectionBackground = @"ACTNewSectionBackground";

@interface ACTNewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, strong) UIColor *backgroundColor;

@end

@implementation ACTNewLayoutAttributes

@end

@interface ACTNewReusableView : UICollectionReusableView

@end

@implementation ACTNewReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[ACTNewLayoutAttributes class]]) {
        ACTNewLayoutAttributes *attr = (ACTNewLayoutAttributes *)layoutAttributes;
        self.backgroundColor = attr.backgroundColor;
    }
}
@end


@interface ACTNewFlowLayout ()

@property (nonatomic,strong) NSArray *attrs;

@end

@implementation ACTNewFlowLayout

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    [self registerClass:[ACTNewReusableView class] forDecorationViewOfKind:ACTNewSectionBackground];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (CGSize)collectionViewContentSize{
    UICollectionViewLayoutAttributes *attr = [self.attrs lastObject];
    CGFloat H = CGRectGetMaxY(attr.frame);
    CGFloat W = CGRectGetWidth(self.collectionView.frame);
    return CGSizeMake(W, H+10+self.bottom);
}

- (void)prepareLayout{
    [super prepareLayout];
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray array];
    CGFloat w= CGRectGetWidth(self.collectionView.frame);
    CGFloat orY = self.offsetY;
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section< sectionsCount; section++) {
        NSInteger rowsCount = [self.collectionView numberOfItemsInSection:section];
        if (rowsCount == 0) continue;
        
        UIEdgeInsets sectionInset = [self sectionInset];
        id delegate = self.collectionView.delegate;
        if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            UIEdgeInsets inset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
            sectionInset = inset;
        }
        
        CGRect sectionFrame = CGRectZero;
        sectionFrame.origin = CGPointMake(sectionInset.left, orY+sectionInset.top);
        
        CGSize headerSize = [self.delegate flowLayout:self sizeForHeaderAtSection:section];
        UICollectionViewLayoutAttributes *headerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        headerAttr.frame = CGRectMake(sectionInset.left, orY, headerSize.width, headerSize.height);
        [attributes addObject:headerAttr];
        
        
        orY = orY + headerSize.height + sectionInset.top;
        CGFloat cellW = w - sectionInset.left - sectionInset.right;
        CGSize size = [self.delegate flowLayout:self sizeForItemAtSection:section];
        NSInteger lineCount = (cellW+self.minimumInteritemSpacing)/(size.width+self.minimumInteritemSpacing);
        if(lineCount > rowsCount)lineCount = rowsCount;
        if (self.lineCount != 0 && lineCount > self.lineCount) {
            lineCount = self.lineCount;
        }
        CGFloat spaceW = 0;
        if (lineCount > 1) {
             spaceW = (cellW - lineCount*size.width)/(lineCount-1);
        }
        for (int row = 0; row < rowsCount; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            NSUInteger line = indexPath.row/lineCount;
            NSUInteger col = indexPath.row % lineCount;
            attr.frame = CGRectMake(sectionInset.left+(size.width + spaceW)*col, orY+(size.height+self.minimumLineSpacing)*line, size.width, size.height);
            [attributes addObject:attr];
        }
        UICollectionViewLayoutAttributes *attr = [attributes lastObject];
        orY = CGRectGetMaxY(attr.frame);
        sectionFrame.size = CGSizeMake(MAX(cellW, headerSize.width), orY-sectionFrame.origin.y);
        
        orY += sectionInset.bottom;
        
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:backgroundColorForSection:)]) {
            ACTNewLayoutAttributes *nAttr = [ACTNewLayoutAttributes layoutAttributesForDecorationViewOfKind:ACTNewSectionBackground withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            nAttr.frame = sectionFrame;
            nAttr.zIndex = -1;
            
            nAttr.backgroundColor = [self.delegate collectionView:self.collectionView layout:self backgroundColorForSection:section];
            [attributes addObject:nAttr];
        }
    }
    self.attrs = attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrs;
}

@end

