//
//  XKMineContentView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MineContentView.h"
#import "XKUIUnitls.h"

typedef NS_ENUM(int,MineFunctionViewCellLayoutStyle) {
    MineFunctionViewCellLayoutStyleValue1   =   0,
    MineFunctionViewCellLayoutStyleValue2   =   1,
};

@interface MineFunctionViewCell : UICollectionViewCell

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UILabel *descLabel;

@property (nonatomic,strong,readonly) UILabel *signLabel;

@property (nonatomic,assign) MineFunctionViewCellLayoutStyle layoutStyle;

@end

@implementation MineFunctionViewCell
@synthesize imageView = _imageView;
@synthesize descLabel = _descLabel;
@synthesize signLabel = _signLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = HexRGB(0xffffff, 1.0f);
        [self.contentView addSubview:self.signLabel];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.descLabel];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize signSize =  [self.signLabel sizeThatFits:CGSizeMake(100.0f, 10.0f)];
    self.signLabel.frame = CGRectMake(0, 0, signSize.width, 10.0f);
    if (self.layoutStyle == MineFunctionViewCellLayoutStyleValue1) {
        self.imageView.frame = CGRectMake(CGRectGetMidX(self.bounds)-12.0f, 17.0f, 24.0f, 24.0f);
        self.descLabel.frame = CGRectMake(0, 53.0f, CGRectGetWidth(self.bounds), 12.0f);
    }else{
        self.imageView.frame = CGRectMake(CGRectGetMidX(self.bounds)-12.0f, 13.0f, 24.0f, 24.0f);
        self.descLabel.frame = CGRectMake(0, 48.0f, CGRectGetWidth(self.bounds), 12.0f);
    }
    
}

#pragma mark getter or setter

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:12.0f];
        _descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descLabel;
}

- (UILabel *)signLabel{
    if (!_signLabel) {
        _signLabel = [[UILabel alloc] init];
        _signLabel.font = [UIFont systemFontOfSize:8.0f];
        _signLabel.textColor = HexRGB(0xffffff, 1.0f);
        _signLabel.backgroundColor = HexRGB(0xf1272f, 1.0f);
        _signLabel.layer.cornerRadius = 5.0f;
        _signLabel.layer.borderColor = [HexRGB(0xffffff, 1.0f) CGColor];
        _signLabel.layer.borderWidth = 2.0f;
    }
    return _signLabel;
}


@end

@interface MIPubReusableView  : UICollectionReusableView

@property (nonatomic,strong,readonly)UILabel *textLabel;

@end

@implementation MIPubReusableView
@synthesize textLabel = _textLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16.0f);
            make.top.equalTo(self).mas_offset(20.0f);
            make.bottom.equalTo(self).offset(-10.0f);
        }];
    }
    return self;
}


- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    }
    return _textLabel;
}

@end

typedef NS_ENUM(int,MIPerFuncType) {
    MIPerFuncTypeBuyer  =   0,
    MIPerFuncTypeSeller =   1,
};

@class MIPerReusableView;
@protocol MIPerReusableViewDelegate <NSObject>

- (void)perReusableView:(MIPerReusableView *)reusableView perfuncType:(MIPerFuncType) funcType;

@end

@interface MIPerReusableView  : UICollectionReusableView

@property (nonatomic,strong,readonly)UIButton *buyerBtn;

@property (nonatomic,strong,readonly)UIButton *sellerBtn;

@property (nonatomic,strong,readonly)UIView *selectLine;

@property (nonatomic,weak)id<MIPerReusableViewDelegate> delgate;

@end

@implementation MIPerReusableView
@synthesize buyerBtn = _buyerBtn;
@synthesize sellerBtn = _sellerBtn;
@synthesize selectLine = _selectLine;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self layout];
    }
    return self;
}

