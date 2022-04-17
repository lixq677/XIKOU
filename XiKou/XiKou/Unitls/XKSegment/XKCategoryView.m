//
//  XKCategoryView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKCategoryView.h"
#import "XKUIUnitls.h"
#import "NSString+Common.h"

@interface SegemenCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, assign) BOOL needSubTitle;
@end

static NSString *const cellID = @"cellID";
@implementation SegemenCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.topLabel = [UILabel new];
        self.topLabel.font = FontMedium(16.f);
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        
        self.subLabel = [UILabel new];
        self.subLabel.font = Font(10.f);
        self.subLabel.textAlignment = NSTextAlignmentCenter;
   
        [self.contentView xk_addSubviews:@[self.topLabel,self.subLabel]];
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(CGFLOAT_MIN);
            make.bottom.equalTo(self).offset(-2);
        }];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(4);
            make.bottom.equalTo(self.subLabel.mas_top);
        }];

    }
    return self;
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.topLabel.textColor = COLOR_TEXT_BLACK;
        self.subLabel.textColor = COLOR_TEXT_BLACK;
    }else{
        self.topLabel.textColor = COLOR_TEXT_GRAY;
        self.subLabel.textColor = COLOR_TEXT_GRAY;
    }
}

- (void)setNeedSubTitle:(BOOL)needSubTitle{
    if (_needSubTitle != needSubTitle) {
        _needSubTitle = needSubTitle;
        if (needSubTitle) {
            [self.subLabel mas_updateConstraints:^(MASConstraintMaker *make) {
               make.height.mas_equalTo(14);
            }];
        }else{
            [self.subLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(CGFLOAT_MIN);
            }];
        }
    }
}
@end

@interface XKCategoryView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) CGPoint lastContentViewContentOffset;

@property (nonatomic, strong) UICollectionViewCell *lastCell;

@property (nonatomic, assign) CategoryStyle style;
@end

@implementation XKCategoryView
@synthesize collectionView = _collectionView;

- (instancetype)initWithStyle:(CategoryStyle)style
                  andDelegate:(id<XKCategoryDelegate>)delegate
                     andFrame:(CGRect)rect{
    self = [super initWithFrame:rect];
    if (self) {
        
        _style = style;
        _delegate = delegate;
        
        _lastContentViewContentOffset = CGPointZero;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        [self.collectionView addSubview:self.bottomLine];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //flowLayout.minimumInteritemSpacing = 29;
        flowLayout.minimumLineSpacing = 29.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 2, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)
                                            collectionViewLayout:flowLayout];

        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[SegemenCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(10, self.collectionView.height - 2, 40, 2)];
        _bottomLine.hidden = YES;
        _bottomLine.backgroundColor = COLOR_TEXT_BLACK;
    }
    return _bottomLine;
}

- (void)reloadData{
    _lastCell = nil;
    [self.collectionView reloadData];
}
#pragma mark collcetionView delegate && dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger number = 0;
    if ([self.delegate respondsToSelector:@selector(numberOfItems)]) {
        number = [self.delegate numberOfItems];
    }
    self.bottomLine.hidden = (number == 0);
    return number;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SegemenCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    if ([self.delegate respondsToSelector:@selector(titleOfSegementAtIndex:)]) {
        cell.topLabel.text = [self.delegate titleOfSegementAtIndex:indexPath.item];
    }
    if ([self.delegate respondsToSelector:@selector(subTitleOfSegementAtIndex:)]) {
        cell.subLabel.text = [self.delegate subTitleOfSegementAtIndex:indexPath.item];
        cell.needSubTitle = YES;
    }else{
        cell.needSubTitle = NO;
    }
    if (!_lastCell && indexPath.item == 0) {
        cell.selected =  YES ;
        _lastCell = cell;
        _bottomLine.centerX = cell.centerX;
        CGFloat width  = [cell.topLabel.text sizeWithFont:FontMedium(16.f)].width - 4;
        self.bottomLine.width = width;
        self.bottomLine.centerX = cell.centerX;
        if (self.delegate && [_delegate respondsToSelector:@selector(categorySelectIndex:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate categorySelectIndex:indexPath.item];
            });
        }
    }else{
        cell.selected = _lastCell == cell ? YES : NO;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(titleOfSegementAtIndex:)]) {
        NSString *title = [self.delegate titleOfSegementAtIndex:indexPath.item];
        CGFloat width  = [title sizeWithFont:FontMedium(16.f)].width+2;
        if ([self.delegate respondsToSelector:@selector(subTitleOfSegementAtIndex:)]){
            NSString *subTitle = [self.delegate subTitleOfSegementAtIndex:indexPath.item];
            CGFloat subWidth  = [subTitle sizeWithFont:Font(10.f)].width+2;
            return CGSizeMake(MAX(MAX(width, subWidth), 40),collectionView.height-2);
        }
        return CGSizeMake(MAX(width, 40),collectionView.height-2);
    }
    return CGSizeMake(40,collectionView.height-2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self selectCell:indexPath];
}

