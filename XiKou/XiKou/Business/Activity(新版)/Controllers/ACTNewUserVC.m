//
//  ACTNewUserVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTNewUserVC.h"
#import "XKBannerView.h"
#import "HMFlowLayout.h"
#import "CGGoodsView.h"
#import "ACTNewFlowLayout.h"
#import "BCTools.h"
#import "XKActivityService.h"
#import "XKAccountManager.h"
#import "MJDIYFooter.h"
#import "TABAnimated.h"
#import "XKHomeService.h"

@interface ACTNewUserReusableView  : UICollectionReusableView

@property (nonatomic,strong,readonly) UILabel *textLabel;

@property (nonatomic,strong,readonly) UIImageView *imageView;

@end

@implementation ACTNewUserReusableView
@synthesize textLabel = _textLabel;
@synthesize imageView = _imageView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textLabel];
        [self addSubview:self.imageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.mas_equalTo(18.0f);
            make.width.mas_equalTo(164.0f);
            make.top.mas_equalTo(16.0f);
        }];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.imageView);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(7.0f);
        }];
        
    }
    return self;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x999999, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_arrow"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end

static const int kPageCount =   10;
@interface ACTNewUserVC ()
<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
ACTNewFlowLayoutDelegate>

@property (nonatomic, strong)ACTNewFlowLayout *flowLayout;

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)XKBannerView *bannerView;

@property (nonatomic, strong)NSMutableArray *goodsList;


@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) UIView *footerBar;

@property (nonatomic,assign)NSUInteger curPage;

@property (nonatomic,strong) ACTMoudleModel *moudle;


@end

@implementation ACTNewUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新人专区";
    [self setupUI];
    [self autolayout];
}

- (void)setupUI {
    [self.view addSubview:self.collectionView];
    
    [self.collectionView addSubview:self.bannerView];
    if (![[XKAccountManager defaultManager] isLogin]) {
        [self.view addSubview:self.footerBar];
        [self.footerBar addSubview:self.button];
    }
    
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.collectionView registerClass:[ACTNewUserReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ACTNewUserReusableView"];
    [self.collectionView registerClass:[CGNewUserCell class] forCellWithReuseIdentifier:@"CGNewUserCell"];
    
    self.collectionView.tabAnimated =
    [TABCollectionAnimated animatedWithCellClass:[CGNewUserCell class] cellSize:CGSizeMake((kScreenWidth-45.0f)/2.0f, (kScreenWidth-45.0f)/2.0f+90.0f)];
    
    self.collectionView.tabAnimated.animatedCount = 4;
    self.collectionView.tabAnimated.animatedSectionCount = 1;
    
    [self.collectionView tab_startAnimationWithCompletion:^{
        [self loadNewData];
    }];
    
}

- (void)autolayout{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.collectionView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(scalef(428.0f));
    }];
    
    if (![[XKAccountManager defaultManager] isLogin]) {
        [self.footerBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo([XKUIUnitls safeBottom] + 90.0f);
        }];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(33.0f);
            make.right.mas_equalTo(-33.0f);
            make.width.mas_equalTo(kScreenWidth-66.0f);
            make.height.mas_equalTo(40.0f);
            make.top.mas_equalTo(0);
        }];
    }
}


- (void)queryActivityMoudle{
    @weakify(self);
    [[XKFDataService() actService]getActivityMoudleByActivityType:Activity_NewUser Complete:^(ACTMoudleResponse * _Nonnull response) {
        @strongify(self);
        if ([response isSuccess]) {
            [self handleData:response.data];
        }else{
            [response showError];
        }
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView tab_endAnimation];
    }];
}

- (void)handleData:(ACTMoudleData *)data{
    ACTMoudleModel *model = [data.sectionList firstObject];
    self.moudle = model;
    self.bannerView.dataSource = data.bannerList;
    if (model) {
        NSUInteger page = 1;
        NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
        [[XKFDataService() actService] getGoodListByActivityType:Activity_NewUser andCategoryId:model.id andPage:page andLimit:kPageCount andUserId:userId Complete:^(ACTGoodListRespnse * _Nonnull response) {
            if ([response isSuccess]) {
                ACTGoodListData *listData = response.data;
                [self.goodsList removeAllObjects];
                [self.goodsList addObjectsFromArray:listData.result];
                self.curPage = page;
                [self.collectionView reloadData];
                if (listData.result.count < kPageCount) {
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.collectionView.mj_footer endRefreshing];
                }
            }else{
                [response showError];
            }
        }];
    }
}