- (void)setupUI{
    [self.buyerBtn setTitle:@"我是买家" forState:UIControlStateNormal];
    [self.buyerBtn setSelected:YES];
    [self.buyerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [self.buyerBtn addTarget:self action:@selector(buyerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sellerBtn setTitle:@"我是卖家" forState:UIControlStateNormal];
    [self.sellerBtn setSelected:NO];
    [self.sellerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [self.sellerBtn addTarget:self action:@selector(sellerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.selectLine setBackgroundColor:HexRGB(0x444444, 1.0f)];
    //[self.spreadLine setBackgroundColor:HexRGB(0xe4e4e4, 1.0f)];
    
    [self addSubview:self.buyerBtn];
    [self addSubview:self.sellerBtn];
    [self addSubview:self.selectLine];
}

- (void)layout{
    [self.buyerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(45.0f);
        make.width.mas_equalTo(0.5*(kScreenWidth-30.0f));
    }];
    
    [self.sellerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(45.0f);
        make.width.mas_equalTo(0.5*(kScreenWidth-30.0f));
    }];
    self.selectLine.frame = CGRectMake(0.25*(kScreenWidth-30.0f) - 12.5f, 37.0f,25.0f, 2.0f);
}

#pragma mark
- (void)buyerAction:(id)sender{
    if (self.buyerBtn.isSelected == NO) {
        self.buyerBtn.selected = YES;
        self.sellerBtn.selected = NO;
        self.buyerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.sellerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        self.selectLine.frame =  CGRectMake(0.25*(kScreenWidth-30.0f) - 12.5f, 37.0f,25.0f, 2.0f);
        [self.delgate perReusableView:self perfuncType:MIPerFuncTypeBuyer];
    }
}

- (void)sellerAction:(id)sender{
    if (self.sellerBtn.isSelected == NO) {
        self.sellerBtn.selected = YES;
        self.buyerBtn.selected = NO;
        self.sellerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.buyerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        self.selectLine.frame =  CGRectMake(0.75*(kScreenWidth-30.0f) - 12.5f, 37.0f,25.0f, 2.0f);
        [self.delgate perReusableView:self perfuncType:MIPerFuncTypeSeller];
    }
}


#pragma mark getter or setter
- (UIButton *)buyerBtn{
    if (!_buyerBtn) {
        _buyerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyerBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        [_buyerBtn setBackgroundImage:[UIImage imageNamed:@"mi_bt_bn"] forState:UIControlStateNormal];
        [_buyerBtn setBackgroundImage:[UIImage imageNamed:@"mi_bt_bs"] forState:UIControlStateSelected];
        
    }
    return _buyerBtn;
}

- (UIButton *)sellerBtn{
    if (!_sellerBtn) {
        _sellerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sellerBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        [_sellerBtn setBackgroundImage:[UIImage imageNamed:@"mi_bt_sn"] forState:UIControlStateNormal];
        [_sellerBtn setBackgroundImage:[UIImage imageNamed:@"mi_bt_ss"] forState:UIControlStateSelected];
    }
    return _sellerBtn;
}

- (UIView *)selectLine{
    if (!_selectLine) {
        _selectLine = [[UIView alloc] init];
        _selectLine.layer.cornerRadius = 1.0f;
    }
    return _selectLine;
}


@end


@interface MineContentView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MIPerReusableViewDelegate>

//@property (nonatomic,strong,readonly)CAShapeLayer *shapeLayer;

@property (nonatomic,strong,readonly)UICollectionView *personCollectionView;

@property (nonatomic,strong,readonly)UICollectionView *publicCollectionView;

@property (nonatomic,strong,readonly)UICollectionViewFlowLayout *perFl;

@property (nonatomic,strong,readonly)UICollectionViewFlowLayout *pubFl;

@property (nonatomic,assign)MIPerFuncType perFuncType;

@end

@implementation MineContentView{
    CGFloat pOffsetX;
}
//@synthesize shapeLayer = _shapeLayer;
@synthesize personCollectionView = _personCollectionView;
@synthesize publicCollectionView = _publicCollectionView;
@synthesize perFl = _perFl;
@synthesize pubFl = _pubFl;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //[self.layer addSublayer:self.shapeLayer];
        self.layer.backgroundColor = [COLOR_VIEW_GRAY CGColor];
        _perFuncType = MIPerFuncTypeBuyer;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.personCollectionView];
    [self addSubview:self.publicCollectionView];
    [self setupCollectView];
}

