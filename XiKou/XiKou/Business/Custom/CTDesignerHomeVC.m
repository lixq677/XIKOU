//
//  CTDesignerHomeVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CTDesignerHomeVC.h"
#import "XKUIUnitls.h"
#import "CTBaseCell.h"
#import "CTDesignerWorksVC.h"
#import "XKDataService.h"
#import <SDWebImage.h>
#import "MJDIYFooter.h"
#import "CTCommentVC.h"
#import "XKShareTool.h"
#import "XKDesignerService.h"
#import "XKAccountManager.h"

static const int kPageCount =   20;

@interface CTDesignerHomeVC ()<UITableViewDelegate,UITableViewDataSource,CTWorkCellDelegate,XKDesignerServiceDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIButton *concernBtn;
@property (nonatomic,strong)UIImageView *headerIcon;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *welLabel;
@property (nonatomic,strong)UIView *infoView;
@property (nonatomic,strong)UILabel *fansCountLabel;
@property (nonatomic,strong)UILabel *fansLabel;
@property (nonatomic,strong)UILabel *thumbupCountLabel;
@property (nonatomic,strong)UILabel *thumbupLabel;
@property (nonatomic,strong)UILabel *jobsCountLabel;
@property (nonatomic,strong)UILabel *jobsLabel;

@property (nonatomic,strong)UIImageView *backImageView;

@property (nonatomic,strong)CTCommentVC *commentVC;


/**
 设计师id
 */
@property (nonatomic,strong,readonly)XKDesignerBriefData *briefData;

@property (nonatomic,strong,readonly)NSMutableArray<XKDesignerWorkData *> *works;

@property (nonatomic,strong,readonly)XKDesignerHomeData *homeData;

@property (nonatomic,assign)NSUInteger curPage;

@end

@implementation CTDesignerHomeVC
@synthesize tableView = _tableView;
@synthesize briefData = _briefData;
@synthesize works = _works;