- (void)loadMoreData{
    if ([NSString isNull:self.moudle.id]) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSUInteger page = 1;
    page = self.curPage + 1;
   // [XKLoading show];
    @weakify(self);
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    [[XKFDataService() actService] getGoodListByActivityType:Activity_NewUser andCategoryId:self.moudle.id andPage:page andLimit:kPageCount andUserId:userId Complete:^(ACTGoodListRespnse * _Nonnull response) {
        @strongify(self);
      //  [XKLoading dismiss];
        if ([response isSuccess]) {
            ACTGoodListData *data = response.data;
            self.curPage = page;
            [self.goodsList addObjectsFromArray:data.result];
            [self.collectionView reloadData];
            if (data.result.count < kPageCount) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.collectionView.mj_footer endRefreshing];
            }
        }else{
            [response showError];
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)loadNewData{
    [self queryActivityMoudle];
}


/****************collectionView 数据展示*****************/

#pragma mark collectionView 的代理和数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGNewUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGNewUserCell" forIndexPath:indexPath];
    XKGoodListModel *commodityModel = [self.goodsList objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:commodityModel.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    cell.textLabel.text = commodityModel.commodityName;
    if (commodityModel.stock == 0) {
        cell.sellOutLabel.hidden = NO;
    }else{
        cell.sellOutLabel.hidden = YES;
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    [attr appendAttributedString:PriceDef(commodityModel.commodityPrice.doubleValue/100.00f)];
    [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
    [attr appendAttributedString:PriceDef_line(commodityModel.salePrice.doubleValue/100.00f)];
    cell.priceLabel.attributedText = attr;
    cell.detailLabel.text = @" 新人专享 ";
    return cell;
}


// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (![kind isEqualToString:UICollectionElementKindSectionHeader])return nil;
    ACTNewUserReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ACTNewUserReusableView" forIndexPath:indexPath];
    reusableView.textLabel.text = @"1元商品可任选一件带走";
    reusableView.imageView.image = [UIImage imageNamed:@"nug_tig"];
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (collectionView != self.collectionView) return;
    XKGoodListModel *model = [self.goodsList objectAtIndex:indexPath.row];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_NewUser),@"id":model.id} completion:nil];
}



- (CGSize)flowLayout:(ACTNewFlowLayout *)flowLayout sizeForItemAtSection:(NSInteger)section{
    return  CGSizeMake((kScreenWidth-45.0f)/2.0f, (kScreenWidth-45.0f)/2.0f+100.0f);
}

- (CGSize)flowLayout:(ACTNewFlowLayout *)flowLayout sizeForHeaderAtSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth-30, 73.0f);
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
        _flowLayout.offsetY = scalef(230.0f)+195.0f+18.0f;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
        _flowLayout.minimumLineSpacing = 15.0f;
        _flowLayout.minimumInteritemSpacing = 15.0f;
        _flowLayout.bottom = 90.0f;
        //_flowLayout.sectionHeadersPinToVisibleBounds = YES;
    }
    return _flowLayout;
}

- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc] init];
        UIImage *image = [[UIImage imageNamed:@"tmp_nu_banner"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 195.0f, 0) resizingMode:UIImageResizingModeStretch];
        _bannerView.dataSource = @[image];
        _bannerView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerView.clipsToBounds = YES;
    }
    return _bannerView;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"即刻领取会员权益" forState:UIControlStateNormal];
        [_button setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_button.titleLabel setFont:FontBoldMT(14.0f)];
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,310.0,40.0f);
        gl.startPoint = CGPointMake(1.0f, 1.0f);
        gl.endPoint = CGPointMake(0, 0.33);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:227/255.0 green:194/255.0 blue:157/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:187/255.0 green:148/255.0 blue:69/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        [_button.layer insertSublayer:gl atIndex:0];
        [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [MGJRouter openURL:kRouterLogin];
        }];
    }
    return _button;
}

- (UIView *)footerBar{
    if (!_footerBar) {
        _footerBar = [[UIView alloc] init];
        _footerBar.backgroundColor = HexRGB(0xffffff, 0.5f);
    }
    return _footerBar;
}

- (NSMutableArray *)goodsList{
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

@end
