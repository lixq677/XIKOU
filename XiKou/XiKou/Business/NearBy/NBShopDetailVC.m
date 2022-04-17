//
//  NBShopDetailVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NBShopDetailVC.h"
#import "NBCashVC.h"
#import "MIAddressSelectVC.h"

#import "NBShopDetailDesCell.h"
#import "NBShopDetailTagCell.h"
#import "NBShopDetailSectionHeaderView.h"
#import "NBShopDetailTableHeaderView.h"
#import "UIButton+Position.h"
#import "XKSingleImageCell.h"
#import "XKShareTool.h"
#import "XKAccountManager.h"
#import "XKShopService.h"

#import <WebKit/WebKit.h>
#import "YBImageBrowser.h"
#import "XKOtherService.h"

typedef NS_ENUM(int,NBShopSectionCategory){
    NBShopSectionCategoryFeature        =   0,
    NBShopSectionCategoryBrief          =   1,
    NBShopSectionCategoryShopShow       =   2,
};

@interface NBShopDetailSection : NSObject

@property (nonatomic,assign,readonly) NBShopSectionCategory category;

@property (nonatomic,assign,readonly) NSUInteger rows;

- (instancetype)initWithSectionCategory:(NBShopSectionCategory)category rows:(NSUInteger)rows;

@end

@implementation NBShopDetailSection

- (instancetype)initWithSectionCategory:(NBShopSectionCategory)category rows:(NSUInteger)rows{
    if (self = [super init]) {
        _category = category;
        _rows = rows;
    }
    return self;
}

@end


@interface NBShopDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NBShopDetailTableHeaderView *tableHeaderView;
@property (nonatomic, strong) UIView *buttonsView;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic,strong,readonly) XKShopBriefData *briefData;
@property (nonatomic,strong) NSMutableArray *detailImages;

@property (nonnull,strong,readonly) NSMutableArray<NBShopDetailSection *> *sections;

@end

@implementation NBShopDetailVC
@synthesize sections = _sections;
@synthesize tableHeaderView = _tableHeaderView;

- (instancetype)initWithShopeBriefData:(XKShopBriefData *)briefData{
    if (self = [super init]) {
        _briefData = briefData;
        _detailImages = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    _isExpand = NO;
    [self setUI];
    [self layout];
    // Do any additional setup after loading the view.
    [self setData];
    [self initDataFromServer];
   
}

- (void)setUI{
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self setNavigationBarStyle:XKNavigationBarStyleTranslucent];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:COLOR_TEXT_BLACK] forBarMetrics:UIBarMetricsDefault];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(kTopHeight, 0)];
    [path addLineToPoint:CGPointMake(kScreenWidth, 0)];
    [path addLineToPoint:CGPointMake(kScreenWidth, 87+kTopHeight)];
    [path addLineToPoint:CGPointMake(0, 87+kTopHeight)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path fill];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = COLOR_TEXT_BLACK.CGColor;
    [self.view.layer addSublayer:layer];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.buttonsView];
    self.tableView.tableHeaderView = self.tableHeaderView;

    [_tableView registerClass:[NBShopDetailDesCell class] forCellReuseIdentifier:@"NBShopDetailDesCell"];
    [_tableView registerClass:[NBShopDetailTagCell class] forCellReuseIdentifier:@"NBShopDetailTagCell"];
    [_tableView registerClass:[XKSingleImageCell class] forCellReuseIdentifier:@"XKSingleImageCell"];
    [_tableView registerClass:[NBShopDetailSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"NBShopDetailHeaderView"];
    
    [self addNavigationItemWithImageName:@"home_share_white" isLeft:NO target:self action:@selector(shareClick)];
    
}

- (void)layout{
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(70 + [XKUIUnitls safeBottom]);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.buttonsView.mas_top);
    }];
    [self.tableView layoutIfNeeded];
}


