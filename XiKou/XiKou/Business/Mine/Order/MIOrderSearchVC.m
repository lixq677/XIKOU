//
//  MIOrderSearchVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderSearchVC.h"
#import "MIOrderListView.h"
#import "MIOrderFilterView.h"
#import "MIOrderDetailVC.h"
#import "MJDIYFooter.h"
#import "XKOrderManger.h"
#import "XKUserService.h"

@interface MIOrderSearchVC ()<UITextFieldDelegate,OrderListDelegate,XKOrderMangerDelegate>
/** 搜索框*/
@property (nonatomic, strong)  UITextField *searchTF;
/** 取消*/
@property (nonatomic, strong)  UIButton *cancelBT;

@property (nonatomic, strong)  MIOrderListView *searchView;

@property (nonatomic, strong)  MIOrderFilterView *filterView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray<XKOrderListModel *> *dataArray;
/** 时间筛选 */
@property (nonatomic, assign)  OrderTimeFilter timeFilter;
/** 最小价格 */
@property (nonatomic, copy) NSNumber *minPrice;
/** 最大价格 */
@property (nonatomic, copy) NSNumber *maxPrice;
@end

@implementation MIOrderSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _dataArray = [NSMutableArray array];
    [self setUI];
    [self addRefresh];
    [self block];
    [[XKOrderManger sharedMange]addWeakDelegate:self];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

#pragma mark - UI
- (void)setUI{
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view xk_addSubviews:@[self.searchTF,self.cancelBT,self.searchView,self.filterView]];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(@30);
        make.right.equalTo(self.view).offset(-60);
        make.top.equalTo(self.view).offset(20 + kStatusBarHeight);
    }];
    [self.cancelBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchTF.mas_right);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(@30);
        make.centerY.equalTo(self.searchTF);
    }];
    [self.searchView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchTF.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset([XKUIUnitls safeTop]);
    }];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchView);
    }];
}

#pragma mark - 事件
- (void)cancelBTClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma makr - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _page = 1;
    [self getOrderList];
    [textField resignFirstResponder];
    self.filterView.hidden = YES;
    self.searchView.hidden = NO;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.filterView.hidden = NO;
    self.searchView.hidden = YES;
}

- (void)block{
    @weakify(self);
    self.filterView.filterBlock = ^(OrderTimeFilter filter, NSString * _Nonnull minPrice, NSString * _Nonnull maxPrice) {
        @strongify(self);
        self.filterView.hidden = YES;
        self.searchView.hidden = NO;
        self.timeFilter = filter;
        if (![NSString isNull:minPrice]) {
            self.minPrice = [NSNumber numberWithUnsignedInteger:[@(minPrice.doubleValue * 100) unsignedLongValue]];
        }
        if ((![NSString isNull:maxPrice])) {
            self.maxPrice = [NSNumber numberWithUnsignedInteger:[@(maxPrice.doubleValue * 100) unsignedLongValue]];
        }
        [self.searchTF resignFirstResponder];
        [self getOrderList];
    };
}

#pragma mark dataRequest
- (void)addRefresh{
    @weakify(self);
    self.searchView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self getOrderList];
    }];
    self.searchView.mj_footer = [MJDIYFooter footerWithRefreshingBlock:^{
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
    if (self.timeFilter != Unlimited) {
        [param setObject:@(self.timeFilter) forKey:@"createTimeFlag"];
    }
    if (self.searchTF.text.length > 0) {
        [param setObject:self.searchTF.text forKey:@"searchName"];
    }
    if (self.minPrice) {
        [param setObject:self.minPrice forKey:@"orderAmountL"];
    }
    if (self.maxPrice) {
        [param setObject:self.maxPrice forKey:@"orderAmountR"];
    }
    if (self.type == OTConsigned) {
        [param setObject:userInfo.mobile forKey:@"consignmentAccount"];
    }else{
        [param setObject:userInfo.mobile forKey:@"buyerAccount"];
    }
    [self.searchView ly_startLoading];
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
                self.searchView.orderArray = self.dataArray;
                [self.searchView.mj_footer endRefreshing];
            }else{
                [self.searchView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [response showError];
            [self.searchView.mj_footer endRefreshing];
        }
        [self.searchView ly_endLoading];
        [self.searchView.mj_header endRefreshing];
    }];
}
#pragma mark delegate
- (void)selectOrder:(XKOrderListModel *)model{
    if (model.type == OTConsigned) {
        return;
    }
    MIOrderDetailVC *vc = [[MIOrderDetailVC alloc]initWithOrderID:model.orderNo andType:model.type];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark delegate
- (void)orderHasDelete:(NSString *)orderNo{
    [self.dataArray enumerateObjectsUsingBlock:^(XKOrderListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.orderNo == orderNo) {
            [self.dataArray removeObject:obj];
            [self.searchView deleteSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationNone];
            *stop = YES;
        }
    }];
}

- (void)orderStatusHasUpdate:(NSString *)orderNo andOrderStatus:(XKOrderStatus)orderStaus{

    [self.dataArray enumerateObjectsUsingBlock:^(XKOrderListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.orderNo isEqualToString:orderNo]) {
            obj.state = orderStaus;
            [self.searchView reloadSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationNone];
            *stop = YES;
        }
    }];
}
- (void)dealloc{
    [[XKOrderManger sharedMange]removeWeakDelegate:self];
}

#pragma makr - lazy
- (UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [UITextField new];
        _searchTF.textColor = COLOR_TEXT_BLACK;
        _searchTF.font = Font(12.f);
        _searchTF.delegate  = self;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.backgroundColor = COLOR_VIEW_GRAY;
        _searchTF.layer.cornerRadius = 15;
        _searchTF.clipsToBounds = YES;
        _searchTF.placeholder = @"商品名称/商品编号/订单号";

        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 14, 14)];
        logoView.image = [UIImage imageNamed:@"search"];
        logoView.contentMode = UIViewContentModeCenter;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
        [view addSubview:logoView];
        _searchTF.leftView = view;
    }
    return _searchTF;
}

- (MIOrderListView *)searchView{
    if (!_searchView) {
        _searchView = [[MIOrderListView alloc] init];
        _searchView.orderDelegate = self;
        _searchView.ly_emptyView = [XKEmptyView orderListNoDataView];
        _searchView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _searchView;
}
- (UIButton *)cancelBT{
    if (!_cancelBT) {
        _cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBT.titleLabel.font = Font(14.f);
        [_cancelBT setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBT setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
        [_cancelBT addTarget:self action:@selector(cancelBTClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBT;
}
- (MIOrderFilterView *)filterView{
    if (!_filterView) {
        _filterView = [[MIOrderFilterView alloc]init];
    }
    return _filterView;
}
@end