- (void)selectCell:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
    if (cell == _lastCell) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(categorySelectIndex:)]) {
        [_delegate categorySelectIndex:indexPath.item];
    }
    _currentIndex = indexPath.item;
    _lastCell.selected = NO;
    [UIView animateWithDuration:0.28 animations:^{
        NSString *title = [self.delegate titleOfSegementAtIndex:indexPath.item];
        CGFloat width  = [title sizeWithFont:FontMedium(16.f)].width - 4;
        self.bottomLine.width = width;
        self.bottomLine.centerX = cell.centerX;
    } completion:^(BOOL finished) {
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }];
    _lastCell = cell;
}

- (void)setContentScrollView:(UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = contentScrollView;
        [_contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if ((self.contentScrollView.isTracking || self.contentScrollView.isDecelerating)) {
            //只处理用户滚动的情况
            [self contentOffsetOfContentScrollViewDidChanged:contentOffset];
        }
        self.lastContentViewContentOffset = contentOffset;
    }
}

- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset {
    float ratio = contentOffset.x/self.contentScrollView.bounds.size.width;
    NSInteger items = [self.delegate numberOfItems];
    if (ratio > items || ratio < 0) {
        //超过了边界，不需要处理
        return;
    }
    if (contentOffset.x == 0 && self.currentIndex == 0 && self.lastContentViewContentOffset.x == 0) {
        //滚动到了最左边，且已经选中了第一个，且之前的contentOffset.x为0
        return;
    }
    CGFloat maxContentOffsetX = self.contentScrollView.contentSize.width - self.contentScrollView.bounds.size.width;
    if (contentOffset.x == maxContentOffsetX && self.currentIndex == items - 1 && self.lastContentViewContentOffset.x == maxContentOffsetX) {
        //滚动到了最右边，且已经选中了最后一个，且之前的contentOffset.x为maxContentOffsetX
        return;
    }
    ratio = MAX(0, MIN(items, ratio));
    NSInteger baseIndex = floorf(ratio);
    CGFloat remainderRatio = ratio - baseIndex;
    
    if (remainderRatio == 0) {
        //快速滑动翻页，用户一直在拖拽contentScrollView，需要更新选中状态
        //滑动一小段距离，然后放开回到原位，contentOffset同样的值会回调多次。例如在index为1的情况，滑动放开回到原位，contentOffset会多次回调CGPoint(width, 0)
        if (!(self.lastContentViewContentOffset.x == contentOffset.x && self.currentIndex == baseIndex)) {
            [self selectCell:[NSIndexPath indexPathForItem:baseIndex inSection:0]];
        }
    }else {
        //快速滑动翻页，当remainderRatio没有变成0，但是已经翻页了，需要通过下面的判断，触发选中
        if (fabs(ratio - self.currentIndex) > 1) {
            NSInteger targetIndex = baseIndex;
            if (ratio < self.currentIndex) {
                targetIndex = baseIndex + 1;
            }
            [self selectCell:[NSIndexPath indexPathForItem:baseIndex inSection:0]];
        }
    }
}

- (void)dealloc{
    [self.contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