- (void)setData{
    [self.tableHeaderView.coverView setImage:[UIImage imageNamed:@"touxiang"]];
    [self.briefData.imageList enumerateObjectsUsingBlock:^(XKShopImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == XKShopImageTypeAvatar) {
            [self.tableHeaderView.coverView sd_setImageWithURL:[NSURL URLWithString:obj.imageUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
            *stop = YES;
        }
    }];
    
    self.tableHeaderView.titleLabel.text    = self.briefData.shopName;
    self.tableHeaderView.addressLabel.text  = [NSString stringWithFormat:@" %@ ",GetAreaAddress(nil, nil, self.briefData.area)];
    self.tableHeaderView.classLabel.text    =  self.briefData.industryName;
    
//    if (self.briefData.distance.floatValue > 1000.0f) {
    self.tableHeaderView.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",self.briefData.distance.floatValue];
//    }else{
//         self.tableHeaderView.distanceLabel.text = [NSString stringWithFormat:@"%dm",(int)self.briefData.distance.floatValue];
//    }
    self.tableHeaderView.timeLabel.value    = [NSString stringWithFormat:@"%@-%@",self.briefData.startTime,self.briefData.endTime];
    XKAddressVoModel *voModel = [[XKAddressVoModel alloc] init];
    voModel.provinceId = self.briefData.province;
    voModel.cityId = self.briefData.city;
    voModel.districtId = self.briefData.area;
    
    [self.tableHeaderView.detailAddressLabel setTitle:self.briefData.address forState:UIControlStateNormal];
    [self.tableHeaderView.detailAddressLabel XK_imagePositionStyle:XKImagePositionStyleLeft spacing:5];
    self.tableHeaderView.fansNumLabel.text  =  [NSString stringWithFormat:@"%@粉丝",self.briefData.fanCnt];
    self.tableHeaderView.viewedNumLabel.text = [NSString stringWithFormat:@"%@人气",self.briefData.popCnt];

}

- (void)setSections{
    [self.sections removeAllObjects];
    if (self.briefData.serviceList.count > 0) {
        NBShopDetailSection *section = [[NBShopDetailSection alloc] initWithSectionCategory:NBShopSectionCategoryFeature rows:1];
        [self.sections addObject:section];
    }
    
    NBShopDetailSection *section = [[NBShopDetailSection alloc] initWithSectionCategory:NBShopSectionCategoryBrief rows:1];
    [self.sections addObject:section];
    
    [self.briefData.imageList enumerateObjectsUsingBlock:^(XKShopImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == XKShopImageTypeShow && ![NSString isNull:obj.imageUrl]) {
            [self.detailImages addObject:obj];
        }
    }];
    if (self.detailImages.count > 0) {
        NBShopDetailSection *section = [[NBShopDetailSection alloc] initWithSectionCategory:NBShopSectionCategoryShopShow rows:self.detailImages.count];
        [self.sections addObject:section];
    }
}

- (void)reloadImageSize{
    
    dispatch_queue_t queueT = dispatch_queue_create("group.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t grpupT = dispatch_group_create();
    
    for (int i = 0; i< self.detailImages.count; i++) {
        
        XKShopImageModel * model = self.detailImages[i];
        if (model.type != XKShopImageTypeShow) continue;
        
        dispatch_group_async(grpupT, queueT, ^{
            dispatch_group_enter(grpupT);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{

                UIImage *image = [UIImage imageFromSdcache:model.imageUrl];
                if (image) {
                    model.ImageWidth  = image.size.width;
                    model.ImageHeight = image.size.height;
                    dispatch_group_leave(grpupT);
                }else{
                    [[XKFDataService() otherService]queryImageSizeWithUrl:model.imageUrl completion:^(XKBaseResponse * _Nonnull response) {
                        model.ImageWidth = [response.responseObject[@"ImageWidth"][@"value"] floatValue];
                        model.ImageHeight = [response.responseObject[@"ImageHeight"][@"value"] floatValue];
                        dispatch_group_leave(grpupT);
                    }];
                }
            });
        });
        dispatch_group_notify(grpupT, queueT, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSInteger index = self.sections.count - 1;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    }
}

#pragma mark ---------------------获取分享的数据
- (void)shareClick{

    XKShareRequestModel *model = [XKShareRequestModel new];
    model.shopId = self.briefData.id;
    model.shareUserId = [XKAccountManager defaultManager].account.userId ? [XKAccountManager defaultManager].account.userId : @"";
    model.popularizePosition = SPShop;
    
    [[XKShareTool defaultTool]shareWithModel:model andTitle:@"分享到好友" andContent:nil andNeedPhoto:NO andUIType:ShareUIBottom];
}
#pragma mark action
- (void)payAction{
    if (![[XKAccountManager defaultManager] isLogin]) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    NBCashVC *cashVC = [[NBCashVC alloc] initWithBriefData:self.briefData];
    [self.navigationController pushViewController:cashVC animated:YES];
}

- (void)callAction{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.briefData.mobile];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NBShopDetailSection *detailSection = [self.sections objectAtIndex:section];
    return detailSection.rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBShopDetailSection *section = [self.sections objectAtIndex:indexPath.section];
    if (section.category == NBShopSectionCategoryFeature) {
        NBShopDetailTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NBShopDetailTagCell" forIndexPath:indexPath];
        cell.serviceModels = self.briefData.serviceList;
        return cell;
    }else if (section.category == NBShopSectionCategoryBrief) {
        NBShopDetailDesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NBShopDetailDesCell" forIndexPath:indexPath];
        NSString *desc = nil;
        if ([NSString isNull:self.briefData.desc]) {
            desc = @"商家暂无介绍";
        }else{
            desc = self.briefData.desc;
        }
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 5.0f;
        cell.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:desc attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:HexRGB(0x444444, 1.0f)}];
        @weakify(self);
        cell.isExpand = self.isExpand;
        cell.expandBlock = ^(BOOL isExpand) {
            @strongify(self);
            self.isExpand = !isExpand;
            [UIView performWithoutAnimation:^{
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        };
        return cell;
    }else {
        XKSingleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKSingleImageCell" forIndexPath:indexPath];
        XKShopImageModel *model = [self.detailImages objectAtIndex:indexPath.row];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_background"]];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NBShopDetailSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"NBShopDetailHeaderView"];
    NBShopDetailSection *detailSection = [self.sections objectAtIndex:section];
    if (detailSection.category == NBShopSectionCategoryBrief) {
        header.titleLabel.text = @"商家介绍";
        header.button.hidden = NO;
        header.concern = [self.briefData.isFollow boolValue];
        @weakify(self);
        header.block = ^{
            @strongify(self);
            [self requestConcernFromServer];
        };
    }else if(detailSection.category == NBShopSectionCategoryFeature){
        header.titleLabel.text = @"特色服务";
        header.button.hidden   = YES;
    }else if (detailSection.category == NBShopSectionCategoryShopShow){
        header.titleLabel.text = @"店铺展示";
        header.button.hidden = YES;
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.sections.count - 1) {
        
        XKShopImageModel *imgModel = self.detailImages[indexPath.row];
        
        CGFloat height = (imgModel.ImageHeight/imgModel.ImageWidth * (kScreenWidth - 30));
        return height > 0 ? height : kScreenWidth - 30;
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSMutableArray *datas = [NSMutableArray array];
    [self.detailImages enumerateObjectsUsingBlock:^(XKShopImageModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:obj.imageUrl];
        [datas addObject:data];
    }];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = indexPath.row;
    [browser show];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY>90.5) {
        self.navigationItem.title = self.briefData.shopName;
        [self setNavigationBarStyle:XKNavigationBarStyleDefault];
    }else{
        self.navigationItem.title = @"";
        [self setNavigationBarStyle:XKNavigationBarStyleTranslucent];
    }
}


