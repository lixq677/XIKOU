//
//  CTHallVC.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CTHallVC.h"
#import "XKUIUnitls.h"
#import "CTBaseCell.h"
#import "CTDesignerWorksVC.h"
#import "CTSearchResultVC.h"
#import "CTCommentVC.h"
#import "XKDataService.h"
#import <SDWebImage.h>
#import "MJDIYFooter.h"
#import "CTCommentVC.h"
#import "CTDesignerHomeVC.h"
#import "XKUserService.h"
#import "XKDesignerService.h"
#import "XKCustomAlertView.h"

static const int kPageCount =   20;

@interface CTHallVC ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,XKDesignerServiceDelegate,XKUserServiceDelegate,CTDesignerHallCellDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UISearchController *searchController;

@property (nonatomic, strong)UIButton *resetBtn;
@property (nonatomic, strong)UIButton *finishBtn;

@property (nonatomic,strong)CTCommentVC *commentVC;

@property (nonatomic,strong,readonly)NSMutableArray<XKDesignerWorkData *> *works;

@property (nonatomic,assign)NSUInteger curPage;

@end

@implementation CTHallVC
@synthesize tableView = _tableView;
@synthesize works = _works;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"定制馆";
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shaixuan"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    /*添加子控制器*/
    [self addChildViewController:self.commentVC];
    [self.view addSubview:self.commentVC.view];
    [self.commentVC didMoveToParentViewController:self];
    
    [self setupUI];
    [self autoLayout];
    [self addObserver];
    
    [self loadWorksFromCache];
    [self loadNewData];
    
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

- (void)dealloc{
    [self removeObserver];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.searchController.searchBar.width-=30.0f;
}

- (void)addObserver{
    [[XKFDataService() designerService] addWeakDelegate:self];
    [[XKFDataService() userService] addWeakDelegate:self];
};

- (void)removeObserver{
    [[XKFDataService() designerService] removeWeakDelegate:self];
    [[XKFDataService() userService] removeWeakDelegate:self];
}

- (void)setupUI{
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
    [self.tableView registerClass:[CTDesignerHallCell class] forCellReuseIdentifier:@"CTDesignerHallCell"];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_no_preference"]];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无相关作品内容?";
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
    self.tableView.tableFooterView = [UIView new];
    

    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    CTSearchResultVC *controller = [[CTSearchResultVC alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:controller];
    self.searchController.searchResultsUpdater = controller;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.searchBar.placeholder = @"设计师名称，作品名模糊查询";
    self.searchController.searchBar.tintColor = HexRGB(0x444444, 1.0f);
    self.searchController.searchBar.barTintColor = HexRGB(0xffffff, 1.0f);
    self.searchController.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    self.searchController.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    [self.searchController.searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchController.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"SS_bar"] forState:UIControlStateNormal];
    self.searchController.searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(8, 2);
    self.searchController.searchBar.searchTextPositionAdjustment = UIOffsetMake(8, 2);
    self.searchController.delegate = self;
    UITextField *textField = nil;
    for (UIView *view in self.searchController.searchBar.subviews[0].subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            textField = (UITextField *)view;
            break;
        }
    }
    textField.textColor = HexRGB(0x444444, 1.0f);
    textField.font = [UIFont systemFontOfSize:12.0f];
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.frame = CGRectMake(0, 0, kScreenWidth-30, 44.0f);
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.view addSubview:self.searchController.searchBar];
    self.searchController.searchBar.hidden = YES;
    self.definesPresentationContext = YES;
    
    NSArray<NSString *> *publishTitles = @[@"不限",@"最近一个月",@"最近三个月",@"最近一年"];
    UIView *publishView = [self createViewSectionTitle:@"发布时间" searchtitles:publishTitles canDelete:NO];
    publishView.origin = CGPointMake(15.0f, 80.0f+[XKUIUnitls safeTop]);
    [self.searchController.view addSubview:publishView];
    NSArray<NSString *> *othertitles = @[@"默认(发布时间由近至远)",@"按评论量从高到低",@"按发布时间从远至近",@"按点赞量从高到低",@"只看有评论的作品",@"只看有点赞的作品",@"只看拼团过的作品"];
    UIView *otherView = [self createViewSectionTitle:@"其它筛选" searchtitles:othertitles canDelete:NO];
    otherView.origin = CGPointMake(15.0f, CGRectGetMaxY(publishView.frame)+30.0f);
    [self.searchController.view addSubview:otherView];
    
    self.resetBtn.frame = CGRectMake(15.0f, CGRectGetMaxY(otherView.frame)+50.0f, scalef(165.0f), 42.0f);
    
    self.finishBtn.frame = CGRectMake(CGRectGetMaxX(self.resetBtn.frame)+15.0f, CGRectGetMaxY(otherView.frame)+50.0f, scalef(165.0f), 42.0f);
    [self.searchController.view addSubview:self.resetBtn];
    [self.searchController.view addSubview:self.finishBtn];
    
    [[controller rac_signalForSelector:@selector(updateSearchResultsForSearchController:) fromProtocol:@protocol(UISearchResultsUpdating)] subscribeNext:^(RACTuple * _Nullable x) {
        UISearchController *searchController = [x objectAtIndex:0];
        if ([NSString isNull:searchController.searchBar.text]) {
            publishView.hidden = NO;
            otherView.hidden = NO;
        }else{
            publishView.hidden = YES;
            otherView.hidden = YES;
        }
    }];
    
}

