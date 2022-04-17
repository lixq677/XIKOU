//
//  NBIndustrysVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NBIndustrysVC.h"
#import "XKBannerView.h"
#import "NBHeaderFooterView.h"
#import "NBCells.h"
#import "NBShopDetailVC.h"
#import "XKDataService.h"
#import "XKShopService.h"
#import "XKAddressData.h"
#import "MJDIYFooter.h"

static const int kPageCount =   20;

@interface NBIndustrysVC () <UITableViewDelegate,UITableViewDataSource,NBHeaderFooterViewDelegate>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong,readonly) NSMutableArray<XKShopBriefData *> *shopes;

@property (nonatomic,assign)NSUInteger curPage;

@property (nonatomic,assign)XKShopPop shopPop;

@property (nonatomic,assign)XKShopRate shopRate;

@end

@implementation NBIndustrysVC
@synthesize tableView = _tableView;
@synthesize shopes = _shopes;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self setupTabelView];
    //[self layout];
    [self loadDataFromCache];
    if (self.loadDataFromServer && self.addressVoModel) {
        [self loadNewData];
    }
}


- (void)setupTabelView{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30.0f, scalef(135)+53.0f+15.0f)];
    XKBannerView *bannerView = [[XKBannerView alloc] initWithFrame:CGRectMake(0, 15.0f, CGRectGetWidth(headerView.frame), scalef(135.0f))];
    bannerView.layer.cornerRadius = 5.0f;
    bannerView.clipsToBounds = YES;
    [headerView addSubview:bannerView];
    
    NBHeaderFooterView *hfView = [[NBHeaderFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bannerView.frame), CGRectGetWidth(bannerView.frame), 53.0f)];
    hfView.delegate = self;
    [headerView addSubview:hfView];
    
    bannerView.dataSource = self.industryData.bannerImageList;
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[NBShopBriefStyle1Cell class] forCellReuseIdentifier:@"NBShopBriefStyle1Cell"];
    [self.tableView registerClass:[NBShopBriefStyle2Cell class] forCellReuseIdentifier:@"NBShopBriefStyle2Cell"];
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.bottom.mas_equalTo(0);
    }];
    
}

//- (void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    self.tableView.frame = CGRectMake(15.0f, 0, kScreenWidth-30.0f, self.view.height);
//}

#pragma mark data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.shopes.count < kPageCount) {
        tableView.mj_footer.hidden = YES;
    }else{
        tableView.mj_footer.hidden = NO;
    }
    return self.shopes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBShopBriefCell *cell = nil;
    XKShopBriefData *briefData = [self.shopes objectAtIndex:indexPath.section];
    if (briefData.style == XKShopCellStyleBig) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NBShopBriefStyle1Cell" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"NBShopBriefStyle2Cell" forIndexPath:indexPath];
    }
    cell.textLabel.text = briefData.shopName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"优惠劵直减%@%%",briefData.discountRate];
//    if (briefData.distance.floatValue > 1000.0f) {
        cell.distanceLabel.text = [NSString stringWithFormat:@"小于%.2fkm",briefData.distance.floatValue];
//    }else{
//        cell.distanceLabel.text = [NSString stringWithFormat:@"%dm",(int)briefData.distance.floatValue];
//    }
    NSMutableArray<NSString *> *imageUrls = [NSMutableArray arrayWithCapacity:briefData.imageList.count];
    [briefData.imageList enumerateObjectsUsingBlock:^(XKShopImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == XKShopImageTypeShow) {
            [imageUrls addObject:obj.imageUrl?:@""];
        }
    }];
    [imageUrls addObject:@""];
    [imageUrls addObject:@""];
    [imageUrls addObject:@""];
    NSString *imageUrl1 = [imageUrls objectAtIndex:0];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl1] placeholderImage:[UIImage imageNamed:@"placeholder_background"]];
    
    NSString *imageUrl2 = [imageUrls objectAtIndex:1];
    [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:imageUrl2] placeholderImage:[UIImage imageNamed:@"placeholder_background"]];
    
    NSString *imageUrl3 = [imageUrls objectAtIndex:2];
    [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:imageUrl3] placeholderImage:[UIImage imageNamed:@"placeholder_background"]];
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 10.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKShopBriefData *briefData = [self.shopes objectAtIndex:indexPath.section];
    NBShopDetailVC *controller = [[NBShopDetailVC alloc] initWithShopeBriefData:briefData];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)headerFooterView:(NBHeaderFooterView *)headerFooterView shopRate:(XKShopRate)rate{
    self.shopRate = rate;
    self.shopPop = XKShopPopNone;
    [self loadDataForUpdate:YES loadingShow:YES];
}

