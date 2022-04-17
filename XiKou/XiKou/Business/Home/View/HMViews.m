//
//  HMViews.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMViews.h"
#import "XKUIUnitls.h"
#import "BCTools.h"
#import "XKGoodModel.h"
#import "HMCountTimerView.h"

@interface HMReusableView ()

@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;

@end

@implementation HMReusableView
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize imageView = _imageView;
@synthesize tapGesture = _tapGesture;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"class = %@",[self class]);
        [self addSubview:self.textLabel];
        [self addSubview:self.detailTextLabel];
        [self addSubview:self.imageView];
        [self addGestureRecognizer:self.tapGesture];
        self.backgroundColor = [UIColor clearColor];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).offset(18.0f);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textLabel.mas_right).offset(7.0f);
            make.bottom.equalTo(self.textLabel).offset(-3.0f);
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-16.0f);
            make.centerY.equalTo(self.textLabel);
            make.height.mas_equalTo(11.0f);
        }];
    }
    return self;
}


- (void)clickIt:(id)sender{
    if ([self.delegate respondsToSelector:@selector(reusableView:clickIt:)]) {
        [self.delegate reusableView:self clickIt:sender];
    }
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIt:)];
    }
    return _tapGesture;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _detailTextLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_arrow"]];
    }
    return _imageView;
}

@end

/***************新用户好礼cell*******************/

@implementation HMNewUserCell
@synthesize imageView = _imageView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"class = %@",[self class]);
        [self.contentView addSubview:self.imageView];
        [self layout];
    }
    return self;
}


- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(90.0f);
    }];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end


/******************吾G专区**********************/
@interface HMWgCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@end

@implementation HMWgCell
@synthesize imageView = _imageView;
@synthesize collectionView = _collectionView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"class = %@",[self class]);
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
        self.layer.cornerRadius = 7.0f;
        self.clipsToBounds = YES;
        [self.collectionView registerClass:[CGWgCell class] forCellWithReuseIdentifier:@"CGWgCell"];
        [self.collectionView registerClass:[CGMoreGoodsCell class] forCellWithReuseIdentifier:@"CGMoreGoodsCell"];
        [self layout];
        @weakify(self);
        [[RACObserve(self, dataSource) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.collectionView reloadData];
        }];
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(71.0f);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(28.0f);
        make.top.equalTo(self.contentView).offset(18.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.equalTo(self.contentView).offset(40.f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.imageView.mas_bottom).offset(5.0f);
//        make.height.mas_equalTo(156.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20.0f);
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource.count >= 4) {
        return self.dataSource.count+1;
    }else{
        return self.dataSource.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataSource.count) {
        CGGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGWgCell" forIndexPath:indexPath];
        XKGoodListModel *commodityModel = [self.dataSource objectAtIndex:indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:commodityModel.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        cell.textLabel.text = commodityModel.commodityName;
        cell.priceLabel.attributedText = PriceDef([commodityModel.salePrice doubleValue]/100.00f);
        cell.detailLabel.text = [NSString stringWithFormat:@" 赠券%.2f ",commodityModel.couponValue.doubleValue/100.00f];
        return cell;
    }else{
        CGMoreGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGMoreGoodsCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataSource.count) {
        CGGoodsCell *cell = (CGGoodsCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self.delegate clickGoodsCell:cell atIndex:indexPath.row activityType:Activity_WG];
    }else{
        [self.delegate seeMoreGoodsWithActivityType:Activity_WG];
    }
}


#pragma mark getter
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(80.0f, 156.0f);
        _flowLayout.minimumLineSpacing = 15.0f;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
        _flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = COLOR_TEXT_BROWN;
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _detailTextLabel;
}

@end



/******************砍立得首页Cell*********************************/
@interface HMBrainCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@end