- (instancetype)initWithDesignerBriefData:(XKDesignerBriefData *)briefData;{
    if (self = [super init]) {
        _briefData = briefData;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    self.extendedLayoutIncludesOpaqueBars = YES;
    /*添加子控制器*/
    [self addChildViewController:self.commentVC];
    [self.view addSubview:self.commentVC.view];
    [self.commentVC didMoveToParentViewController:self];
    
    [self setupUI];
    [self autoLayout];
    [self addObserver];
    
    /*初始化数据*/
    [self setupPageInfoWithBriefData:self.briefData];
    
    [self initHomePageFromCache];
    [self initHomePageFromServer];
    [self loadWorksFromCache];
    [self loadNewData];
    
//    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)dealloc{
    [self removeObserver];
}

- (void)addObserver{
    [[XKFDataService() designerService] addWeakDelegate:self];
};

- (void)removeObserver{
    [[XKFDataService() designerService] removeWeakDelegate:self];
}

- (void)setupUI{
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.backImageView];
    [self.headerView addSubview:self.headerIcon];
    [self.headerView addSubview:self.nameLabel];
    [self.headerView addSubview:self.welLabel];
    [self.headerView addSubview:self.concernBtn];
    
    [self.headerView addSubview:self.infoView];
    [self.infoView addSubview:self.fansCountLabel];
    [self.infoView addSubview:self.fansLabel];
    [self.infoView addSubview:self.thumbupCountLabel];
    [self.infoView addSubview:self.thumbupLabel];
    [self.infoView addSubview:self.jobsCountLabel];
    [self.infoView addSubview:self.jobsLabel];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_no_preference"]];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"设计师还没有发表作品哦！";
    label.textColor = HexRGB(0x999999, 1.0f);
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:label];
    imageView.centerX = kScreenWidth/2.0f;
    imageView.top = 380.0f;
    
    [label sizeToFit];
    label.centerX = imageView.centerX;
    label.top = imageView.bottom+10.0f;
    self.tableView.backgroundView = backgroundView;
    

    self.tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
    [self.tableView registerClass:[CTWorkCell class] forCellReuseIdentifier:@"CTWorkCell"];
    
    [self.view addSubview:self.inputView];
    
    [self.concernBtn addTarget:self action:@selector(concernAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_share_white"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGFloat height = 160.0f+[XKUIUnitls safeTop];
    if (self.tableView.contentOffset.y > height) {
        if (self.navigationBarStyle != XKNavigationBarStyleDefault) {
            self.navigationBarStyle = XKNavigationBarStyleDefault;
            self.title = self.nameLabel.text;
        }
    }else{
        if (self.navigationBarStyle != XKNavigationBarStyleTranslucent) {
            self.navigationBarStyle = XKNavigationBarStyleTranslucent;
            self.title = nil;
        }
    }
}

- (void)autoLayout{
    /*布局tableView*/
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.tableView.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
    
    /*布局headerView*/
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.headerView);
        make.height.mas_equalTo(190.0f+[XKUIUnitls safeTop]);
    }];
    
    [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.0f);
        make.top.equalTo(self.headerView).offset(61.0f+[XKUIUnitls safeTop]);
        make.width.height.mas_equalTo(60.0f);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerIcon.mas_right).offset(15.0f);
        make.top.equalTo(self.headerIcon).offset(11.0f);
        make.height.mas_equalTo(18.0f);
    }];
    
    [self.welLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(12.0f);
        make.left.equalTo(self.nameLabel);
        make.right.mas_equalTo(self.concernBtn.mas_left).offset(-20.0f);
    }];
    
    [self.concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(29.0f);
        make.centerY.equalTo(self.headerIcon);
        make.right.mas_equalTo(self.headerView.mas_right).offset(-20.0f);
    }];
    
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerIcon.mas_bottom).offset(34.0f);
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(-20.0f);
        make.height.mas_equalTo(65.0f);
    }];
   
    [self.fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16.0f);
        make.left.mas_equalTo(scalef(40.0f));
        make.height.mas_equalTo(15.0f);
        make.width.mas_equalTo(47.0f);
    }];
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fansCountLabel.mas_bottom).offset(5.0f);
        make.centerX.equalTo(self.fansCountLabel);
        make.height.mas_equalTo(12.0f);
        make.width.mas_equalTo(47.0f);
    }];
    
    [self.thumbupCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fansCountLabel);
        make.centerX.equalTo(self.infoView);
        make.height.mas_equalTo(15.0f);
        make.width.mas_equalTo(47.0f);
    }];
    [self.thumbupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.thumbupCountLabel.mas_bottom).offset(5.0f);
        make.centerX.equalTo(self.thumbupCountLabel);
        make.height.mas_equalTo(12.0f);
        make.width.mas_equalTo(47.0f);
    }];
    
    [self.jobsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fansCountLabel);
        make.right.mas_equalTo(self.infoView.mas_right).offset(-40.0f);
        make.height.mas_equalTo(15.0f);
        make.width.mas_equalTo(47.0f);
    }];
    [self.jobsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jobsCountLabel.mas_bottom).offset(5.0f);
        make.centerX.equalTo(self.jobsCountLabel);
        make.height.mas_equalTo(12.0f);
        make.width.mas_equalTo(47.0f);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(220.0f+[XKUIUnitls safeTop]);
    }];
    self.inputView.y = CGRectGetMaxY(self.view.bounds);
    [self.tableView layoutIfNeeded];
}


