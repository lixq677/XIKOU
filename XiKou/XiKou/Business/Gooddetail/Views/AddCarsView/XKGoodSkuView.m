//
//  XKGoodAddCarView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodSkuView.h"
#import "XKNumberView.h"
#import "XKSkuGoodInfoView.h"
#import "XKGoodPropertyCell.h"
#import "XKGoodPropertyFooter.h"
#import "XKGoodPropertyHeader.h"
#import "UILabel+NSMutableAttributedString.h"
#import "NSString+Common.h"
#import <SKUDataFilter/ORSKUDataFilter.h>
#import "XKLeftAligmentFlowLayout.h"

typedef void (^sureBlock)(void);
@interface XKGoodSkuView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,ORSKUDataFilterDataSource>


/** 视图*/
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) XKSkuGoodInfoView *headView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *sureBtn;

/** 数据*/
@property (nonatomic, strong) sureBlock sureBlock;
@property (nonatomic, strong) ACTGoodDetailModel *detailModel;//详情
@property (nonatomic, strong) ORSKUDataFilter *filter;//sku
@property (nonatomic, strong,readonly) NSMutableArray<XKGoodSKUSpec *> *dataSource;//数据源
@property (nonatomic, strong,readonly) NSMutableArray<XKGoodSKUModel *> *skuData;//sku数据源
@property (nonatomic, assign) NSInteger maxQuantity;//当前所选sku最大库存

@property (nonatomic, assign) NSInteger selectNum;//所选商品数量

@property (nonatomic, strong) NSMutableArray *lineFeedIndexpaths;
@end

static NSString * const CellID = @"XKGoodPropertyCell";
static NSString * const HeadID = @"XKGoodPropertyHeader";
static NSString * const FootID = @"XKGoodPropertyFooter";
static NSString * const NormalFootID = @"NormalFootID";

@implementation XKGoodSkuView
@synthesize dataSource = _dataSource;
@synthesize skuData = _skuData;

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        self.swt = YES;
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.6);
        _filter     = [[ORSKUDataFilter alloc] initWithDataSource:self];
        //_filter.needDefaultValue = YES;
        _selectNum  = 1;
        _lineFeedIndexpaths = [NSMutableArray array];
        [self creatSubView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.swt == NO) {
        self.sureBtn.enabled = NO;
    }
}

#pragma mark creatSubView
- (void)creatSubView{
    [self addSubview:self.contentView];
    [self.contentView xk_addSubviews:@[self.headView,self.cancleBtn,self.sureBtn,self.collectionView]];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kScreenHeight - scalefHeight(159));
        make.top.equalTo(self).offset(kScreenHeight);
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(20);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(27);
        make.top.right.equalTo(self.contentView);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-30 - [XKUIUnitls safeBottom]);
        make.height.mas_equalTo(40);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.sureBtn.mas_top).offset(-8);
        make.top.equalTo(self.headView.mas_bottom);
    }];
    [self layoutIfNeeded];
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    XKGoodSKUSpec *spec = [self.dataSource objectAtIndex:section];
    return [spec.value count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKGoodPropertyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    XKGoodSKUSpec *spec = [self.dataSource objectAtIndex:indexPath.section];
    cell.propertyLabel.text = [spec.value objectAtIndex:indexPath.row];
    if ([self.filter.availableIndexPathsSet containsObject:indexPath]) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.propertyLabel.textColor = COLOR_TEXT_BLACK;
        cell.layer.borderColor   = HexRGB(0xcccccc, 1.0f).CGColor;
    }else {
        cell.contentView.backgroundColor = HexRGB(0xf9f9f9, 1.0f);
        cell.propertyLabel.textColor = HexRGB(0xcccccc, 1.0f);
        cell.layer.borderColor   = [[UIColor clearColor] CGColor];
    }
    if ([self.filter.selectedIndexPaths containsObject:indexPath]) {
        cell.contentView.backgroundColor = HexRGB(0xFEF2F2, 1.0f);
        cell.propertyLabel.textColor = HexRGB(0xE52024, 1.0f);
        cell.layer.borderColor   = HexRGB(0xE52024, 1.0f).CGColor;
    }
    if ([self.lineFeedIndexpaths containsObject:indexPath]) {
        cell.propertyLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        cell.propertyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        XKGoodPropertyHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeadID forIndexPath:indexPath];
        XKGoodSKUSpec *spec = [self.dataSource objectAtIndex:indexPath.section];
        view.titleLabel.text = spec.name;
        return view;
    } else {
        if (indexPath.section == self.dataSource.count - 1 && self.dataSource.count > 0) {
           XKGoodPropertyFooter *countView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FootID forIndexPath:indexPath];
           XKActivityRulerModel *rModel = self.detailModel.baseRuleModel;
           if (self.detailModel.activityType == Activity_Discount) {
               countView.numerView.maxValue = rModel.maxLimit == 0 ? 1 : rModel.maxLimit;
               countView.numerView.minValue = rModel.minLimit == 0 ? 1 : rModel.minLimit;
               countView.numerView.currentNumber = countView.numerView.minValue;
               countView.desLabel.text = [NSString stringWithFormat:@"限购%ld件",(long)rModel.maxLimit];
           }else{
               countView.desLabel.text = rModel.buyLimited ? [NSString stringWithFormat:@"限购%ld件",(long)rModel.buyLimit] : @"不限购";
               countView.numerView.maxValue = rModel.buyLimited  ? _detailModel.baseRuleModel.buyLimit : NSIntegerMax;
               countView.numerView.minValue = 1;
               countView.numerView.currentNumber = countView.numerView.minValue = 1;
           }
           XKGoodSKUModel *model = [self.filter currentResult];
           if (model && model.stock < countView.numerView.maxValue) {
               countView.numerView.maxValue = model.stock;
           }
           
           @weakify(self);
           countView.numerView.resultBlock = ^(NSInteger number, BOOL increaseStatus) {
               @strongify(self);
               self.selectNum = number;
           };
           return countView;
        }else{
            UICollectionReusableView *line = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NormalFootID forIndexPath:indexPath];
            return line;
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.filter didSelectedPropertyWithIndexPath:indexPath];
    [self setupSKU];
    [collectionView reloadData];
}