@implementation HMBrainCell
@synthesize imageView = _imageView;
@synthesize collectionView = _collectionView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"class = %@",[self class]);
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
        self.layer.cornerRadius = 7.0f;
        self.clipsToBounds = YES;
        [self.collectionView registerClass:[CGBrainCell class] forCellWithReuseIdentifier:@"CGBrainCell"];
        [self.collectionView registerClass:[CGMoreGoodsCell class] forCellWithReuseIdentifier:@"CGMoreGoodsCell"];
        [self layout];
        @weakify(self);
        [[RACObserve(self, dataSource) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.collectionView reloadData];
        }];
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(71.0f);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(28.0f);
        make.top.equalTo(self.contentView).offset(18.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.equalTo(self.contentView).offset(40.0f);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.imageView.mas_bottom).offset(10.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14.0f);
    }];
   
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource.count >= 4) {
        return self.dataSource.count+1;
    }else{
        return self.dataSource.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataSource.count) {
        CGGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGBrainCell" forIndexPath:indexPath];
        XKGoodListModel *commodityModel = [self.dataSource objectAtIndex:indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:commodityModel.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        cell.textLabel.text = commodityModel.commodityName;
        cell.priceLabel.attributedText = PriceDef(commodityModel.commodityPrice.doubleValue/100.00f);
        cell.detailLabel.attributedText = PriceDef_line(commodityModel.salePrice.doubleValue/100.00f);
        return cell;
    }else{
        CGMoreGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGMoreGoodsCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataSource.count) {
        CGGoodsCell *cell = (CGGoodsCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self.delegate clickGoodsCell:cell atIndex:indexPath.row activityType:Activity_Bargain];
    }else{
        [self.delegate seeMoreGoodsWithActivityType:Activity_Bargain];
    }
   
}

- (void)reloadData{
    [self.collectionView reloadData];
}



#pragma mark getter
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(80.0f, 142.0f);
        _flowLayout.minimumLineSpacing = 15.0f;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
        _flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0xffffff, 1.0f);
        _textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0xffffff, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _detailTextLabel;
}

@end

/******************零元拍首页Cell*********************************/
@interface HMZeroBuyCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong)HMCountTimerView *timerView;

@end

@implementation HMZeroBuyCell
@synthesize imageView = _imageView;
@synthesize collectionView = _collectionView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"class = %@",[self class]);
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        
        [self.contentView addSubview:self.timerView];
        
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
        self.layer.cornerRadius = 7.0f;
        self.clipsToBounds = YES;
        [self layout];
        [self.collectionView registerClass:[CGZeroBuyCell class] forCellWithReuseIdentifier:@"CGZeroBuyCell"];
        [self.collectionView registerClass:[CGMoreGoodsCell class] forCellWithReuseIdentifier:@"CGMoreGoodsCell"];
        @weakify(self);
        [[RACObserve(self, dataSource) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.collectionView reloadData];
        }];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.timerView stopCount];
}

- (void)layout{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(23.0f);
        make.height.mas_equalTo(17.0f);
    }];
    [self.textLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.timerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textLabel.mas_right).offset(10.0f);
        make.centerY.mas_equalTo(self.textLabel);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.0f);
        make.size.mas_equalTo(CGSizeMake(6.0f, 11.0f));
        make.centerY.equalTo(self.textLabel);
    }];
   
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.textLabel.mas_bottom).offset(23.0f);
//        make.height.mas_equalTo(156.0f);
        make.bottom.mas_equalTo(-20.0f);
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource.count >= 4) {
        return self.dataSource.count+1;
    }else{
        return self.dataSource.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataSource.count) {
        CGGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGZeroBuyCell" forIndexPath:indexPath];
        XKGoodListModel *commodityModel = [self.dataSource objectAtIndex:indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:commodityModel.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        cell.textLabel.text = commodityModel.commodityName;
        cell.priceLabel.attributedText = PriceDef(commodityModel.startPrice.doubleValue/100.00f);
        cell.detailLabel.attributedText = PriceDef_line(commodityModel.salePrice.doubleValue/100.00f);
        return cell;
    }else{
        CGMoreGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGMoreGoodsCell" forIndexPath:indexPath];
        return cell;
    }
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataSource.count) {
        CGGoodsCell *cell = (CGGoodsCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self.delegate clickGoodsCell:cell atIndex:indexPath.row activityType:Activity_ZeroBuy];
    }else{
        [self.delegate seeMoreGoodsWithActivityType:Activity_ZeroBuy];
    }
}

