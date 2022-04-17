//
//  MIDesignerConcernVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/26.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIDesignerConcernVC.h"
#import "XKDataService.h"
#import "MJDIYFooter.h"
#import <SDWebImage.h>
#import "MIBasicCell.h"
#import "CTDesignerHomeVC.h"
#import "XKDesignerService.h"
#import "XKAccountManager.h"

static const int kPageCount =   20;

@interface MIDesignerConcernVC ()<UITableViewDelegate,UITableViewDataSource,MIConcernCellDelegate,XKDesignerServiceDelegate>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong,readonly) NSMutableArray<XKDesignerMyConcernData *> *designers;

@property (nonatomic,assign)NSUInteger curPage;

@end

@implementation MIDesignerConcernVC
@synthesize tableView = _tableView;
@synthesize designers = _designers;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self setupTabelView];
    [self layout];
    
    [self queryDesignerOfMyConcernFromCache];
    [self loadNewData];
    [[XKFDataService() designerService] addWeakDelegate:self];
}

- (void)dealloc{
    [[XKFDataService() designerService] removeWeakDelegate:self];
}

- (void)setupTabelView{
    [self.tableView registerClass:[MIConcernCell class] forCellReuseIdentifier:@"MIConcernCell"];
    [self.view addSubview:self.tableView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wuyouhuiquan"]];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"还没有关注，赶紧去关注吧";
    label.textColor = HexRGB(0x999999, 1.0f);
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:label];
    imageView.centerX = kScreenWidth/2.0f;
    imageView.top = 75.0f;
    
    [label sizeToFit];
    label.centerX = imageView.centerX;
    label.top = imageView.bottom+10.0f;
    
    self.tableView.backgroundView = backgroundView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


- (void)layout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark data source or delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.designers.count < kPageCount) {
        tableView.mj_footer.hidden = YES;
    }else{
        tableView.mj_footer.hidden = NO;
    }
    if(self.designers.count > 0){
        tableView.backgroundView.hidden = YES;
    }else{
        tableView.backgroundView.hidden = NO;
    }
    return self.designers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIConcernCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIConcernCell" forIndexPath:indexPath];
    XKDesignerMyConcernData *data = [self.designers objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:data.headUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    cell.namelabel.text = data.name;
    cell.describelabel.text = data.createTimeDifference;
    cell.delegate = self;
    return cell;
}

- (void)cell:(MIConcernCell *)cell clickAvatarWithSender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    XKDesignerMyConcernData *concernData = [self.designers objectAtIndex:indexPath.row];
    XKDesignerBriefData *briefData = [[XKDesignerBriefData alloc] init];
    briefData.id = concernData.id;
    CTDesignerHomeVC *controller = [[CTDesignerHomeVC alloc] initWithDesignerBriefData:briefData];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)cell:(MIConcernCell *)cell clickConcernWithSender:(id)sender{
    if ([[XKAccountManager defaultManager] isLogin] == NO) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    XKDesignerMyConcernData *concernData = [self.designers objectAtIndex:indexPath.row];
    XKDesignerFollowVoParams *params = [[XKDesignerFollowVoParams alloc] init];
    params.designerId = concernData.id;
    params.userId = [[[XKAccountManager defaultManager] account] userId];
    params.follow = NO;
    [XKLoading show];
    [[XKFDataService() designerService] setConcernDesignerWithParams:params completion:^(XKBaseResponse * _Nonnull response) {
        [XKLoading dismiss];
        if (response.isNotSuccess) {
            [response showError];
        }
    }];
}

#pragma mark designer service 代理

- (void)concernDesignerWithService:(XKDesignerService *)service param:(XKDesignerFollowVoParams *)param{
    __block NSInteger index = NSNotFound;
    [self.designers enumerateObjectsUsingBlock:^(XKDesignerMyConcernData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.id isEqualToString:param.designerId]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index != NSNotFound) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView beginUpdates];
        [self.designers removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
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
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    if ([NSString isNull:userId]) return;
    @weakify(self);
    XKDesignerMyConcernParams *params = [[XKDesignerMyConcernParams alloc] init];
    params.userId = [[[XKAccountManager defaultManager] account] userId];
    params.limit= @(kPageCount);
    if (update) {
        params.page = @1;
    }else{
        params.page = @(self.curPage+1);
    }
    [[XKFDataService() designerService] queryDesignersOfMyConcernParams:params completion:^(XKDesignerMyConcernResponse * _Nonnull response) {
        @strongify(self);
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if (response.isSuccess) {
            if ([response isSuccess]) {
                //刷新数据时，需要清理旧的数据
                if (update) {
                    [self.designers removeAllObjects];
                }
                self.curPage = params.page.intValue;
                [self.designers addObjectsFromArray:response.data];
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

- (void)queryDesignerOfMyConcernFromCache{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    if ([NSString isNull:userId]) return;
    XKDesignerMyConcernParams *params = [[XKDesignerMyConcernParams alloc] init];
    params.userId = [[[XKAccountManager defaultManager] account] userId];
    params.limit= @(kPageCount);
    params.page = @1;
    NSArray<XKDesignerMyConcernData *> *array = [[XKFDataService() designerService] queryDesignerOfMyConcernFromCache:params];
    [self.designers removeAllObjects];
    [self.designers addObjectsFromArray:array];
}


- (void)reloadData{
    [self loadNewData];
}



#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.separatorColor  = COLOR_LINE_GRAY;
        _tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView.rowHeight = 80.0f;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray<XKDesignerMyConcernData *> *)designers{
    if (!_designers) {
        _designers = [NSMutableArray array];
    }
    return _designers;
}


@end
