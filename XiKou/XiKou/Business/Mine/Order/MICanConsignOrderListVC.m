//
//  MICanConsignOrderListVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MICanConsignOrderListVC.h"
#import "MIOrderDetailVC.h"
#import "XKWebViewController.h"

#import "MIOrderGoodCell.h"
#import "MIOrderHeadView.h"
#import "MIOrderFootView.h"

#import "MJDIYFooter.h"
#import "XKOrderModel.h"
#import "XKOrderManger.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKUserService.h"

@interface MICanConsignOrderListVC ()<UITableViewDelegate,UITableViewDataSource,XKOrderMangerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray<XKOrderListModel *> *dataArray;

@end

@implementation MICanConsignOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self addRefresh];
    [self getCanConsignOrder];
    [[XKOrderManger sharedMange]addWeakDelegate:self];
}
#pragma mark UI
- (void)setUI{
    self.title = @"可寄卖商品";
    _dataArray = [NSMutableArray array];
    _page = 1;
    
    [self.view addSubview:self.tableView];
    _tableView.ly_emptyView = [XKEmptyView orderListNoDataView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addNavigationItemWithTitle:@"寄卖协议" isLeft:NO target:self action:@selector(consignProteco)];
}

- (void)consignProteco{
    XKWebViewController *webVC = [[XKWebViewController alloc]initWithURL:[NSURL URLWithString:@"https://m.luluxk.com/agreement/sales.html"]];
    webVC.title = @"寄卖协议";
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark dataRequest
- (void)addRefresh{
    @weakify(self);
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self getCanConsignOrder];
    }];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self getCanConsignOrder];
    }];
}

//获取我要寄卖的订单列表
- (void)getCanConsignOrder{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    XKUserInfoData *userInfo = [[XKFDataService() userService] queryUserInfoFromCacheWithId:userId];
    [[XKFDataService() orderService]getCanConsignOrderByUserId:userInfo.mobile andPage:_page andLimit:10 comlete:^(XKOrderListResponse * _Nonnull response) {
        if ([response isSuccess]) {
            XKOrderListData *data = response.data;
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            if (self.page <= data.pageCount && self.dataArray.count < data.totalCount) {
                self.page++;
                [self.dataArray addObjectsFromArray:data.result];
                [self.dataArray enumerateObjectsUsingBlock:^(XKOrderListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.type = OTCanConsign;
                }];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count < K_REQUEST_PAGE_COUNT ) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MIOrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:[MIOrderGoodCell identify]];
    XKOrderListModel *model  = _dataArray[indexPath.section];
    //cell.numLabel.text   = [NSString stringWithFormat:@"x%@",model.commodityQuantity ? model.commodityQuantity : @1];
    cell.nameLabel.text  = model.goodsName;
    [cell.nameLabel setLineSpace:8.5];
    [cell.coverView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
    //cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commoditySalePrice doubleValue]/100.00];
    cell.desLabel.text   = [NSString stringWithFormat:@"原价: ¥%.2f 折扣价: ¥%.2f 优惠券: ¥%.2f",[model.commoditySalePrice floatValue]/100.00,[model.discountPrice floatValue]/100.00,[model.deductionCouponAmount floatValue]/100.00];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MIOrderHeadView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MIOrderHeadView identify]];
    XKOrderListModel *model  = _dataArray[section];
    head.titleLabel.text = model.merchantName;
    head.subLabel.text   = model.statusTitle;
    head.userInteractionEnabled = YES;
    head.tag = section;
    [head addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSection:)]];
    return head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    XKOrderListModel *model  = _dataArray[section];
    MIOrderFootView *foot = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footID2];
    foot.model = model;
    foot.tag = section;
    [foot addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSection:)]];
    return foot;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 101;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self selectSection:indexPath.section];
}

- (void)tapSection:(UITapGestureRecognizer *)tap{
//    NSInteger tag = tap.view.tag;
//    [self selectSection:tag];
}


- (void)orderStatusHasUpdate:(NSString *)orderNo andOrderStatus:(XKOrderStatus)orderStaus{
    [self.dataArray enumerateObjectsUsingBlock:^(XKOrderListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.orderNo isEqualToString:orderNo]) {
            [self.dataArray removeObject:obj];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationNone];
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
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [XKUIUnitls safeBottom])];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        [_tableView registerClass:[MIOrderGoodCell class] forCellReuseIdentifier:[MIOrderGoodCell identify]];
        [_tableView registerClass:[MIOrderHeadView class] forHeaderFooterViewReuseIdentifier:[MIOrderHeadView identify]];
        [_tableView registerClass:[MIOrderFootView class] forHeaderFooterViewReuseIdentifier:footID2];
    }
    return _tableView;
}
@end
