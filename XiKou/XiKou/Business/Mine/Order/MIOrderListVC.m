//
//  MIOrderListVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderListVC.h"
#import "MIOrderListView.h"
#import "MIOrderDetailVC.h"
#import "MJDIYFooter.h"

#import "XKOrderManger.h"
#import "XKUserService.h"

@interface MIOrderListVC ()<OrderListDelegate,XKOrderMangerDelegate,XKOrderServiceDelegate>

@property (nonatomic, strong) MIOrderListView *tableView;

@property (nonatomic, assign) XKOrderType type;

@property (nonatomic, assign) XKOrderStatus status;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray<XKOrderListModel *> *dataArray;

@end

@implementation MIOrderListVC

- (instancetype)initWithOrderType:(XKOrderType)type
                   andOrderStatus:(XKOrderStatus)status{
    self = [super init];
    if (self) {
        _type = type;
        _status = status;
        _dataArray = [NSMutableArray array];
        _page = 1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self getOrderList];
    [self addRefresh];
    [[XKOrderManger sharedMange]addWeakDelegate:self];
    [[XKFDataService() orderService] addWeakDelegate:self];
}
#pragma mark UI
- (void)setUI{
    _tableView = [[MIOrderListView alloc]initWithFrame:CGRectZero];
    _tableView.orderDelegate = self;
    _tableView.ly_emptyView = [XKEmptyView orderListNoDataView];
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark dataRequest
- (void)addRefresh{
    @weakify(self);
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self getOrderList];
    }];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self getOrderList];
    }];
}

//订单列表
- (void)getOrderList{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    XKUserInfoData *userInfo = [[XKFDataService() userService] queryUserInfoFromCacheWithId:userId];
    NSMutableDictionary *param = @{@"page":@(_page),
                                   @"limit":@10
                                   }.mutableCopy;
    if (self.status > 0) {
        [param setObject:@(self.status) forKey:@"state"];
    }
    if (self.type == OTConsigned) {
        [param setObject:userInfo.mobile forKey:@"consignmentAccount"];
    }else{
        [param setObject:userInfo.mobile forKey:@"buyerAccount"];
    }
    [self.tableView ly_startLoading];
    [[XKFDataService() orderService]getOrderListByType:self.type andParam:param comlete:^(XKOrderListResponse * _Nonnull response) {
        if ([response isSuccess]) {
            XKOrderListData *data = response.data;
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            if (self.page <= data.pageCount && self.dataArray.count < data.totalCount) {
                self.page++;
                [self.dataArray addObjectsFromArray:data.result];
                [self.dataArray enumerateObjectsUsingBlock:^(XKOrderListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.type = self.type;
                }];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.tableView.orderArray = self.dataArray;
            [self.tableView.mj_header endRefreshing];
        }else{
            [response showError];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView ly_endLoading];
    }];
}
#pragma mark order tbaleView delegate
- (void)selectOrder:(XKOrderListModel *)model{
    MIOrderDetailVC *vc = [[MIOrderDetailVC alloc]initWithOrderID:model.orderNo andType:model.type];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark orderManger delegate
- (void)orderHasDelete:(NSString *)orderNo{
    [self.dataArray enumerateObjectsUsingBlock:^(XKOrderListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.orderNo isEqualToString:orderNo]) {
            [self.dataArray removeObject:obj];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationNone];
            *stop = true;
        }
    }];
}

- (void)orderStatusHasUpdate:(NSString *)orderNo andOrderStatus:(XKOrderStatus)orderStaus{
    BOOL needRemoveFromTable = false;
    if (self.type == OTGlobalSeller &&(orderStaus == OSConsign || orderStaus == OSUnDeliver) && self.status == OSUnSure) {
        needRemoveFromTable = true;
    }
    if (orderStaus == OSCancle  && self.status == OSUnPay) {
        needRemoveFromTable = true;
    }
    if (orderStaus == OSComlete  && self.status == OSUnReceive) {
        needRemoveFromTable = true;
    }
    [self.dataArray enumerateObjectsUsingBlock:^(XKOrderListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.orderNo isEqualToString:orderNo]) {
            obj.state = orderStaus;
            if (needRemoveFromTable) {
                [self.dataArray removeObject:obj];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationNone];
            }
            *stop = true;
        }
    }];
}

#pragma order service delegate
- (void)payAnotherApplySuccess:(NSString *)orderNo{
    [self.dataArray enumerateObjectsUsingBlock:^(XKOrderListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.orderNo isEqualToString:orderNo]) {
            obj.paid = false;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationNone];
            *stop = true;
        }
    }];
}

- (void)dealloc{
    [[XKOrderManger sharedMange]removeWeakDelegate:self];
    [[XKFDataService() orderService] removeWeakDelegate:self];
}
@end
