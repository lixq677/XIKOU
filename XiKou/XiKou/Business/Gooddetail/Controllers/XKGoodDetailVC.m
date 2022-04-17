//
//  XKGoodDetailVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodDetailVC.h"
#import "XKMakePosterVC.h"
#import <MeiQiaSDK/MQManager.h>
#import "TABAnimated.h"
#import "MQChatViewManager.h"
#import "YBImageBrowser.h"

#import "XKShareTool.h"
#import "XKBannerView.h"
#import "XKGoodInfoCell.h"
#import "XKBargainPersonCell.h"
#import "XKGoodImageDetailView.h"
#import "UILabel+NSMutableAttributedString.h"

#import "XKWeakDelegate.h"
#import "XKUserService.h"
#import "XKOrderService.h"

#import "XKPlaceholdTableCell.h"

@interface XKGoodDetailVC ()<XKBannerViewDelegate,XKUserServiceDelegate,XKOrderServiceDelegate,YBImageBrowserDelegate,UITableViewDelegate,UITableViewDataSource>
//主tableview
//背景scrollview
@property (nonatomic, strong) UIScrollView *bgScrollView;
//轮播图
@property (nonatomic, strong) XKBannerView *bannerView;
//商品详情图片描述
@property (nonatomic, strong) XKGoodImageDetailView *imgDesView;

//banner背景图，用于实现层次
@property (nonatomic, strong) UIView *bannerBgView;
//轮播图page
@property (nonatomic, strong) UILabel *pageLabel;
//用于请求商品详情
@property (nonatomic, copy) NSString *activityGoodId;

@property (nonatomic, assign) XKActivityType type;

@end

@implementation XKGoodDetailVC{
    NSMutableArray *_detailImgArrays;
}

- (instancetype)initWithActivityGoodID:(NSString *)activityGoodID
                       andActivityType:(XKActivityType)type{
    self = [super init];
    if (self) {
        _rowDataArray = [NSMutableArray array];
        _activityGoodId = activityGoodID;
        _type         = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self getpaySwitch];
    [self instanceUI];
    [self blockActionHandle];
//    [self.btnsView reloadBlackBtnStatus:^(UIButton * _Nonnull button) {
//        button.enabled = NO;
//    }];
}

- (void)initialize{
    
    [self.navigationController setNavigationBarHidden:YES];
    self.rt_disableInteractivePop = NO;
    
    [[XKFDataService() userService] addWeakDelegate:self];
    [[XKFDataService() orderService] addWeakDelegate:self];
    
    [self.imgDesView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    self.tableView.tabAnimated =
    [TABTableAnimated animatedWithCellClassArray:@[[XKPlaceholdGoodInfoCell class],[XKPlaceholdTextCell class]]
                                 cellHeightArray:@[@([XKPlaceholdGoodInfoCell cellHeight]),@([XKPlaceholdTextCell cellHeight])]
                              animatedCountArray:@[@1,@3]];
    
    _tableView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
        if ([NSStringFromClass(manager.tabTargetClass) isEqualToString:NSStringFromClass([XKPlaceholdGoodInfoCell class])]) {
            manager.animation(1).color(COLOR_RGB(249, 65, 25, 0.3));
        }
    };
    
    [self.tableView tab_startAnimationWithCompletion:^{
        [self dataRequest];
    }];
}
/**
 下面俩个方法 登录状态改变刷新页面

 */
- (void)loginWithService:(XKUserService *)service userInfo:(XKAccountData *)data{
    [self dataRequest];
}

- (void)logoutWithService:(XKUserService *)service userId:(NSString *)userId{//退出登录 代理
    [self dataRequest];
}

/**
 订单创建成功，刷新商品库存等
 
 */
- (void)creatOrderSuccessComplete{
    [self dataRequest];
}