- (void)initDataFromServer{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    @weakify(self);
    [[XKFDataService() shopService] queryShopDetailWithShopId:self.briefData.id userId:userId completion:^(XKShopDetailResponse * _Nonnull response) {
        @strongify(self);
        if (response.isSuccess) {
            [self.briefData yy_modelSetWithJSON:[response.data yy_modelToJSONObject]];
            [self setData];
            [self setSections];
            [self reloadImageSize];
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}

/**
 设置关注设计师或取消关注
 */
- (void)requestConcernFromServer{
    if ([[XKAccountManager defaultManager] isLogin] == NO) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    XKShopFollowVoParams *params = [[XKShopFollowVoParams alloc] init];
    params.shopId = self.briefData.id;
    params.userId = [[[XKAccountManager defaultManager] account] userId];
    params.follow = ![self.briefData.isFollow boolValue];
    
    __block NSInteger section = 0;
    [self.sections enumerateObjectsUsingBlock:^(NBShopDetailSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.category == NBShopSectionCategoryBrief) {
            section = idx;
            *stop = YES;
        }
    }];
    NBShopDetailSectionHeaderView *header = (NBShopDetailSectionHeaderView *)[self.tableView headerViewForSection:section];
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() shopService] setConcernShopWithParams:params completion:^(XKBaseResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        //header.button.enabled = YES;
        if (response.isSuccess) {
            [header setConcern:params.follow];
            self.briefData.isFollow = @(params.follow);
        }else{
            [response showError];
        }
    }];
}


#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 52;
        _tableView.sectionFooterHeight = 10;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;

    }
    return _tableView;
}


- (UIView *)buttonsView{
    if (!_buttonsView) {
        _buttonsView = [UIView new];
        _buttonsView.backgroundColor = [UIColor whiteColor];
        _buttonsView.layer.shadowColor = COLOR_VIEW_SHADOW;
        _buttonsView.layer.shadowOffset = CGSizeMake(-0.5,-2);
        _buttonsView.layer.shadowOpacity = 1;
        _buttonsView.layer.shadowRadius = 2.5;
        
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [callBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [callBtn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
        [callBtn setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
        [callBtn.titleLabel setFont:Font(10.f)];
        [callBtn addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
        [callBtn XK_imagePositionStyle:XKImagePositionStyleTop spacing:6];
        
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.layer.masksToBounds = YES;
        _payBtn.layer.cornerRadius  = 2.f;
        [_payBtn setBackgroundColor:COLOR_TEXT_BLACK];
        
        NSString *title = [NSString stringWithFormat:@"%@%%的优惠买单",self.briefData.discountRate];
        [_payBtn setTitle:title forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn.titleLabel setFont:FontMedium(15.f)];
        [_payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        [_buttonsView xk_addSubviews:@[callBtn,_payBtn]];
        [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(50);
            make.top.equalTo(self.buttonsView);
            make.height.mas_equalTo(65.0f);
        }];
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(callBtn.mas_right).offset(20);
            make.right.mas_equalTo(-21);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(40.0f);
        }];
    }
    return _buttonsView;
}

- (NBShopDetailTableHeaderView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[NBShopDetailTableHeaderView alloc] init];
    }
    return _tableHeaderView;
}

- (NSMutableArray<NBShopDetailSection *> *)sections{
    if(!_sections){
        _sections = [NSMutableArray arrayWithCapacity:5];
    }
    return _sections;
}

@end