- (void)setupSKU{
    if (self.swt == NO)return;
    XKGoodSKUModel *model = [self.filter currentResult];
    if (model && model.stock > 0 ) {
        self.sureBtn.enabled = YES;
    }else{
        self.sureBtn.enabled = NO;
    }
    if (model.bargainStatus == BargainIng && self.from == XKSKUFromBargainBuy) {
        [self.sureBtn setTitle:@"您已经在砍这个商品了，去看看" forState:UIControlStateNormal];
    }else{
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    if(!model)return;
    if ([NSString isNull:model.skuImage] == NO) {
        [self.headView.coverView sd_setImageWithURL:[NSURL URLWithString:model.skuImage] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    }
    
    if (self.detailModel.activityType == Activity_Global) {
        self.headView.desLabel.text = [NSString  stringWithFormat:@"使用优惠券%.2f",model.deductionCouponAmount ? [model.deductionCouponAmount doubleValue]/100 :0];
    }else if (self.detailModel.activityType == Activity_WG) {
        self.headView.desLabel.text = [NSString  stringWithFormat:@"赠送优惠券%.2f",model.couponValue ? model.couponValue.doubleValue/100 : 0];
    }
    
    self.headView.stockLabel.text = [NSString stringWithFormat:@"库存 %d",(int)model.stock];
    if (self.detailModel.activityType == Activity_WG) {
        self.headView.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
    }else if (self.detailModel.activityType == Activity_Discount){
        self.headView.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commodityPriceOne doubleValue]/100];
    }else{
        self.headView.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commodityPrice doubleValue]/100];
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKGoodSKUSpec *spec = [self.dataSource objectAtIndex:indexPath.section];
    NSString *text = [spec.value objectAtIndex:indexPath.row];
    CGSize size    = [text sizeWithFont:FontMedium(13.f) andMaxW:kScreenWidth - 20 - 32];
    CGFloat width  = size.width + 20 + 4;
    CGFloat height = 35;
    if (width < 75){
        width  = 75;
    }
    if (width >= kScreenWidth - 32 - 20){
        width  = kScreenWidth - 32;
        height = size.height + 15;
        [self.lineFeedIndexpaths addObject:indexPath];
    }
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == self.dataSource.count - 1) {
        return CGSizeMake(kScreenWidth, 100);
    }
    return CGSizeMake(kScreenWidth, 10);
}

#pragma mark -- ORSKUDataFilterDataSource
- (NSInteger)numberOfSectionsForPropertiesInFilter:(ORSKUDataFilter *)filter {
    return self.dataSource.count;
}
- (NSArray *)filter:(ORSKUDataFilter *)filter propertiesInSection:(NSInteger)section {
    XKGoodSKUSpec *spec = [self.dataSource objectAtIndex:section];
    return spec.value;
}
- (NSInteger)numberOfConditionsInFilter:(ORSKUDataFilter *)filter {
    return self.skuData.count;
}
- (NSArray *)filter:(ORSKUDataFilter *)filter conditionForRow:(NSInteger)row {
    XKGoodSKUModel *skuModel = [self.skuData objectAtIndex:row];
    return skuModel.contition;
}

