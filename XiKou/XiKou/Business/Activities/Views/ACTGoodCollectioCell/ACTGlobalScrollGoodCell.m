//
//  ACTGlobalScrollGoodCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTGlobalScrollGoodCell.h"
#import "ACTGlobalCouponGoodCell.h"
#import "XKActivityData.h"

@interface ACTGlobalScrollGoodCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

CGFloat const space = 10;
@implementation ACTGlobalScrollGoodCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView xk_addSubviews:@[self.collectionView]];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark collcetionView delegate && dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _goodlist.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ACTGlobalHorizontalGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTGlobalHorizontalGoodCell identify] forIndexPath:indexPath];
    cell.model = _goodlist[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(scalef(300),self.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XKGoodListModel *gModel = _goodlist[indexPath.item];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Global),@"id":gModel.id} completion:nil];
}

- (void)setGoodlist:(NSArray *)goodlist{
    _goodlist = goodlist;
    [self.collectionView reloadData];
}
    
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = space;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, space);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[ACTGlobalHorizontalGoodCell class]
            forCellWithReuseIdentifier:[ACTGlobalHorizontalGoodCell identify]];
    }
    return _collectionView;
}
@end