#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.works.count == 0) {
        tableView.backgroundView.hidden = NO;
    }else{
        tableView.backgroundView.hidden = YES;
    }
    if (self.works.count < kPageCount) {
        tableView.mj_footer.hidden = YES;
    }else{
        tableView.mj_footer.hidden = NO;
    }
    return self.works.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XKDesignerWorkData *data = [self.works objectAtIndex:indexPath.row];
    CTWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTWorkCell" forIndexPath:indexPath];;
    NSMutableArray<NSURL *> *imageUrls = [NSMutableArray arrayWithCapacity:data.imageList.count];
    [data.imageList enumerateObjectsUsingBlock:^(XKDesignerWorkImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *url = [NSURL URLWithString:obj.imageUrl];
        [imageUrls addObject:url];
    }];
    cell.imageUrls = imageUrls;
    cell.countLabel.text = [@(data.imageList.count) stringValue];
    cell.timeLabel.text = data.showTime;
    cell.worksLabel.text =  data.workName;
    cell.signatureLabel.text = data.desc;
    [cell.commentsBtn setTitle:[data.commentCnt stringValue] forState:UIControlStateNormal];
    [cell.thumbsupBtn setTitle:[data.fabulousCnt stringValue] forState:UIControlStateNormal];
    [cell.thumbsupBtn setSelected:data.isPraise.boolValue];
    [cell setDelegate:self];
    [cell sizeToFit];
    [cell reloadData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKDesignerWorkData *data = [self.works objectAtIndex:indexPath.row];
    CTDesignerWorksVC *controller = [[CTDesignerWorksVC alloc] initWithWorkData:data];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = 160.0f+[XKUIUnitls safeTop];
    if (scrollView.contentOffset.y > height) {
        if (self.navigationBarStyle != XKNavigationBarStyleDefault) {
            self.navigationBarStyle = XKNavigationBarStyleDefault;
            self.title = self.nameLabel.text;
        }
    }else if (scrollView.contentOffset.y + 80 > height){
        self.navigationController.navigationBar.translucent = YES;
        CGFloat alpha = (scrollView.contentOffset.y + 80.0f - height)/80.0f;
        alpha = alpha > 1.0f ? 1.0f :alpha;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HexRGB(0xffffff, alpha)] forBarMetrics:UIBarMetricsDefault];
    }else{
        if (self.navigationBarStyle != XKNavigationBarStyleTranslucent) {
            self.navigationBarStyle = XKNavigationBarStyleTranslucent;
            self.title = nil;
        }
    }
    if (scrollView.contentOffset.y<0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
}


#pragma mark designer cell delegate

- (void)workCell:(CTWorkCell *_Nonnull)workCell commentsAction:(nullable id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:workCell];
    XKDesignerWorkData *workData = [self.works objectAtIndex:indexPath.row];
    self.commentVC.workId = workData.id;
    self.commentVC.designerId = workData.designerId;
    [self.commentVC refreshData];
    [self.commentVC show];
}


- (void)workCell:(CTWorkCell *_Nonnull)workCell thumbupAction:(nullable id)sender{
    if ([[XKAccountManager defaultManager] isLogin] == NO) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:workCell];
    XKDesignerWorkData *workData = [self.works objectAtIndex:indexPath.row];
    XKDesignerFollowVoParams *params = [[XKDesignerFollowVoParams alloc] init];
    params.workId = workData.id;
    params.designerId = workData.designerId;
    params.userId = [[[XKAccountManager defaultManager] account] userId];
    params.praise = ![workData.isPraise boolValue];
   // [XKLoading show];
    [[XKFDataService() designerService] setThumbupDesignerWithParams:params completion:^(XKBaseResponse * _Nonnull response) {
       /// [XKLoading dismiss];
        if (response.isNotSuccess) {
            [response showError];
        }
    }];
}

#pragma mark 设计师 service 代理

/**
 评轮成功

 @param service <#service description#>
 @param voModel <#voModel description#>
 */
- (void)commentWithService:(XKDesignerService *)service comments:(XKDesignerCommentVoModel *)voModel{
    [self.works enumerateObjectsUsingBlock:^(XKDesignerWorkData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.id isEqualToString:voModel.workId]) {
            obj.commentCnt = @(obj.commentCnt.intValue + 1);
            CTWorkCell *workCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            if (workCell) {
                [workCell.commentsBtn setTitle:[obj.commentCnt stringValue] forState:UIControlStateNormal];
            }
            *stop = YES;
        }
    }];
}


/**
 点击关注或取消关注成功时返回

 @param service <#service description#>
 @param param <#param description#>
 */
