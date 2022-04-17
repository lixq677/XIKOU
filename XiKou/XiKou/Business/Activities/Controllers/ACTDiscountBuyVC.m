//
//  ACTDiscountBuyVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/26.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTDiscountBuyVC.h"
#import "ACTDiscountBuyChildVC.h"
#import "XKPageController.h"
#import "XKBannerView.h"
#import "XKShareTool.h"
#import "UIBarButtonItem+Badge.h"
#import "XKActivityService.h"
#import "XKActivityCartService.h"
#import "XKAccountManager.h"
#import <TABAnimated.h>
#import "MJDIYHeader.h"
#import "ACTCartVC.h"

#import "ACTDiscountBuyChild1VC.h"
#import "ACTDiscountBuyChild2VC.h"

@interface XKGoodsList1Cell : UITableViewCell

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *detailTextLabel;

@property (nonatomic,strong)ACTDiscountBuyChild1VC *contentVC;

@end

@implementation XKGoodsList1Cell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.contentVC.view];
    self.contentView.backgroundColor = COLOR_VIEW_GRAY;
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.height.mas_equalTo(18.0f);
        make.top.mas_equalTo(20.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textLabel.mas_right).offset(10.0f);
        make.height.mas_equalTo(12.0f);
        make.bottom.equalTo(self.textLabel);
    }];
    
    [self.contentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(scalef(164.0f));
        make.bottom.mas_equalTo(5.0f);
    }];
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

- (ACTDiscountBuyChild1VC *)contentVC{
    if (!_contentVC) {
        _contentVC = [[ACTDiscountBuyChild1VC alloc] init];
    }
    return _contentVC;
}

@end

#define MenuHeight 55

@interface XKGoodsList2Cell : UITableViewCell
<WMPageControllerDataSource,
WMPageControllerDelegate>

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *detailTextLabel;

@property (nonatomic,strong)XKBannerView *bannerView;

@property (nonatomic, strong) XKPageController *contentController;

@property (nonatomic,strong)NSArray<ACTMoudleModel *>  *models;

@end


@implementation XKGoodsList2Cell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize imageView = _imageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.bannerView];
    [self.contentView addSubview:self.contentController.view];
    self.contentView.backgroundColor = COLOR_VIEW_GRAY;
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.height.mas_equalTo(18.0f);
        make.top.mas_equalTo(20.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textLabel.mas_right).offset(10.0f);
        make.height.mas_equalTo(12.0f);
        make.bottom.equalTo(self.textLabel);
    }];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(scalef(150));
    }];
    
    [self.contentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(10);
        make.height.mas_equalTo(kScreenHeight-kTopHeight);
        make.bottom.mas_equalTo(-20);
    }];
}


#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return [self.models count];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    ACTMoudleModel *model = [self.models objectAtIndex:index];
    return model.categoryName;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGRect frame = self.contentView.bounds;
    frame.origin.y = MenuHeight;
    frame.size.height = kScreenHeight-kTopHeight-MenuHeight-[XKUIUnitls safeBottom];
    return frame;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, kScreenWidth, MenuHeight);
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    ACTMoudleModel *model = [self.models objectAtIndex:index];
    ACTDiscountBuyChild2VC *controller = [[ACTDiscountBuyChild2VC alloc] init];
    controller.moduleId = model.id;
    return controller;
}