- (void)headerFooterView:(NBHeaderFooterView *)headerFooterView shopPop:(XKShopPop)pop{
    self.shopPop = pop;
    self.shopRate = XKShopRateNone;
    [self loadDataForUpdate:YES loadingShow:YES];
}


- (void)loadNewData{
    [self loadDataForUpdate:YES loadingShow:NO];
}


- (void)loadMoreData{
    [self loadDataForUpdate:NO loadingShow:NO];
}


//请求网络数据
- (void)loadDataForUpdate:(BOOL)update loadingShow:(BOOL)loadingShow{
    NSUInteger page = 1;
    if (!update) {
        page = self.curPage + 1;
    }
    XKShopBriefParams *params = [[XKShopBriefParams alloc] init];
    params.industry1 = self.industryData.industry1;
    params.industryName = self.industryData.industryName;
    params.rate = self.shopRate;
    params.pop = self.shopPop;
    if (self.addressVoModel.location) {
        params.latitude = @(self.addressVoModel.location.coordinate.latitude);
        params.longitude = @(self.addressVoModel.location.coordinate.longitude);
    }else{
        params.latitude = @(0);
        params.longitude = @(0);
    }
    params.page = @(page);
    params.limit = @(kPageCount);
    @weakify(self);
    if (loadingShow) {
        [XKLoading show];
    }
    [[XKFDataService() shopService] queryShopBriefWithShopBriefParams:params completion:^(XKShopBriefResponse * _Nonnull response) {
        @strongify(self);
        if (loadingShow) {
            [XKLoading dismiss];
        }
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([response isSuccess]) {
            NSArray<XKShopBriefData *> *results = response.data;
            //刷新数据时，需要清理旧的数据
            if (update) {
                [self.shopes removeAllObjects];
            }
            self.curPage = page;
            if (results.count) {
                [self.shopes addObjectsFromArray:results];
            }
            [self.tableView reloadData];
            if (results.count < kPageCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            if(!update){
                [self.tableView.mj_footer endRefreshing];
            }
            [response showError];
        }
    }];
}

- (void)loadDataFromCache{
    XKShopBriefParams *params = [[XKShopBriefParams alloc] init];
    params.industry1 = self.industryData.industry1;
    params.industryName = self.industryData.industryName;
    params.rate = self.shopRate;
    params.pop = self.shopPop;
    if (self.addressVoModel.location) {
        params.latitude = @(self.addressVoModel.location.coordinate.latitude);
        params.longitude = @(self.addressVoModel.location.coordinate.longitude);
    }
    params.page = @(1);
    params.limit = @(kPageCount);
    NSArray<XKShopBriefData *> *array = [[XKFDataService() shopService] queryShopBriefFromCacheWithShopBriefParams:params];
    [self.shopes removeAllObjects];
    if(array.count){
        [self.shopes addObjectsFromArray:array];
    }
}

- (void)reloadData{
    if (self.loadDataFromServer) {
         [self loadNewData];
    }
}

#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
    }
    return _tableView;
}


- (NSMutableArray<XKShopBriefData *> *)shopes{
    if (!_shopes) {
        _shopes = [NSMutableArray array];
    }
    return _shopes;
}


@end