/**
 监听俩个tableView contentsize 的变化，动态改变其高度

 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"] && object == self.imgDesView) {
        CGSize contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        if ([@(self.imgDesView.height) integerValue] != [@(contentSize.height) integerValue]) {
            [_imgDesView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentSize.height);
            }];
        }
    }
    if ([keyPath isEqualToString:@"contentSize"] && object == self.tableView) {
        CGSize contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        if ([@(self.tableView.height) integerValue] != [@(contentSize.height) integerValue]) {
            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentSize.height);
            }];
        }
    }
}

#pragma mark ------- 获取下单开关,底部按钮状态处理
- (void)getpaySwitch{
    [[XKFDataService() otherService]queryPaySwitchCompletion:^(XKPaySwitchResponse * _Nonnull response) {
        if ([response isSuccess]) {
            self.paySwitchData = response.data;
        }
    }];
}

#pragma mark ------- datarequest
- (void)dataRequest{
    NSString *userId = [XKAccountManager defaultManager].account.userId ? [XKAccountManager defaultManager].account.userId :@"";
    [[XKFDataService() actService]getActivityGoodDetailByActivityGoodId:self.activityGoodId andActivityType:self.type andUserId:userId Complete:^(ACTGoodDetailRespnse * _Nonnull response) {
        if ([response isSuccess]) {
            self.detailModel = response.data;
            self.detailModel.activityCommodityAndSkuModel.activityType = self.type;
            [self reloadData];
            [self reloadBannerAndImgdestable];
            [self.tableView tab_endAnimationEaseOut];
        }else{
            [response showError];
        }
    }];
}

- (void)reloadBannerAndImgdestable{

    self.pageLabel.hidden = NO;
    
    XKGoodModel *goodModel = _detailModel.activityCommodityAndSkuModel;
    NSMutableArray *imgUrls = [NSMutableArray array];
    _detailImgArrays = [NSMutableArray array];
    for (XKGoodImageModel *imgModel in goodModel.imageList) {
        if (!imgModel.url) {
            continue;
        }
        if (imgModel.type == PositionBanner) {
            [imgUrls addObject:imgModel.url];
        }else{
            [_detailImgArrays addObject:imgModel];
        }
    }
    
    NSSortDescriptor *rankSort = [NSSortDescriptor sortDescriptorWithKey:@"rankNum" ascending:YES];
    [imgUrls sortedArrayUsingDescriptors:@[rankSort]];
    [_detailImgArrays sortedArrayUsingDescriptors:@[rankSort]];
    
    if ([self.detailModel.officialPictures isUrl]) {
        XKGoodImageModel *model = [[XKGoodImageModel alloc] init];
        model.url = self.detailModel.officialPictures;
        [_detailImgArrays addObject:model];
    }
   
    
    self.bannerView.dataSource = imgUrls;
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%ld",1,_bannerView.dataSource.count];
    [self.pageLabel setAttributedStringWithSubString:[NSString stringWithFormat:@"%d",1] font:FontBoldMT(17.f)];
    
    self.imgDesView.imgArray = _detailImgArrays;
}

- (void)reloadData{
    
    self.imgDesView.tableHeaderView = [self unitView];
    [self.tableView reloadData];
}

#pragma mark ----------------------- Action
- (void)blockActionHandle{
    @weakify(self);
    self.navView.actionBlock = ^(NavActionType type) {
        @strongify(self);
        if (type == ActionBack) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (type == ActionCart) {
            if(![[XKAccountManager defaultManager] isLogin]) {
                [self enterLoginVC];
                return ;
            }
            ACTCartVC *vc = [[ACTCartVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (type == ActionShare) {
            [self getShareData];
        }
        
    };
    self.btnsView.actionBlock = ^(DetailActionType type) {
        @strongify(self);
        if (type == ActionHomeBtn) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        if (type == ActionServiceBtn) {
            MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
            [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"meiqia-icon"]];
            [chatViewManager pushMQChatViewControllerInViewController:self];
        }
        if (type == ActionBlackBtn) {
            if(![[XKAccountManager defaultManager] isLogin]) {
                [self enterLoginVC];
                return;
            }
            if (!self.detailModel) return;
            [self bottomBlackButtonClick];
        }
        if (type == ActionBrownBtn) {
            if(![[XKAccountManager defaultManager] isLogin]) {
                [self enterLoginVC];
                return;
            }
            if (!self.detailModel) return;
            [self bottomBrownButtonClick];
        }
    };
}

#pragma mark ---------------------获取分享的数据
- (void)getShareData{
    if (!_detailModel.activityCommodityAndSkuModel) {
        return;
    }
    
    XKGoodModel *gModel = _detailModel.activityCommodityAndSkuModel;
    XKActivityType type = _detailModel.activityType;
    
    XKShareGoodModel *shareGoodModel = [XKShareGoodModel new];
    shareGoodModel.activityId      = gModel.activityId;
    shareGoodModel.activityGoodsId = gModel.id;
    shareGoodModel.goodsId         = gModel.goodsId;
    
    if (gModel.skuList.count > 0) {
        XKGoodSKUModel *sku = gModel.skuList[0];
        shareGoodModel.commodityId = sku.id;
        shareGoodModel.activityGoodsId = sku.id;
    }
    shareGoodModel.activityType    = type;
    
    XKShareRequestModel *model = [XKShareRequestModel new];
    model.activityGoodsCondition = shareGoodModel;
    model.shareUserId = [XKAccountManager defaultManager].account.userId ? [XKAccountManager defaultManager].account.userId : @"";
    
    if (type == Activity_WG)       model.popularizePosition = SPGoodDetailWug;
    if (type == Activity_Custom)   model.popularizePosition = SPGoodDetailCustom;
    if (type == Activity_Discount) model.popularizePosition = SPGoodDetailMutil;
    if (type == Activity_ZeroBuy)  model.popularizePosition = SPGoodDetailAuction;
    if (type == Activity_Bargain)  model.popularizePosition = SPGoodDetailBargain;
    if (type == Activity_Global)   model.popularizePosition = SPGoodDetailGlobal;
    if (type == Activity_NewUser)  model.popularizePosition = SPGoodDetailNewUser;
    
    XKShareTool *tool = [[XKShareTool alloc]init];
    tool.photoCallBack = ^(NSString *url){
        XKMakePosterVC *vc = [[XKMakePosterVC alloc]initWithGoodModel:self.detailModel.activityCommodityAndSkuModel URLString:url];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [tool shareWithModel:model andTitle:@"分享到好友" andContent:nil andNeedPhoto:YES andUIType:ShareUIBottom];
}

#pragma mark ---------------------底部购买按钮处理
- (void)reloadBuyButtonTitle{
    
}

/**
 子类多态实现
 */