#pragma mark getter
- (XKPageController *)contentController {
    if (!_contentController) {
        _contentController = [XKPageController new];
        _contentController.dataSource = self;
        _contentController.delegate = self;
        _contentController.menuViewStyle = WMMenuViewStyleLine;
        _contentController.menuViewContentMargin = 0;
        _contentController.progressHeight = 2.5;
        _contentController.progressViewCornerRadius = 2.5/2;
        _contentController.progressViewBottomSpace = 5;
        _contentController.titleSizeSelected = 14;
        _contentController.titleSizeNormal = 14;
        _contentController.titleColorSelected = COLOR_HEX(0xE52024);
        _contentController.titleColorNormal = COLOR_HEX(0x444444);
        _contentController.progressColor = COLOR_HEX(0xE52024);
        _contentController.pageAnimatable = YES;
        _contentController.progressWidth = 40;
        //_contentController.menuItemWidth = 80;
        _contentController.automaticallyCalculatesItemWidths = YES;
        NSInteger numberOfPages = 0;
        if ([_contentController.dataSource respondsToSelector:@selector(numbersOfChildControllersInPageController:)]) {
            numberOfPages = [_contentController.dataSource numbersOfChildControllersInPageController:_contentController];
        }
//        if (numberOfPages > 3) {
//            NSMutableArray *itemMargins = [NSMutableArray array];
//            for (NSInteger i = 0; i <= numberOfPages; i ++) {
//                if (i > 0 && i < numberOfPages) {
//                    [itemMargins addObject:@(25)];
//                }else{
//                    [itemMargins addObject:@(0)];
//                }
//            }
//            self.contentController.itemsMargins = itemMargins;
//        }
        _contentController.view.backgroundColor = [UIColor clearColor];
        _contentController.scrollView.backgroundColor = [UIColor clearColor];
    }
    return _contentController;
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

- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc] init];
        _bannerView.layer.cornerRadius = 7.0f;
        _bannerView.clipsToBounds = YES;
    }
    return _bannerView;
}

@end




@interface ACTDiscountBuyVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong)XKBannerView *bannerView;

@property (nonatomic, strong) UIBarButtonItem * carItem;

@property (nonatomic, strong) ACTMoudleData *moudleData;

@property (nonatomic,strong) NSMutableArray<XKBannerData *> *bannerDatas;

@property (nonatomic,assign)BOOL allowScroll;

@end

@implementation ACTDiscountBuyVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*获取购物车物品数量*/
    [self getCartCount];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"多买多折";
    self.allowScroll = YES;
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self instanceNavBarItems];
    [self renderContents];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allowScroll:) name:@"ksAllowScroll" object:nil];
}


- (void)renderContents {
    [self.tableView registerClass:[XKGoodsList1Cell class] forCellReuseIdentifier:@"XKGoodsList1Cell"];
    [self.tableView registerClass:[XKGoodsList2Cell class] forCellReuseIdentifier:@"XKGoodsList2Cell"];
    self.bannerView.frame = CGRectMake(0, 0, kScreenWidth, scalef(150));
    self.tableView.tableHeaderView = self.bannerView;
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMoudleData)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initData];
    
}

- (void)instanceNavBarItems{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"hm_share"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 20, 30);
    [btn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton * carBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [carBtn setImage:[UIImage imageNamed:@"carBlack"] forState:UIControlStateNormal];
    carBtn.frame = CGRectMake(0, 0, 20, 30);
    [carBtn addTarget:self action:@selector(carClick) forControlEvents:UIControlEventTouchUpInside];
    _carItem = [[UIBarButtonItem alloc] initWithCustomView:carBtn];
    _carItem.badgeFont  = FontMedium(9.f);
    _carItem.badgeMinSize = 9.f;
    _carItem.badgePadding = 2.f;
    _carItem.badgeOriginX = 13;
    _carItem.badgeOriginY = 0;
    _carItem.shouldHideBadgeAtZero = YES;
    self.navigationItem.rightBarButtonItems = @[item,_carItem];
}

- (void)initData{
    /*从缓存中获取模块信息*/
    ACTMoudleData *moduleData = [[XKFDataService() actService] queryModuleDataFromCache:Activity_Discount];
    _moudleData = moduleData;
    [self dealData];
    
    /*从服务器获取模块信息*/
    [self getMoudleData];
    
}

- (void)getCartCount{
    if(![[XKAccountManager defaultManager] isLogin]) {
        return ;
    }
    @weakify(self);
    [[XKFDataService() cartService]getCartDataByUserId:[XKAccountManager defaultManager].account.userId Complete:^(ACTCartDataResponse * _Nonnull response) {
        @strongify(self);
        if ([response isSuccess]) {
            NSInteger number = 0;
            for (ACTCartStoreModel *model in response.data) {
                number += model.list.count;
            }
            self.carItem.badgeValue = [NSString stringWithFormat:@"%d",(int)number];
        }
    }];
}