- (id)filter:(ORSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row {
    XKGoodSKUModel *skuModel = [self.skuData objectAtIndex:row];
    return skuModel;
}

#pragma mark dataHandle
- (void)dataHandle{
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    XKActivityRulerModel *rModel = self.detailModel.baseRuleModel;
    XKActivityType actType = self.detailModel.activityType;
    
    self.headView.titleLabel.text = gModel.commodityName;
    [self.headView.titleLabel setLineSpace:7.f];
    if (actType == Activity_WG) {
        self.headView.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[gModel.salePrice doubleValue]/100];
    }else if (actType == Activity_Discount){
        self.headView.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[gModel.commodityPriceOne doubleValue]/100];
    }else{
        self.headView.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[gModel.commodityPrice doubleValue]/100];
    }
    if (actType == Activity_Global) {
        self.headView.desLabel.text = [NSString  stringWithFormat:@"使用优惠券%.2f",rModel.deductionCouponAmount ? [rModel.deductionCouponAmount doubleValue]/100 :0];
    }else if (actType == Activity_Discount) {
        if (gModel.rateThree) self.headView.desLabel.text = [NSString  stringWithFormat:@"封顶%@折",gModel.rateOne];
    }else if (actType == Activity_WG) {
        self.headView.desLabel.text = [NSString  stringWithFormat:@"赠送优惠券%.2f",rModel.couponValue ? rModel.couponValue.doubleValue/100 : 0];
    }
    [self.headView.priceLabel handleRedPrice:FontSemibold(17.f)];
    
    NSArray *imgs = gModel.imageList;
    if (imgs.count > 0) {
        XKGoodImageModel *model = imgs[0];
        [self.headView.coverView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    }
    [self.dataSource removeAllObjects];
   // [self.dataSource addObjectsFromArray:gModel.models];
    [gModel.models enumerateObjectsUsingBlock:^(XKGoodSKUSpec * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *mary = [NSMutableArray arrayWithCapacity:obj.value.count];
        [obj.value enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([NSString isNull:string]) return;
            [mary addObject:string];
        }];
        obj.value = mary;
        if (obj.value.count == 0)return;
        [self.dataSource addObject:obj];
    }];
    
    [self.skuData removeAllObjects];
    //[self.skuData addObjectsFromArray:gModel.skuList];
    [gModel.skuList enumerateObjectsUsingBlock:^(XKGoodSKUModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *mary = [NSMutableArray arrayWithCapacity:obj.contition.count];
        [obj.contition enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([NSString isNull:string]) return;
            [mary addObject:string];
        }];
        obj.contition = mary;
        if (obj.contition.count == 0)return;
        [self.skuData addObject:obj];
    }];
    
    [self.collectionView reloadData]; //更新UI显示
    [self.filter reloadData];
    for (int i = 0; i<self.dataSource.count; i++) {
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
    }
}

#pragma mark action
- (void)sureClick{
    self.sureBlock();
}

#pragma mark ------------- show && dismiss
- (void)showWithData:(ACTGoodDetailModel *)data andComplete:(void(^)(XKGoodSKUModel *skuModel,NSInteger number))complete{
    _detailModel = data;
    [self dataHandle];
    @weakify(self);
    self.sureBlock = ^{
        @strongify(self);
        [UIView animateWithDuration:.3 animations:^{
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kScreenHeight);
            }];
            self.backgroundColor = COLOR_RGB(0, 0, 0, 0);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            complete(self.filter.currentResult,self.selectNum);
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self removeFromSuperview];
        }];
    };
    [self show];
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(scalefHeight(159));
        }];
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.6);
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(kScreenHeight);
        }];
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height - 30 - [XKUIUnitls safeBottom] - 40, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.collectionView.contentInset = UIEdgeInsetsZero;
}

#pragma mark ----------------  lazy
- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setImage:[UIImage imageNamed:@"car_cancel"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_cancleBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        [_cancleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _cancleBtn;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius  = 2.f;
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:COLOR_TEXT_BLACK] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:COLOR_TEXT_BLACK] forState:UIControlStateHighlighted];
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:COLOR_LINE_GRAY] forState:UIControlStateDisabled];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:FontMedium(15.f)];
        [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (XKSkuGoodInfoView *)headView{
    if (!_headView) {
        _headView = [[XKSkuGoodInfoView alloc]init];
    }
    return _headView;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        XKLeftAligmentFlowLayout *layout = [XKLeftAligmentFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, 34);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[XKGoodPropertyCell class] forCellWithReuseIdentifier:CellID];
        [_collectionView registerClass:[XKGoodPropertyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadID];
        [_collectionView registerClass:[XKGoodPropertyFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FootID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NormalFootID];
    }
    return _collectionView;
}

- (NSMutableArray <XKGoodSKUSpec *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray <XKGoodSKUModel *> *)skuData{
    if (!_skuData) {
        _skuData = [NSMutableArray array];
    }
    return _skuData;
}

@end
