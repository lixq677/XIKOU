//
//  HMMessageListVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMMessageListVC.h"
#import "HMCommonMsgCell.h"
#import "MJDIYFooter.h"

#import "XKAccountManager.h"

static const int kPageCount =   20;

@interface HMMessageListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,assign,readonly) XKMsgType msgType;

@property (nonatomic,strong,readonly)NSMutableArray<XKMsgData *> *msgs;

@property (nonatomic,assign)NSUInteger curPage;

@end

@implementation HMMessageListVC
@synthesize tableView = _tableView;
@synthesize msgs =_msgs;

- (instancetype)initWithTypeMsgType:(XKMsgType)msgType{
    if (self = [super init]) {
        _msgType = msgType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title = nil;
    switch (self.msgType) {
        case XKMsgTypeOrder:{
            title = @"订单助手";
        }
            break;
        case XKMsgTypeActivity:{
            title = @"活动消息";
        }
            break;
        case XKMsgTypeSystem:{
            title = @"系统消息";
        }
            break;
        case XKMsgTypeNotice:{
            title = @"公告";
        }
            break;
        default:
            break;
    }
    self.title = title;
    [self.view addSubview:self.tableView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wdz"]];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"还没有消息啦";
    label.textColor = HexRGB(0x999999, 1.0f);
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:label];
    imageView.centerX = kScreenWidth/2.0f;
    imageView.top = 175.0f;
    
    [label sizeToFit];
    label.centerX = imageView.centerX;
    label.top = imageView.bottom+10.0f;
    self.tableView.backgroundView = backgroundView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.tableView registerClass:[HMCommonMsgCell class] forCellReuseIdentifier:@"HMCommonMsgCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self queryDataFromCache];
    [self loadNewData];
}


#pragma mark getter or setter
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.msgs.count < kPageCount) {
        tableView.mj_footer.hidden = YES;
    }else{
        tableView.mj_footer.hidden = NO;
    }
    if(self.msgs.count > 0){
        tableView.backgroundView.hidden = YES;
    }else{
        tableView.backgroundView.hidden = NO;
    }
    return self.msgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMCommonMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMCommonMsgCell" forIndexPath:indexPath];
    XKMsgData *data = [self.msgs objectAtIndex:indexPath.row];
    cell.textLabel.text = data.title;
    cell.detailTextLabel.text = data.content;
    cell.timeLabel.text = data.sendTime;
//    if (data.isRead) {
//        cell.msgState = HMMsgStateRead;
//    }else{
//        cell.msgState = HMMsgStateUnread;
//    }
    if ([NSString isNull:data.img]) {
        cell.hasImage = NO;
    }else{
        cell.hasImage = YES;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:data.img] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    }
    if ([NSString isNull:data.url] || !([XKGlobalModuleRouter isValidScheme:data.url] || [data.url isUrl])){
        cell.seeDetailLabel.hidden = YES;
        cell.arrowImageView.hidden = YES;
    }else{
        cell.seeDetailLabel.hidden = NO;
        cell.arrowImageView.hidden = NO;
    }
    
    [cell layoutIfNeeded];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKMsgData *data = [self.msgs objectAtIndex:indexPath.row];
    if (![NSString isNull:data.url]) {
        void (^block)(void) = ^{
            [[XKFDataService() messageService] readMsgWithMsgId:data.id];
            data.isRead = YES;
            HMCommonMsgCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            if (data.isRead) {
//                cell.msgState = HMMsgStateRead;
//            }else{
//                cell.msgState = HMMsgStateUnread;
//            }
//            if (data.msgType == XKMsgTypeActivity) {
//                cell.msgState = HMMsgStateNone;
//            }
 //           cell.msgState = HMMsgStateNone;
            [cell setNeedsLayout];
        };
        
        if ([XKGlobalModuleRouter isValidScheme:data.url]) {
            [MGJRouter openURL:data.url];
            block();
        }else if ([data.url isUrl]){
            [MGJRouter openURL:kRouterWeb withUserInfo:@{@"url":data.url} completion:nil];
            block();
        }else{
           // XKShowToast(@"未能识别的字符串");
        }
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
    
    
    XKMsgParams *params = [[XKMsgParams alloc] init];
    params.userId = userId;
    params.typeId = self.msgType;
    params.limit= @(kPageCount);
    if (update) {
        params.page = @1;
    }else{
        params.page = @(self.curPage+1);
    }
    @weakify(self);
    [[XKFDataService() messageService] queryMsgsWithParams:params completion:^(XKMsgResponse * _Nonnull response) {
        @strongify(self);
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if (response.isSuccess) {
            if ([response isSuccess]) {
                //刷新数据时，需要清理旧的数据
                if (update) {
                    [self.msgs removeAllObjects];
                }
                self.curPage = params.page.intValue;
                [self.msgs addObjectsFromArray:response.data];
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

- (void)queryDataFromCache{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    if ([NSString isNull:userId]) return;
    
    
    XKMsgParams *params = [[XKMsgParams alloc] init];
    params.userId = userId;
    params.typeId = self.msgType;
    params.limit= @(kPageCount);
    params.page = @1;
    NSArray<XKMsgData *> *msgs = [[XKFDataService() messageService] queryMsgsWithParamsFromCache:params];
    [self.msgs removeAllObjects];
    [self.msgs addObjectsFromArray:msgs];
}


#pragma mark getter or setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 230.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray<XKMsgData *> *)msgs{
    if (!_msgs) {
        _msgs= [NSMutableArray array];
    }
    return _msgs;
}

@end
