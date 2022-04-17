//
//  MIMutilOrderListVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIDiscountOrderListVC.h"
#import "MIOrderDetailVC.h"
#import "MIOrderDiscountStoreCell.h"
#import "MIOrderFootView.h"
#import "XKOrderModel.h"
#import "XKOrderManger.h"
#import "MJDIYFooter.h"
#import "XKUserService.h"

@interface MIDiscountOrderListVC ()<UITableViewDelegate,UITableViewDataSource,XKOrderMangerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<XKOrderListModel *> *dataArray;

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *resultArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation MIDiscountOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _page = 1;
    [self setUI];
    [self addRefresh];
    [self getOrderList];
    [[XKOrderManger sharedMange]addWeakDelegate:self];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    self.tableView.ly_emptyView = [XKEmptyView orderListNoDataView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[MIOrderDiscountStoreCell class] forCellReuseIdentifier:@"MIOrderDiscountStoreCell"];
    [self.tableView registerClass:[MIOrderFootView class] forHeaderFooterViewReuseIdentifier:footID1];
    
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
                                   @"limit":@10,
                                   @"buyerAccount":userInfo.mobile ,
                                   }.mutableCopy;
    if (self.status > 0) {
        [param setObject:@(self.status) forKey:@"state"];
    }
    [self.tableView ly_startLoading];
    [[XKFDataService() orderService]getOrderListByType:OTDiscount andParam:param comlete:^(XKOrderListResponse * _Nonnull response) {
        if ([response isSuccess]) {
            XKOrderListData *data = response.data;
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            if (self.page <= data.pageCount && self.dataArray.count < data.totalCount) {
                self.page++;
                [self.dataArray addObjectsFromArray:data.result];
                [self handleData];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [response showError];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView ly_endLoading];
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)handleData{
    NSMutableArray<NSMutableArray *> *results = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(XKOrderListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.type = OTDiscount;
        if (obj.state == OSUnPay) {
            __block BOOL contain = NO;
            [results enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull array, NSUInteger idx, BOOL * _Nonnull stop) {
                XKOrderListModel *model = [array firstObject];
                if (model.state == OSUnPay && [model.tradeNo isEqualToString:obj.tradeNo]) {
                    [array addObject:obj];
                    contain = YES;
                    *stop = YES;
                }
            }];
            if (NO == contain) {
                [results addObject:[NSMutableArray arrayWithObjects:obj, nil]];
            }
        }else{
            [results addObject:[NSMutableArray arrayWithObjects:obj, nil]];
        }
    }];
    
    [results enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull array, NSUInteger idx, BOOL * _Nonnull stop) {
        __block CGFloat totalAmout = 0;
        [array enumerateObjectsUsingBlock:^(XKOrderListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            totalAmout += [obj.payAmount floatValue];
        }];
        [array enumerateObjectsUsingBlock:^(XKOrderListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.payAmount = @(totalAmout);
        }];
    }];
    self.resultArray = results;
    /*
    NSMutableArray *results = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(XKOrderListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.type = OTDiscount;
        if (![results containsObject:obj.tradeNo]) [results addObject:obj.tradeNo];
    }];
    NSMutableArray *mutilOrders = [NSMutableArray array];
    [results enumerateObjectsUsingBlock:^(NSString *tradeNo, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *subArray = [NSMutableArray array];
        __block CGFloat totalAmout = 0;
        [self.dataArray enumerateObjectsUsingBlock:^(XKOrderListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tradeNo == tradeNo) {
                [subArray addObject:obj];
                totalAmout += [obj.payAmount floatValue];
            }
        }];
        [subArray enumerateObjectsUsingBlock:^(XKOrderListModel * _Nonnull selectObj, NSUInteger idx, BOOL * _Nonnull stop) {
            selectObj.payAmount = @(totalAmout);
        }];
        [mutilOrders addObject:subArray];
    }];
    _resultArray = mutilOrders;
     */
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count < K_REQUEST_PAGE_COUNT ) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    return self.resultArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray <XKOrderListModel *> *models = self.resultArray[section];
    return [models count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIOrderDiscountStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIOrderDiscountStoreCell" forIndexPath:indexPath];
    NSArray <XKOrderListModel *> *models = self.resultArray[indexPath.section];
    XKOrderListModel *model = models[indexPath.row];
    
    cell.titleLabel.text  = model.merchantName;
    if (indexPath.row == 0) {
        cell.needCorner     = YES;
        cell.subLabel.text   = model.statusTitle;
    }else{
        cell.needCorner     = NO;
        cell.subLabel.text  = @"";
    }
    cell.numLabel.text   = [NSString stringWithFormat:@"x%@",model.commodityQuantity ? model.commodityQuantity : @1];
    cell.nameLabel.text  = model.goodsName;
    [cell.coverView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commoditySalePrice doubleValue]/100];
    cell.desLabel.text   = [NSString stringWithFormat:@"%@ %@",model.commodityModel,model.commoditySpec];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    NSArray *subArray  = self.resultArray[section];
    MIOrderFootView *foot = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footID1];
    foot.model = subArray[0];
    foot.tag = section;
    [foot addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSection:)]];
    return foot;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 79;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray <XKOrderListModel *> *models = self.resultArray[indexPath.section];
    XKOrderListModel *model = models[indexPath.row];
    MIOrderDetailVC *vc = [[MIOrderDetailVC alloc]initWithOrderID:model.orderNo andType:model.type];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapSection:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    XKOrderListModel *model = [self.resultArray[tag] lastObject];
    MIOrderDetailVC *vc = [[MIOrderDetailVC alloc]initWithOrderID:model.orderNo andType:model.type];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark delegate