// 获取模块信息
- (void)getMoudleData{
    @weakify(self);
    [[XKFDataService() actService]getActivityMoudleByActivityType:Activity_Discount Complete:^(ACTMoudleResponse * _Nonnull response) {
        @strongify(self);
        if (response.isSuccess) {
            self.moudleData = [response data];
            [self dealData];
            [self.tableView.mj_header endRefreshing];
        }else{
            [response showError];
        }
    }];
}

- (void)allowScroll:(NSNotification *)notif{
    self.allowScroll = [notif.object boolValue];
}

- (void)dealData{
    NSMutableArray<XKBannerData *> *dataSource = [NSMutableArray array];
    [self.bannerDatas removeAllObjects];
    for (XKBannerData *data in self.moudleData.bannerList) {
        if (data.position == XKBannerPositionTop) {
            [dataSource addObject:data];
        }else{
            [self.bannerDatas addObject:data];
        }
    }
    self.bannerView.dataSource = dataSource;
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY:%f",offsetY);
    CGRect frame = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    CGFloat y = frame.origin.y + 53 + scalef(150);
    BOOL allowScroll = NO;
    if (offsetY >= y) {
        allowScroll = YES;
        scrollView.contentOffset = CGPointMake(0, y);
    }else{
        allowScroll = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kcAllowScroll" object:@(allowScroll)];
    if (self.allowScroll == NO && offsetY < y) {
        scrollView.contentOffset = CGPointMake(0, y);
    }
}


#pragma mark action
- (void)shareClick{
    XKGoodsList1Cell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XKGoodListModel *gModel = [cell.contentVC.result firstObject];
    NSString *activityId = [gModel activityId];
    if (activityId.length == 0) {//自己动手，丰衣足食，到处取需要的数据
        XKShowToast(@"获取分享数据失败");
        return;
    };

    XKShareRequestModel *model = [XKShareRequestModel new];
    model.shopId = @"";//不传系统就要溜号了
    model.activityId = activityId;
    model.shareUserId = [XKAccountManager defaultManager].account.userId ? [XKAccountManager defaultManager].account.userId : @"";
    model.popularizePosition = SPActivityMutil;

    [[XKShareTool defaultTool]shareWithModel:model andTitle:@"分享到好友" andContent:nil andNeedPhoto:NO andUIType:ShareUIBottom];
}

- (void)carClick{
    if(![[XKAccountManager defaultManager] isLogin]) {
        [self enterLoginVC];
        return ;
    }
    ACTCartVC *vc = [[ACTCartVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        XKGoodsList1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKGoodsList1Cell" forIndexPath:indexPath];
        ACTMoudleModel *model = [self.moudleData.sectionList objectAtIndex:indexPath.row];
        cell.textLabel.text = model.categoryName;
        cell.detailTextLabel.text = model.categoryDescribe;
        if ([self.childViewControllers containsObject:cell.contentVC] == NO) {
            [self addChildViewController:cell.contentVC];
        }
        cell.contentVC.moduleId = model.id;
        return cell;
    }else{
        XKGoodsList2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKGoodsList2Cell" forIndexPath:indexPath];
        ACTMoudleModel *model = [self.moudleData.sectionList objectAtIndex:indexPath.row];
        cell.textLabel.text = model.categoryName;
        cell.detailTextLabel.text = model.categoryDescribe;
        cell.bannerView.dataSource = self.bannerDatas;
        cell.models = model.childSectionList;
        [cell.contentController reloadData];
        return cell;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc] init];
    }
    return _bannerView;
}

- (NSMutableArray<XKBannerData *> *)bannerDatas{
    if (!_bannerDatas) {
        _bannerDatas = [NSMutableArray array];
    }
    return _bannerDatas;
}

@end