- (void)willPresentSearchController:(UISearchController *)searchController{
   self.searchController.searchBar.hidden = NO;
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    self.searchController.searchBar.hidden = YES;
}

- (void)autoLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark tableView data source or delegate
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
    CTDesignerHallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTDesignerHallCell" forIndexPath:indexPath];
    NSMutableArray<NSURL *> *imageUrls = [NSMutableArray arrayWithCapacity:data.imageList.count];
    [data.imageList enumerateObjectsUsingBlock:^(XKDesignerWorkImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *url = [NSURL URLWithString:obj.imageUrl];
        [imageUrls addObject:url];
    }];
    cell.imageUrls = imageUrls;
    cell.countLabel.text = [@(data.imageList.count) stringValue];
    [cell.avatarBtn sd_setImageWithURL:[NSURL URLWithString:data.headUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang"] options:SDWebImageAvoidDecodeImage];
    cell.nameLabel.text = data.pageName;
    cell.timeLabel.text = data.showTime;
    cell.concern = data.isFollow.boolValue;
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


#pragma mark designer cell delegate
- (void)designerHallCell:(CTDesignerHallCell *_Nonnull)hallCell commentsAction:(nullable id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:hallCell];
    XKDesignerWorkData *workData = [self.works objectAtIndex:indexPath.row];
    self.commentVC.workId = workData.id;
    self.commentVC.designerId = workData.designerId;
    [self.commentVC refreshData];
    [self.commentVC show];
}

- (void)designerHallCell:(CTDesignerHallCell *_Nonnull)hallCell concernAction:(nullable id)sender{
    if ([[XKAccountManager defaultManager] isLogin] == NO) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:hallCell];
    XKDesignerWorkData *workData = [self.works objectAtIndex:indexPath.row];
    XKDesignerFollowVoParams *params = [[XKDesignerFollowVoParams alloc] init];
    params.designerId = workData.designerId;
    params.userId = [[[XKAccountManager defaultManager] account] userId];
    params.follow = ![workData.isFollow boolValue];
    [[XKFDataService() designerService] setConcernDesignerWithParams:params completion:^(XKBaseResponse * _Nonnull response) {
        if (response.isNotSuccess) {
            [response showError];
        }
    }];
}

- (void)designerHallCell:(CTDesignerHallCell *_Nonnull)hallCell thumbupAction:(nullable id)sender{
    if ([[XKAccountManager defaultManager] isLogin] == NO) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:hallCell];
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

