//
//  ACTGoodCardCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTGoodCardCell.h"

@implementation ACTGoodCardCell{
    CAShapeLayer *_layer;
}
@synthesize sellOutLabel = _sellOutLabel;


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius  = 7.f;
    }
    return self;
}

- (void)layout{
    [self.contentView xk_addSubviews:@[self.imageView,self.discountLabel]];
    [self.imageView addSubview:self.sellOutLabel];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(15);
    }];
    [self.sellOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60.0f);
        make.center.equalTo(self.imageView);
    }];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_layer) {
        _layer = [CAShapeLayer layer];
        self.discountLabel.layer.mask = _layer;
    }
    [self.discountLabel layoutIfNeeded];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.discountLabel.bounds
                                                     byRoundingCorners:UIRectCornerBottomLeft
                                                           cornerRadii:CGSizeMake(self.contentView.layer.cornerRadius, self.contentView.layer.cornerRadius)];
    _layer.path = bezierPath.CGPath;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius  = 2.0f;
    }
    return _imageView;
}

- (UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [UILabel new];
        _discountLabel.font = Font(9.f);
        _discountLabel.textColor = [UIColor whiteColor];
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.backgroundColor = COLOR_RGB(187, 148, 69, 0.6);
    }
    return _discountLabel;
}

- (UILabel *)sellOutLabel{
    if (!_sellOutLabel) {
        _sellOutLabel = [UILabel new];
        _sellOutLabel.font = Font(20.f);
        _sellOutLabel.textColor = HexRGB(0xffffff, 1.0f);
        _sellOutLabel.backgroundColor = HexRGB(0x0, 0.3);
        _sellOutLabel.text = @"售罄";
        _sellOutLabel.layer.cornerRadius = 30.0f;
        _sellOutLabel.textAlignment = NSTextAlignmentCenter;
        _sellOutLabel.clipsToBounds = YES;
        _sellOutLabel.hidden = YES;
    }
    return _sellOutLabel;
}


@end

@interface ACTBrainCardCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@end

@implementation ACTBrainCardCell
@synthesize collectionView = _collectionView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.collectionView];
        [self layout];
        [self.collectionView registerClass:[ACTGoodCardCell class] forCellWithReuseIdentifier:@"ACTGoodCardCell"];
        @weakify(self);
        [[RACObserve(self, dataSource) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.collectionView reloadData];
        }];
    }
    return self;
}

- (void)layout{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ACTGoodCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ACTGoodCardCell" forIndexPath:indexPath];
    XKGoodListModel *commodityModel = [self.dataSource objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:commodityModel.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    cell.discountLabel.hidden = !commodityModel.discount;
    cell.discountLabel.text = [NSString stringWithFormat:@"  %@折起   ",commodityModel.discount ? commodityModel.discount :@0];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ACTGoodCardCell *cell = (ACTGoodCardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate clickGoodsCell:cell atIndex:indexPath.row];
}

- (void)reloadData{
    [self.collectionView reloadData];
}



#pragma mark getter
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        CGFloat width = (kScreenWidth - 40.0f)/3.f;
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(width, width);
        //_flowLayout.minimumLineSpacing = 10.0f;
        _flowLayout.minimumInteritemSpacing = 10.0f;
       // _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
        _flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
@end