- (void)concernDesignerWithService:(XKDesignerService *)service param:(XKDesignerFollowVoParams *)param{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    if ([userId isEqualToString:param.userId] == NO) return;
    self.homeData.isFollow = @(param.follow);
    NSInteger fanCnt = 0;
    if (param.follow) {
        [self setupUnconcern];
        fanCnt = self.homeData.fanCnt.integerValue + 1;
    }else{
        fanCnt = self.homeData.fanCnt.integerValue - 1;
        [self setupConcern];
    }
    self.homeData.fanCnt = @(fanCnt > 0 ? fanCnt:0);
    self.fansCountLabel.text = [self.homeData.fanCnt stringValue];
    [self.works enumerateObjectsUsingBlock:^(XKDesignerWorkData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isFollow = @(param.follow);
        if (param.follow) {
            obj.fanCnt = @(obj.fanCnt.integerValue + 1);
        }else{
            obj.fanCnt = @(obj.fanCnt.integerValue - 1);
        }
    }];
}


/**
 点赞或取消点赞成功

 @param service <#service description#>
 @param param <#param description#>
 */
- (void)thumbupDesignerWithService:(XKDesignerService *)service param:(XKDesignerFollowVoParams *)param{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    if ([userId isEqualToString:param.userId] == NO) return;
    
    __block NSInteger index = NSNotFound;
    [self.works enumerateObjectsUsingBlock:^(XKDesignerWorkData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.id isEqualToString:param.workId]){
            index = idx;
            *stop = YES;
        }
    }];
    if (index == NSNotFound)return;
    
    XKDesignerWorkData *workData = [self.works objectAtIndex:index];
    
    workData.isPraise = @(param.praise);
    CTWorkCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (param.praise) {
        workData.fabulousCnt =  @(workData.fabulousCnt.integerValue + 1);
        self.homeData.fabulousCnt = @(self.homeData.fabulousCnt.integerValue + 1);
        if (cell) cell.thumbsupBtn.selected = YES;
    }else{
        workData.fabulousCnt =  @(workData.fabulousCnt.integerValue - 1);
        self.homeData.fabulousCnt = @(self.homeData.fabulousCnt.integerValue -1);
        if(cell)cell.thumbsupBtn.selected = NO;
    }
    [cell.thumbsupBtn setTitle:[workData.fabulousCnt stringValue] forState:UIControlStateNormal];
    [cell.thumbsupBtn setSelected:workData.isPraise.boolValue];
    self.thumbupCountLabel.text = self.homeData.fabulousCnt.stringValue;
    
}


#pragma mark action
- (void)concernAction:(id)sender{
    [self requestConcernFromServer];
}

#pragma mark ---------------------获取分享的数据
- (void)shareAction:(id)sender{

    XKShareRequestModel *model = [XKShareRequestModel new];
    model.designerId = self.briefData.id;
    model.shareUserId = [XKAccountManager defaultManager].account.userId ? [XKAccountManager defaultManager].account.userId : @"";
    model.popularizePosition = SPDesigner;
    
    [[XKShareTool defaultTool]shareWithModel:model andTitle:@"分享到好友" andContent:nil andNeedPhoto:NO andUIType:ShareUIBottom];
    
}



#pragma mark init data

/**
 从缓存中获取设计师个人信息
 */
- (void)initHomePageFromCache{
    XKDesignerHomeData *data = [[XKFDataService() designerService] queryDesignerHomePageInfoFromCacheWithDesignerId:self.briefData.id];
    _homeData = data;
    [self setupPageInfoWithHomeData:data];
}


/**
 从主面中获取设计师个人信息
 */
- (void)initHomePageFromServer{
    if ([NSString isNull:self.briefData.id])return;
     NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() designerService] queryDesignerHomePageInfoWithDesignerId:self.briefData.id userId:userId completion:^(XKDesignerHomeResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if(response.isSuccess){
            XKDesignerHomeData *data = [response data];
            self->_homeData = data;
            [self setupPageInfoWithHomeData:data];
        }else{
            [response showError];
        }
    }];
}


//下拉刷新数据
- (void)loadNewData{
    [self loadDataIsUpdate:YES];
}

//上拉加载更多数据
- (void)loadMoreData{
    [self loadDataIsUpdate:NO];
}