- (void)designerHallCell:(CTDesignerHallCell *)designerHallCell avatarAction:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:designerHallCell];
    XKDesignerWorkData *workData = [self.works objectAtIndex:indexPath.row];
    XKDesignerBriefData *briefData = [[XKDesignerBriefData alloc] init];
    briefData.id = workData.designerId;
    briefData.pageName = workData.pageName;
    briefData.fabulousCount = workData.fabulousCnt;
    briefData.headUrl = workData.headUrl;
    CTDesignerHomeVC *controller = [[CTDesignerHomeVC alloc] initWithDesignerBriefData:briefData];
    [self.navigationController pushViewController:controller animated:YES];
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
            CTDesignerHallCell *hallCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            if (hallCell) {
                [hallCell.commentsBtn setTitle:[obj.commentCnt stringValue] forState:UIControlStateNormal];
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
    __block NSInteger index = NSNotFound;
    [self.works enumerateObjectsUsingBlock:^(XKDesignerWorkData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.designerId isEqualToString:param.designerId]){
            index = idx;
            XKDesignerWorkData *workData = [self.works objectAtIndex:index];
            workData.isFollow = @(param.follow);
            CTDesignerHallCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            if (param.follow) {
                if (cell) cell.concern = YES;
            }else{
                if (cell) cell.concern = NO;
            }
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
    CTDesignerHallCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (param.praise) {
        workData.fabulousCnt =  @(workData.fabulousCnt.integerValue + 1);
        if (cell) cell.thumbsupBtn.selected = YES;
    }else{
        workData.fabulousCnt =  @(workData.fabulousCnt.integerValue - 1);
        if(cell)cell.thumbsupBtn.selected = NO;
    }
    [cell.thumbsupBtn setTitle:[workData.fabulousCnt stringValue] forState:UIControlStateNormal];
    [cell.thumbsupBtn setSelected:workData.isPraise.boolValue];
}

#pragma mark user service 代理
- (void)loginWithService:(XKUserService *)service userInfo:(XKAccountData *)data{
    [self loadNewData];
}


#pragma mark action

- (void)rightItemAction:(id)sender{
    [self.searchController setActive:YES];
}

- (UIView *)createViewSectionTitle:(NSString *)sectionTitle searchtitles:(NSArray<NSString *> *)searchTitles canDelete:(BOOL)delete{
    if (searchTitles.count <= 0) {
        return nil;
    }
    CGFloat width = kScreenWidth-30.0f;
    __block UIView *view = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0, 200, 15.0f)];
    titleLabel.text = sectionTitle;
    titleLabel.textColor = HexRGB(0x999999, 1.0f);
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:titleLabel];
    if (delete) {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
        [deleteBtn setFrame:CGRectMake(width-15.0f, CGRectGetMidY(titleLabel.frame)-7.5f, 15.0f, 15.0f)];
        [view addSubview:deleteBtn];
        [[deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [view removeFromSuperview];
            view = nil;
        }];
    }
    __block UIButton *lastBtn = nil;
    CGFloat space = 10.0f;
    [searchTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 2.0f;
        button.tag = idx;
        [button setTitle:obj forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        button.backgroundColor = COLOR_VIEW_GRAY;
        [button setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        [button sizeToFit];
        button.width+=20.0f;
        if (idx == 0) {
            button.frame = CGRectMake(0.0f, CGRectGetMaxY(titleLabel.frame)+space, button.width, 35.0f);
        }else{
            if(lastBtn.right + button.width + space < width){
                button.x = lastBtn.right + space;
                button.y = lastBtn.y;
                button.height = lastBtn.height;
            }else{
                button.x = 0;
                button.y = lastBtn.bottom + space;
                button.height = lastBtn.height;
            }
        }
        [view addSubview:button];
        lastBtn = button;
    }];
    view.size = CGSizeMake(width, lastBtn.bottom);
    return view;
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
    params.limit= @(kPageCount);
    params.page = @1;
    
    NSArray<XKDesignerWorkData *> *works = [[XKFDataService() designerService] queryWorksFromCacheWithParams:params];
    if (works.count) {
        [self.works removeAllObjects];
        [self.works addObjectsFromArray:works];
    }
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

- (UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.backgroundColor = COLOR_TEXT_BROWN;
        [_resetBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        _resetBtn.layer.cornerRadius = 2.0f;
    }
    return _resetBtn;
}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        [_finishBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        _finishBtn.layer.cornerRadius = 2.0f;
    }
    return _finishBtn;
}

- (CTCommentVC *)commentVC{
    if (!_commentVC) {
        _commentVC = [[CTCommentVC alloc] init];
    }
    return _commentVC;
}

- (NSMutableArray<XKDesignerWorkData *> *)works{
    if (!_works) {
        _works = [NSMutableArray array];
    }
    return _works;
}

@end