- (void)reloadData{
    [self.collectionView reloadData];
}

- (void)startCountDownTime:(NSDate *)date{
    [self.timerView startCountDownTime:date];
}


#pragma mark getter
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(80.0f, 156.0f);
        _flowLayout.minimumLineSpacing = 15.0f;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
        _flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"home_arrow"];
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    }
    return _detailTextLabel;
}

- (HMCountTimerView *)timerView{
    if (!_timerView) {
        _timerView = [[HMCountTimerView alloc] init];
    }
    return _timerView;
}

@end

#if 0
/******************全球买手得首页Cell*********************************/
@interface HMGlobleBuyerCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@end

@implementation HMGlobleBuyerCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize imageView = _imageView;
@synthesize collectionView = _collectionView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"class = %@",[self class]);
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
        self.layer.cornerRadius = 7.0f;
        [self layout];
        [self.collectionView registerClass:[CGGlobleBuyerCell class] forCellWithReuseIdentifier:@"CGGlobleBuyerCell"];
        @weakify(self);
        [[RACObserve(self, dataSource) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.collectionView reloadData];
        }];
    }
    return self;
}

- (void)layout{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0f);
        make.top.equalTo(self.contentView).offset(23.0f);
//        make.height.mas_equalTo(17.0f);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20.0f);
        make.size.mas_equalTo(CGSizeMake(6.0f, 11.0f));
        make.centerY.equalTo(self.textLabel);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textLabel.mas_right).offset(10.0f);
        make.right.mas_equalTo(self.imageView.mas_left).offset(-10.0f);
        make.bottom.equalTo(self.textLabel);
    }];
   
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(20.0f);
//        make.height.mas_equalTo(161.0f);
        make.bottom.mas_equalTo(-20.0f);
    }];
    [self.textLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGGlobleBuyerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGGlobleBuyerCell" forIndexPath:indexPath];
    XKGoodListModel *goodModel = [self.dataSource objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:goodModel.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    cell.textLabel.text = goodModel.commodityName;
    cell.couponLabel.value = goodModel.couponValue.doubleValue/100.00f;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    [attr appendAttributedString:PriceDef(goodModel.commodityPrice.doubleValue/100.00f)];
    [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
    [attr appendAttributedString:PriceDef_line(goodModel.salePrice.doubleValue/100.00f)];
    cell.priceLabel.attributedText = attr;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CGGoodsCell *cell = (CGGoodsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate clickGoodsCell:cell atIndex:indexPath.row activityType:Activity_Global];
}



#pragma mark getter
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(100, 161.0f);
        _flowLayout.minimumInteritemSpacing = 12.0f;
        _flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
    }
    return _flowLayout;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"home_arrow"];
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    }
    return _detailTextLabel;
}

@end

#else

@implementation HMGlobleBuyerCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"class = %@",[self class]);
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
        self.layer.cornerRadius = 7.0f;
        self.clipsToBounds = YES;
    }
    return self;
}

-(UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes {
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
    CGRect cellFrame = layoutAttributes.frame;
    cellFrame.size.height= size.height;
    layoutAttributes.frame= cellFrame;
    return layoutAttributes;
}

@end

#endif

@implementation HMMultiDiscountCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"class = %@",[self class]);
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
        self.layer.cornerRadius = 7.0f;
        self.clipsToBounds = YES;
    }
    return self;
}

-(UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes {
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
    CGRect cellFrame = layoutAttributes.frame;
    cellFrame.size.height= size.height;
    layoutAttributes.frame= cellFrame;
    return layoutAttributes;
}

@end