//请求网络数据
- (void)loadDataIsUpdate:(BOOL)update {
    NSString *userId = [[XKAccountManager defaultManager] userId];
    XKDesignerWorksParams *params = [[XKDesignerWorksParams alloc] init];
    params.userId = userId;
    params.designerId = self.briefData.id;
    params.limit= @(kPageCount);
    if (update) {
        params.page = @1;
    }else{
        params.page = @(self.curPage+1);
    }
    @weakify(self);
    [[XKFDataService() designerService] queryDesignerWorksWithParams:params completion:^(XKDesignerWorkResponse * _Nonnull response) {
        @strongify(self);
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if (response.isSuccess) {
            if ([response isSuccess]) {
                //刷新数据时，需要清理旧的数据
                if (update) {
                    [self.works removeAllObjects];
                }
                self.curPage = params.page.intValue;
                [self.works addObjectsFromArray:response.data];
                [self.tableView reloadData];
                if (response.data.count < kPageCount) {
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
        }
    }];
}


- (void)loadWorksFromCache{
    NSString *userId = [[XKAccountManager defaultManager] userId];
    XKDesignerWorksParams *params = [[XKDesignerWorksParams alloc] init];
    params.userId = userId;
    params.designerId = self.briefData.id;
    params.limit= @(kPageCount);
    params.page = @1;
    
    NSArray<XKDesignerWorkData *> *works = [[XKFDataService() designerService] queryWorksFromCacheWithParams:params];
    if (works.count) {
        [self.works removeAllObjects];
        [self.works addObjectsFromArray:works];
    }
}



/**
设置关注设计师或取消关注
 */
- (void)requestConcernFromServer{
    if ([[XKAccountManager defaultManager] isLogin] == NO) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    XKDesignerFollowVoParams *params = [[XKDesignerFollowVoParams alloc] init];
    params.designerId = self.briefData.id;
    params.userId = [[[XKAccountManager defaultManager] account] userId];
    params.follow = ![self.homeData.isFollow boolValue];
    // params.createTime = @"1990-02-14";
    self.concernBtn.enabled = NO;
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() designerService] setConcernDesignerWithParams:params completion:^(XKBaseResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        self.concernBtn.enabled = YES;
        if (response.isNotSuccess) {
            [response showError];
        }
    }];
}


/**
 设置设计师的个人信息
 
 @param data <#data description#>
 */
- (void)setupPageInfoWithHomeData:(XKDesignerHomeData *)data{
    if (data == nil) return;
    self.fansCountLabel.text = data.fanCnt.stringValue?:@"0";
    self.thumbupCountLabel.text = data.fabulousCnt.stringValue?:@"0";
    self.jobsCountLabel.text = data.workCnt.stringValue?:@"0";
    self.nameLabel.text = data.pageName;
    self.welLabel.text = data.desc;
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:data.headUrl] placeholderImage:[UIImage imageNamed:@"touxiang"] options:SDWebImageAvoidDecodeImage];
    if ([data.isFollow boolValue]) {//已关注
        [self setupUnconcern];
    }else{
        [self setupConcern];
    }
}

- (void)setupPageInfoWithBriefData:(XKDesignerBriefData *)data{
    self.thumbupCountLabel.text = data.fabulousCount.stringValue?:@"0";
    self.nameLabel.text = data.pageName;
    self.fansCountLabel.text = @"0";
    self.jobsCountLabel.text = @"0";
    [self setupConcern];
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:data.headUrl] placeholderImage:[UIImage imageNamed:@"touxiang"] options:SDWebImageAvoidDecodeImage];
}


#pragma mark getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 250.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
    }
    return _tableView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = HexRGB(0xffffff, 1.0f);
    }
    return _headerView;
}


- (UIImageView *)headerIcon{
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxiang"]];
        _headerIcon.layer.cornerRadius = 30.0f;
        _headerIcon.clipsToBounds = YES;
    }
    return _headerIcon;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HexRGB(0xffffff, 1.0f);
        _nameLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    return _nameLabel;
}

- (UILabel *)welLabel{
    if (!_welLabel) {
        _welLabel = [[UILabel alloc] init];
        _welLabel.textColor = HexRGB(0x999999, 1.0f);
        _welLabel.font = [UIFont systemFontOfSize:12.0f];
        _welLabel.text = @"喜扣商城欢迎您";
        _welLabel.numberOfLines = 0;
    }
    return _welLabel;
}