- (void)bottomBlackButtonClick{
    
}

- (void)bottomBrownButtonClick{
    
}

#pragma mark --------------------------UI------------------------
- (void)instanceUI{
    
    [self.view xk_addSubviews:@[self.bgScrollView,self.navView,self.btnsView]];
    [self.bgScrollView xk_addSubviews:@[self.bannerBgView,self.tableView,self.imgDesView]];
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.btnsView.mas_top);
    }];
    [self.bannerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgScrollView);
        make.width.height.mas_equalTo(kScreenWidth);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bannerBgView);
        make.top.equalTo(self.bannerBgView.mas_bottom);
    }];
    [self.imgDesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bannerBgView);
        make.top.equalTo(self.tableView.mas_bottom);
        make.bottom.equalTo(self.bgScrollView);
    }];
    
    [self.bannerBgView xk_addSubviews:@[self.bannerView,self.pageLabel]];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bannerBgView);
    }];
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 25));
        make.right.bottom.mas_equalTo(-15);
    }];
    
    [self scrollViewDidScroll:self.tableView];
    
    self.navView.carBtn.hidden = (self.type != Activity_Discount);
    
}
#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSectionsInTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellForRowAtIndexPath:indexPath andTableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableViewDidSelectRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return [UIView new];
    }
    UITableViewHeaderFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"foot"];
    if (!footView) {
        footView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"foot"];
        footView.contentView.backgroundColor = [UIColor whiteColor];
        UIView *line = [UIView new];
        line.backgroundColor = COLOR_VIEW_GRAY;
        [footView.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(footView.contentView);
            make.height.mas_equalTo(9);
            make.top.mas_equalTo(15);
        }];
    }
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 0 ? CGFLOAT_MIN : 24;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alpha = 0;
    if (offsetY >=kScreenWidth) {
        alpha = 1;
        self.bannerView.top = -kScreenWidth;
//        self.navView.title = _detailModel.activityCommodityAndSkuModel.commodityName;
    }else if (offsetY <= 0){
        alpha = 0;
        self.bannerView.top = 0;
    }else{
        
        self.bannerView.top = offsetY/2;
        if (offsetY < kScreenWidth/3.*2) {
            alpha = offsetY/(kScreenWidth/3.*2);
        }else{
            alpha = 1;
        }
    }
    if (alpha == 1) {
        self.navView.title = @"商品详情";
    }else{
        self.navView.title = @"";
    }
    self.navView.currentAlpha = alpha;
} 

#pragma mark  - BannerView delegate
- (void)bannerView:(XKBannerView *)bannerView currentPage:(NSInteger)currentPage
{
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",currentPage+1,(unsigned long)bannerView.dataSource.count];
    [self.pageLabel setAttributedStringWithSubString:[NSString stringWithFormat:@"%ld",currentPage+1] font:FontBoldMT(17.f)];
    self.pageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
}

- (void)bannerView:(XKBannerView *)bannerView selectPage:(NSInteger)currentPage{
    NSMutableArray *datas = [NSMutableArray array];
    [self.bannerView.dataSource enumerateObjectsUsingBlock:^(NSString *_Nonnull imgUrl, NSUInteger idx, BOOL * _Nonnull stop) {
        YBIBImageData *data = [YBIBImageData new];
        data.projectiveView = bannerView;
        data.imageURL = [NSURL URLWithString:imgUrl];
        [datas addObject:data];
    }];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = currentPage;
    browser.delegate = self;
    [browser show];
    
}
#pragma mark -YBImageBrowser Delegate

