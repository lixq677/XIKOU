//
//  ACTNewGoodsVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTNewGoodsVC.h"
#import "XKBannerView.h"
#import "HMViews.h"
#import "HMFlowLayout.h"
#import "CGGoodsView.h"
#import "ACTNewFlowLayout.h"
#import "BCTools.h"

@interface ACTNewGoodsVC ()
<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
ACTNewFlowLayoutDelegate>


@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)XKBannerView *bannerView;

@property (nonatomic, strong)ACTNewFlowLayout *flowLayout;

@property (nonatomic, strong)NSMutableArray *goodsList;

@property (nonatomic, strong)UICollectionView *coltView;

@property (nonatomic, strong)ACTNewFlowLayout *coltLayout;

@end

@implementation ACTNewGoodsVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新品价到";
    [self setupUI];
    [self autolayout];
}

- (void)setupUI {
    self.bannerView.frame = CGRectMake(0, 0, kScreenWidth,scalef(180.0f));
    [self.collectionView addSubview:self.bannerView];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView addSubview:self.coltView];
    
    [self.coltView registerClass:[CGBrandCell class] forCellWithReuseIdentifier:@"CGBrandCell"];
    [self.coltView registerClass:[HMReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HMReusableView"];
    
    
    
    [self.collectionView registerClass:[HMReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HMReusableView"];
//    [self.collectionView registerClass:[CGNewUserCell class] forCellWithReuseIdentifier:@"CGNewUserCell"];
//
//     [self.collectionView registerClass:[CGMultiDiscountCell class] forCellWithReuseIdentifier:@"CGMultiDiscountCell"];
//
//     [self.collectionView registerClass:[CGBrainNCell class] forCellWithReuseIdentifier:@"CGBrainNCell"];
//
//     [self.collectionView registerClass:[CGGlobleBuyerCell class] forCellWithReuseIdentifier:@"CGGlobleBuyerCell"];
    [self.collectionView registerClass:[CGGlobleBuyerNCell class] forCellWithReuseIdentifier:@"CGGlobleBuyerNCell"];
    
    [self.collectionView registerClass:[CGWgNCell class] forCellWithReuseIdentifier:@"CGWgNCell"];
    
    
    
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
}

- (void)autolayout{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.coltView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.right.mas_equalTo(-10.0f);
        make.height.mas_equalTo(117.0f);
        make.width.mas_equalTo(kScreenWidth-20.0f);
        make.top.mas_equalTo(scalef(160.0f));
    }];
}




/****************collectionView 数据展示*****************/

#pragma mark collectionView 的代理和数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.coltView) {
        return 4;
    }else{
        return 8;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.coltView) {
        NSArray<NSString *> *images = @[@"1b",@"4b",@"3b",@"2b"];
        NSArray<NSString *> *titles = @[@"上新1款",@"上新6款",@"上新3款",@"上新3款",@"上新3款"];
        CGBrandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGBrandCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
        cell.textLabel.text = titles[indexPath.row];
        return cell;
    }else{
        NSArray<NSString *> *images = @[@"1a",@"2a",@"8a",@"5a",@"6a",@"3a",@"7a",@"4a"];
        NSArray<NSString *> *titles = @[@"Converse/匡威联名红心帆布鞋 白色高帮 150205C",@"DW男织纹40mm手表石英女表36mm情侣表",@"Dior/迪奥全新烈艳蓝金唇膏口红520 3.5g",@"NIKE/耐克男鞋减震防滑舒适透气运动休闲跑步鞋",@"MICHAEL KORS/迈克 科尔斯 MK女包 CYNTHIA系列黑",@"TISSOT/天梭瑞士手表 俊雅系列石英男士手表",@"LV/路易威登POCHETTE老花单肩手提包邮差包",@"YSL/圣罗兰莹亮纯魅唇膏 （圆管口红）4.5g"];
        NSArray<NSString *> *prices = @[@"360",@"1170",@"142.5",@"678",@"1165.5",@"1147.5",@"6483",@"64.5"];
//        if (indexPath.row == 0) {
//            CGBrainNCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGBrainNCell" forIndexPath:indexPath];
//            cell.imageView.image = [UIImage imageNamed:@(indexPath.row+1).stringValue];
//            cell.textLabel.text = titles[indexPath.row];
//            cell.detailLabel.text = @" 8人助力 ";
//            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
//            [attr appendAttributedString:PriceDef(prices[indexPath.row].floatValue)];
//            [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
//            [attr appendAttributedString:PriceDef_line(499)];
//            cell.priceLabel.attributedText = attr;
//            return cell;
//        }else if(indexPath.row == 1){
            CGGlobleBuyerNCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGGlobleBuyerNCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
            cell.textLabel.text = titles[indexPath.row];
            cell.couponLabel.value = [prices[indexPath.row] intValue]*2;
            //cell.couponLabel.hidden = YES;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
            [attr appendAttributedString:PriceDef(prices[indexPath.row].floatValue)];
            [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
            [attr appendAttributedString:PriceDef_line(499)];
            cell.priceLabel.attributedText = attr;
            return cell;
//        }else if (indexPath.row == 2){
//            CGWgNCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGWgNCell" forIndexPath:indexPath];
//            cell.imageView.image = [UIImage imageNamed:@(indexPath.row+1).stringValue];
//            cell.textLabel.text = titles[indexPath.row];
//            cell.detailLabel.text = @" 赠券4800 ";
//
//            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
//            [attr appendAttributedString:PriceDef(prices[indexPath.row].floatValue)];
//            [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
//            [attr appendAttributedString:PriceDef_line(499)];
//            cell.priceLabel.attributedText = attr;
//            return cell;
//        }else if (indexPath.row == 3){
//            CGMultiDiscountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGMultiDiscountCell" forIndexPath:indexPath];
//            cell.imageView.image = [UIImage imageNamed:@(indexPath.row+1).stringValue];
//            cell.textLabel.text = titles[indexPath.row];
//
//            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
//            [attr appendAttributedString:PriceDef(prices[indexPath.row].floatValue)];
//            [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
//            [attr appendAttributedString:PriceDef_line(499)];
//            cell.priceLabel.attributedText = attr;
//
//            cell.discountLabel.text = [NSString stringWithFormat:@" 最低%@折 ",@(3)];
//            cell.saleNumLabel.text = [NSString stringWithFormat:@" 热销%@件 ",@(12)];
//
//            return cell;
//        }else if (indexPath.row == 4){
//            CGNewUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGNewUserCell" forIndexPath:indexPath];
//            cell.imageView.image = [UIImage imageNamed:@(indexPath.row+1).stringValue];
//            cell.textLabel.text = titles[indexPath.row];
//            cell.detailLabel.text = @" 新人专享 ";
//
//            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
//            [attr appendAttributedString:PriceDef(prices[indexPath.row].floatValue)];
//            [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
//            [attr appendAttributedString:PriceDef_line(499)];
//            cell.priceLabel.attributedText = attr;
//            return cell;
//        }else{
//            CGNewUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGNewUserCell" forIndexPath:indexPath];
//            cell.imageView.image = [UIImage imageNamed:@(indexPath.row+1).stringValue];
//            cell.textLabel.text = titles[indexPath.row];
//            cell.detailLabel.text = @" 新人专享 ";
//
//            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
//            [attr appendAttributedString:PriceDef(prices[indexPath.row].floatValue)];
//            [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
//            [attr appendAttributedString:PriceDef_line(499)];
//            cell.priceLabel.attributedText = attr;
//            return cell;
//        }
    }
}


// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (![kind isEqualToString:UICollectionElementKindSectionHeader])return nil;
    if (self.coltView == collectionView) {
        HMReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HMReusableView" forIndexPath:indexPath];
        reusableView.textLabel.text = @"大牌上新";
        reusableView.detailTextLabel.text = @"新品大牌抢鲜报道";
        reusableView.imageView.hidden = YES;
        return reusableView;
    }else{
         HMReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HMReusableView" forIndexPath:indexPath];
        reusableView.textLabel.text = @"上新推荐";
        reusableView.detailTextLabel.text = @"猜你喜爱的折扣新美物";
        reusableView.imageView.hidden = YES;
        return reusableView;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XKShowToast(@"敬请期待");
}

- (CGSize)flowLayout:(ACTNewFlowLayout *)flowLayout sizeForItemAtSection:(NSInteger)section{
    if (flowLayout == self.coltLayout) {
        CGSize size = CGSizeMake(63.0f, 58.0f);
        return size;
    }else{
        CGSize size = CGSizeMake((kScreenWidth-45.0f)/2.0f, (kScreenWidth-45.0f)/2.0f+100.0f);
        return size;
    }
}

- (CGSize)flowLayout:(ACTNewFlowLayout *)flowLayout sizeForHeaderAtSection:(NSInteger)section{
    if (flowLayout == self.coltLayout) {
        return CGSizeMake(kScreenWidth-20, 51.0f);
    }else{
        return CGSizeMake(kScreenWidth, 51.0f);
    }
   
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (ACTNewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[ACTNewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.delegate = self;
        _flowLayout.offsetY = scalef(160.0f)+117.0f;
        _flowLayout.minimumLineSpacing = 15.0f;
        _flowLayout.minimumInteritemSpacing = 15.0f;
        //_flowLayout.sectionInset = UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
        //_flowLayout.sectionHeadersPinToVisibleBounds = YES;
    }
    return _flowLayout;
}

- (UICollectionView *)coltView{
    if (!_coltView) {
        _coltView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.coltLayout];
        _coltView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _coltView.delegate = self;
        _coltView.dataSource = self;
        _coltView.showsVerticalScrollIndicator = NO;
        _coltView.layer.cornerRadius = 7.0f;
    }
    return _coltView;
}

- (ACTNewFlowLayout *)coltLayout{
    if (!_coltLayout) {
        _coltLayout = [[ACTNewFlowLayout alloc] init];
        _coltLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _coltLayout.delegate = self;
        _coltLayout.sectionInset = UIEdgeInsetsMake(0, 10.0f, 0, 10.0f);
        _coltLayout.minimumLineSpacing = 21.0f;
        _coltLayout.headerReferenceSize = CGSizeZero;
        _coltLayout.footerReferenceSize = CGSizeZero;
        //_flowLayout.sectionHeadersPinToVisibleBounds = YES;
    }
    return _coltLayout;
}


- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc] init];
        _bannerView.dataSource = @[[UIImage imageNamed:@"tmp_ng_banner"]];
    }
    return _bannerView;
}

- (NSMutableArray *)goodsList{
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

@end