- (void)autoLayout{
    [self.personCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0f);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(200.0f);
    }];
    
    [self.publicCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.personCollectionView);
        make.top.mas_equalTo(self.personCollectionView.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(270.0f);
    }];
}

- (void)setupCollectView{
    [self.personCollectionView registerClass:[MineFunctionViewCell class] forCellWithReuseIdentifier:@"MineFunctionViewCell"];
    [self.publicCollectionView registerClass:[MineFunctionViewCell class] forCellWithReuseIdentifier:@"MineFunctionViewCell"];
    [self.personCollectionView registerClass:[MIPerReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MIPerReusableView"];
    [self.publicCollectionView registerClass:[MIPubReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MIPubReusableView"];
}


#pragma mark collectionView delegate and data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.personCollectionView) {
        if (self.perFuncType == MIPerFuncTypeBuyer) {
            return self.buyerFuns.count;
        }else{
            return self.sellerFuns.count;
        }
    }else{
        return self.publicFuns.count;
    }
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MineFunctionViewCell *cell =  (MineFunctionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MineFunctionViewCell" forIndexPath:indexPath];
    MIFunctionDesc *functionDesc = nil;
    if (collectionView == self.personCollectionView) {
        cell.layoutStyle = MineFunctionViewCellLayoutStyleValue1;
        if (self.perFuncType == MIPerFuncTypeBuyer) {
            functionDesc = [self.buyerFuns objectAtIndex:indexPath.row];
        }else{
             functionDesc = [self.sellerFuns objectAtIndex:indexPath.row];
        }
        cell.descLabel.textColor = HexRGB(0x444444, 1.0f);
        cell.descLabel.font = [UIFont systemFontOfSize:12.0f];
    }else{
        cell.layoutStyle = MineFunctionViewCellLayoutStyleValue2;
        functionDesc = [self.publicFuns objectAtIndex:indexPath.row];
        cell.descLabel.textColor = HexRGB(0x999999, 1.0f);
        cell.descLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    cell.imageView.image = functionDesc.image;
    cell.descLabel.text = functionDesc.descText;
    return cell;
}



// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (![kind isEqualToString:UICollectionElementKindSectionHeader])return nil;
    if (collectionView == self.personCollectionView) {
        MIPerReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MIPerReusableView" forIndexPath:indexPath];
        reusableView.delgate = self;
        return reusableView;
    }else{
        MIPubReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MIPubReusableView" forIndexPath:indexPath];
        reusableView.textLabel.text = @"我的服务";
        return reusableView;
    }
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MIFunctionDesc *functionDesc = nil;
    
    if (collectionView == self.personCollectionView) {
        if (self.perFuncType == MIPerFuncTypeBuyer) {
            functionDesc = [self.buyerFuns objectAtIndex:indexPath.row];
        }else{
            functionDesc = [self.sellerFuns objectAtIndex:indexPath.row];
        }
    }else{
        functionDesc = [self.publicFuns objectAtIndex:indexPath.row];
    }
    
    if ([self.delegate respondsToSelector:@selector(contentView:functionCategory:)]) {
        [self.delegate contentView:self functionCategory:functionDesc.functionCategory];
    }
}

- (void)perReusableView:(MIPerReusableView *)reusableView perfuncType:(MIPerFuncType)funcType{
    _perFuncType =  funcType;
    if(self.perFuncType == MIPerFuncTypeBuyer){
         _perFl.itemSize = CGSizeMake((kScreenWidth-30.0f)/4.0f, 70.0f);
    }else{
         _perFl.itemSize = CGSizeMake((kScreenWidth-30.0f)/3.0f, 70.0f);
    }
    [self.personCollectionView reloadData];
    [self sizeToFit];
}

#pragma mark public methods
//透明区域
//- (UIBezierPath *)clearBezierPath{
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//    CGPathMoveToPoint(pathRef, &CGAffineTransformIdentity, 0, 0);
//    CGPathAddQuadCurveToPoint(pathRef, &CGAffineTransformIdentity, CGRectGetMidX(self.bounds), 30.0f, CGRectGetWidth(self.bounds),0);
//    CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity,0, 0);
//    CGPathCloseSubpath(pathRef);
//
//    UIBezierPath *clearPath = [UIBezierPath bezierPathWithCGPath:pathRef];
//
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
//    [path appendPath:clearPath];
//    path.usesEvenOddFillRule = YES;
//    CGPathRelease(pathRef);
//    return path;
//}



- (void)sizeToFit{
    NSUInteger cellCount = 0;
    if (self.perFuncType == MIPerFuncTypeBuyer) {
        cellCount = self.buyerFuns.count;
    }else{
        cellCount = self.sellerFuns.count;
    }
    CGFloat AW =   kScreenWidth-30.0f;
    NSUInteger lineCount = 4;
    //CGFloat width =  AW/lineCount;
    CGFloat height = 70.0f;
    CGFloat headerH = 55.0f;
    CGSize size = CGSizeMake(AW, ((cellCount-1)/lineCount + 1)*height + headerH);
    [UIView animateWithDuration:0.25 animations:^{
        [self.personCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height);
        }];
        [self layoutIfNeeded];
    }];
   
    
}


#pragma mark getter
//- (CAShapeLayer *)shapeLayer{
//    if (!_shapeLayer) {
//        _shapeLayer = [CAShapeLayer layer];
//        _shapeLayer.fillColor  = [COLOR_VIEW_GRAY CGColor];
//        _shapeLayer.fillRule = kCAFillRuleEvenOdd;
//    }
//    return _shapeLayer;
//}


- (UICollectionView *)personCollectionView{
    if (!_personCollectionView) {
        _personCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.perFl];
         //_personCollectionView.contentInset = UIEdgeInsetsMake(20.0f, 10.0f, 20.0f, 10.0f);
        _personCollectionView.backgroundColor = [UIColor whiteColor];
       // _personCollectionView.pagingEnabled = YES;
        _personCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        _personCollectionView.delegate = self;
        _personCollectionView.dataSource = self;
        _personCollectionView.showsHorizontalScrollIndicator = NO;
        _personCollectionView.alwaysBounceHorizontal = NO;
        _personCollectionView.alwaysBounceVertical = NO;
        _personCollectionView.layer.cornerRadius = 10.0f;
        _personCollectionView.clipsToBounds = YES;
    }
    return _personCollectionView;
}