- (void)yb_imageBrowser:(YBImageBrowser *)imageBrowser endTransitioningWithIsShow:(BOOL)isShow {
    isShow ? [self.bannerView startLoop] : [self.bannerView stopLoop];
}
- (void)yb_imageBrowser:(YBImageBrowser *)imageBrowser pageChanged:(NSInteger)page data:(id<YBIBDataProtocol>)data {
    [self.bannerView scrollToCurrentIndex:imageBrowser.currentPage];
}
- (void)dealloc
{
    [self.imgDesView removeObserver:self forKeyPath:@"contentSize"];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    [[XKFDataService() userService] removeWeakDelegate:self];
    [[XKFDataService() orderService] removeWeakDelegate:self];
}

#pragma  mark lazy
- (XKGoodDetailNavView *)navView{
    if (!_navView) {
        _navView = [[XKGoodDetailNavView alloc]init];
    }
    return _navView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.bounces         = NO;
        _tableView.scrollEnabled   = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorInset  = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [XKBannerView new];
        _bannerView.delegate = self;
        _bannerView.needPageControl = NO;
    }
    return _bannerView;
}

- (XKGoodDetailBtnView *)btnsView{
    if (!_btnsView) {
        _btnsView = [XKGoodDetailBtnView new];
    }
    return _btnsView;
}

- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [UIScrollView new];
        _bgScrollView.delegate = self;
        _bgScrollView.bounces  = YES;
        if (@available(iOS 11.0, *)) {
            _bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _bgScrollView;
}

- (UIView *)bannerBgView{
    if (!_bannerBgView) {
        _bannerBgView = [UIView new];
    }
    return _bannerBgView;
}

- (UILabel *)pageLabel{
    if (!_pageLabel) {
        _pageLabel = [UILabel new];
        _pageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _pageLabel.layer.cornerRadius  = 25/2.0;
        _pageLabel.layer.masksToBounds = YES;
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.font = Font(12.);
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.hidden = YES;
    }
    return _pageLabel;
}

- (XKGoodImageDetailView *)imgDesView{
    if (!_imgDesView) {
        _imgDesView = [[XKGoodImageDetailView alloc]init];
    }
    return _imgDesView;
}

#pragma mark getter
- (UIView *)unitView{
    UIView *unitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 50)];
    label.text = @"商品详情";
    label.font = FontMedium(16.f);
    [unitView addSubview:label];
    
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(15, 50, kScreenWidth - 30, 75)];;
    infoView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    infoView.layer.borderColor = COLOR_VIEW_GRAY.CGColor;

    [unitView addSubview:infoView];

    UIView *infoLabel1 = [self creatPropertylabel:@"供货商" andDes:self.detailModel.activityCommodityAndSkuModel.merchantName];
    UIView *infolabel2 = [self creatPropertylabel:@"品类" andDes:self.detailModel.activityCommodityAndSkuModel.categoryName];
    UIView *middleLine = [UIView new];
    middleLine.backgroundColor = COLOR_VIEW_GRAY;

    [infoView xk_addSubviews:@[infoLabel1,middleLine,infolabel2]];
    infoLabel1.y     = 0;
    middleLine.frame = CGRectMake(0, infoLabel1.bottom, infoView.width, 1/[UIScreen mainScreen].scale);
    infolabel2.y     = middleLine.bottom;
    infoView.height  = infolabel2.bottom;
    
    unitView.height = infoView.bottom + 10;
    
    return unitView;
}

- (UIView *)creatPropertylabel:(NSString *)title andDes:(NSString *)string{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 37)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel   = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 52, 37)];
    leftLabel.font       = Font(12.f);
    leftLabel.textColor  = COLOR_TEXT_GRAY;
    leftLabel.text       = title;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(leftLabel.right + 14, 0, 1/[UIScreen mainScreen].scale, 37)];
    line.backgroundColor = COLOR_VIEW_GRAY;
    
    UILabel *rightLabel  = [[UILabel alloc] initWithFrame:CGRectMake(line.right + 14, 0, view.width - line.right - 14*2, 37)];
    rightLabel.font      = Font(12.f);
    rightLabel.textColor = COLOR_TEXT_BLACK;
    rightLabel.text      = string;
    
    [view xk_addSubviews:@[leftLabel,rightLabel,line]];
    
    return view;
}

#pragma mark 子类实现，去除警告
- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (NSInteger)numberOfSectionsInTableView{
    return 0;
}
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath andTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
- (void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)handleData{
    
}
@end