- (void)orderHasDelete:(NSString *)orderNo{
    [self.resultArray enumerateObjectsUsingBlock:^(NSArray *subArray, NSUInteger i, BOOL * _Nonnull stop) {
        __block BOOL resultNeedDelete = NO;
        [subArray enumerateObjectsUsingBlock:^(XKOrderListModel *subModel, NSUInteger j, BOOL * _Nonnull stop) {
            BOOL dataArrayNeedDelete = NO;
            if ([subModel.orderNo isEqualToString:orderNo]) {
                dataArrayNeedDelete = YES;
            }
            if (dataArrayNeedDelete) {
                [self.dataArray removeObject:subModel];
                resultNeedDelete = YES;
            }
        }];
        if (resultNeedDelete) {
            [UIView performWithoutAnimation:^{
                [self.resultArray removeObject:subArray];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationNone];
                *stop = YES;
            }];
        }
    }];
}

- (void)orderStatusHasUpdate:(NSString *)orderNo andOrderStatus:(XKOrderStatus)orderStaus{
    BOOL needRemoveFromTable = NO;
    if (orderStaus == OSCancle  && self.status == OSUnPay) {
        needRemoveFromTable = YES;
    }
    [self.resultArray enumerateObjectsUsingBlock:^(NSArray *subArray, NSUInteger i, BOOL * _Nonnull stop) {
        
        __block BOOL tabNeedUpdate = NO;
        [subArray enumerateObjectsUsingBlock:^(XKOrderListModel *subModel, NSUInteger j, BOOL * _Nonnull stop) {
            BOOL dataArrayNeedUpdate = NO;
            if ([subModel.orderNo isEqualToString:orderNo]) {
                dataArrayNeedUpdate = YES;
            }
            if (dataArrayNeedUpdate) {
                subModel.state = orderStaus;
                tabNeedUpdate = YES;
            }
        }];
        if (tabNeedUpdate) {
            [UIView performWithoutAnimation:^{
                if (needRemoveFromTable) {
                    [self.resultArray removeObject:subArray];
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            
            *stop = YES;
        }
    }];
}
- (void)dealloc{
    [[XKOrderManger sharedMange]removeWeakDelegate:self];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 141.0f;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [XKUIUnitls safeBottom])];
        _tableView.showsVerticalScrollIndicator  = NO;
    }
    return _tableView;
}
@end