- (UICollectionView *)publicCollectionView{
    if (!_publicCollectionView) {
        _publicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.pubFl];
        //        _publicCollectionView.contentInset = UIEdgeInsetsMake(20.0f, 15.0f, 20.0f, 15.0f);
        _publicCollectionView.backgroundColor = [UIColor whiteColor];
        _publicCollectionView.delegate = self;
        _publicCollectionView.dataSource = self;
        _publicCollectionView.bounces = NO;
        _publicCollectionView.layer.cornerRadius = 10.0f;
        _publicCollectionView.clipsToBounds = YES;
    }
    return _publicCollectionView;
}

- (UICollectionViewFlowLayout *)perFl{
    if (!_perFl) {
        _perFl = [[UICollectionViewFlowLayout alloc] init];
        _perFl.scrollDirection = UICollectionViewScrollDirectionVertical;
        _perFl.minimumLineSpacing = 0.0f;
        _perFl.minimumInteritemSpacing = 0.0f;
        _perFl.headerReferenceSize = CGSizeMake(kScreenWidth-30.0f, 45.0f);
        _perFl.itemSize = CGSizeMake((kScreenWidth-30.0f)/4.0f, 70.0f);
    }
    return _perFl;
}

- (UICollectionViewFlowLayout *)pubFl{
    if (!_pubFl) {
        _pubFl = [[UICollectionViewFlowLayout alloc] init];
        _pubFl.scrollDirection = UICollectionViewScrollDirectionVertical;
        _pubFl.minimumLineSpacing = 0.0f;
        _pubFl.minimumInteritemSpacing = 0.0f;
        _pubFl.itemSize = CGSizeMake((kScreenWidth-30)/4.0f, 70.0f);
        _pubFl.headerReferenceSize = CGSizeMake(kScreenWidth-30.0f, 53.0f);
    }
    return _pubFl;
}

@end