- (UILabel *)fansCountLabel{
    if (!_fansCountLabel) {
        _fansCountLabel = [[UILabel alloc] init];
        _fansCountLabel.textColor = HexRGB(0x444444, 1.0f);
        _fansCountLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _fansCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _fansCountLabel;
}

- (UILabel *)fansLabel{
    if (!_fansLabel) {
        _fansLabel = [[UILabel alloc] init];
        _fansLabel.textColor = HexRGB(0x999999, 1.0f);
        _fansLabel.font = [UIFont systemFontOfSize:12.0f];
        _fansLabel.textAlignment = NSTextAlignmentCenter;
        _fansLabel.text = @"粉丝";
    }
    return _fansLabel;
}

- (UILabel *)thumbupCountLabel{
    if (!_thumbupCountLabel) {
        _thumbupCountLabel = [[UILabel alloc] init];
        _thumbupCountLabel.textColor = HexRGB(0x444444, 1.0f);
        _thumbupCountLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _thumbupCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _thumbupCountLabel;
}

- (UILabel *)thumbupLabel{
    if (!_thumbupLabel) {
        _thumbupLabel = [[UILabel alloc] init];
        _thumbupLabel.textColor = HexRGB(0x999999, 1.0f);
        _thumbupLabel.font = [UIFont systemFontOfSize:12.0f];
        _thumbupLabel.textAlignment = NSTextAlignmentCenter;
        _thumbupLabel.text = @"获赞";
    }
    return _thumbupLabel;
}


- (UILabel *)jobsCountLabel{
    if (!_jobsCountLabel) {
        _jobsCountLabel = [[UILabel alloc] init];
        _jobsCountLabel.textColor = HexRGB(0x444444, 1.0f);
        _jobsCountLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _jobsCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _jobsCountLabel;
}

- (UILabel *)jobsLabel{
    if (!_jobsLabel) {
        _jobsLabel = [[UILabel alloc] init];
        _jobsLabel.textColor = HexRGB(0x999999, 1.0f);
        _jobsLabel.font = [UIFont systemFontOfSize:12.0f];
        _jobsLabel.textAlignment = NSTextAlignmentCenter;
        _jobsLabel.text = @"作品";
    }
    return _jobsLabel;
}

- (UIView *)infoView{
    if (!_infoView) {
        _infoView = [[UIView alloc] init];
        _infoView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _infoView.layer.cornerRadius = 5.0f;
        [_infoView addShadowWithColor:HexRGB(0x0, 0.7)];
    }
    return _infoView;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BJ"]];
    }
    return _backImageView;
}

- (CTCommentVC *)commentVC{
    if (!_commentVC) {
        _commentVC = [[CTCommentVC alloc] init];
    }
    return _commentVC;
}


- (UIButton *)concernBtn{
    if (!_concernBtn) {
        _concernBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_concernBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [[_concernBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
        _concernBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _concernBtn.layer.cornerRadius = 14.5f;
        _concernBtn.layer.borderWidth = 1.0f;
        _concernBtn.clipsToBounds = YES;
    }
    return _concernBtn;
}

- (void)setupConcern{
    [self.concernBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.concernBtn setBackgroundColor:COLOR_TEXT_BROWN];
    [self.concernBtn setImage:[UIImage imageNamed:@"custom_add_at"] forState:UIControlStateNormal];
    self.concernBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    self.concernBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
}

- (void)setupUnconcern{
    [self.concernBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    [self.concernBtn setBackgroundColor:[UIColor clearColor]];
    [self.concernBtn setImage:nil forState:UIControlStateNormal];
    self.concernBtn.layer.borderColor = [HexRGB(0xffffff, 1.0f) CGColor];
    self.concernBtn.titleEdgeInsets = UIEdgeInsetsZero;
}

- (NSMutableArray<XKDesignerWorkData *> *)works{
    if (!_works) {
        _works = [NSMutableArray array];
    }
    return _works;
}

@end
