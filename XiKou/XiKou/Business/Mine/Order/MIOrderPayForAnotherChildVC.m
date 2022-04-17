//
//  MIOrderPayForAnotherChildVC.m
//  XiKou
//
//  Created by L.O.U on 2019/8/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderPayForAnotherChildVC.h"
#import "MIOrderGoodCell.h"
#import "MIOrderHeadView.h"
#import "MIOrderPayAnotherFooter.h"
#import "MJDIYFooter.h"
#import "MJDIYHeader.h"
#import "XKOrderService.h"
#import "XKUserService.h"
#import "XKOrderManger.h"

@interface MIOrderPayForAnotherChildVC ()<UITableViewDelegate,UITableViewDataSource,XKOrderMangerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation MIOrderPayForAnotherChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    [self queryOrderData];
    [self addRefresh];
    [[XKOrderManger sharedMange]addWeakDelegate:self];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    [self.view addSubview:self.tableView];
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
        [self queryOrderData];
    }];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.page += 1;
        [self queryOrderData];
    }];
}

- (void)queryOrderData{
    
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    XKUserInfoData *userInfo = [[XKFDataService() userService] queryUserInfoFromCacheWithId:userId];
    
    XKInsteadPaymentParams *param = [XKInsteadPaymentParams new];
    param.limit        = @10;
    param.page         = @(self.page);
    param.buyerAccount = userInfo.mobile;
    param.state        = self.status;
    [[XKFDataService() orderService]queryInsteadPaymentWithParams:param completion:^(                               XKInsteadPaymentResponse * _Nonnull response) {
        if ([response isSuccess]) {
            //刷新数据时，需要清理旧的数据
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            }
            self.page = param.page.intValue;
            
            if (response.data.count > 0) {
                XKInsteadPaymentData *data = response.data[0];
                if (self.requestSuccessBlock) {
                    self.requestSuccessBlock(data.hasPaid, data.notPaid);
                }
                [self.dataArray addObjectsFromArray:data.insteadPaymentOrderPageModels];
                [self.tableView reloadData];
                if (data.insteadPaymentOrderPageModels.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                if (self.requestSuccessBlock) {
                    self.requestSuccessBlock(0, 0);
                }
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            [response showError];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count < K_REQUEST_PAGE_COUNT ) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    XKOrderPaymentModel *model = self.dataArray[indexPath.section];
    MIOrderPayAnotherGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:[MIOrderPayAnotherGoodCell identify]];
 
    cell.numLabel.text   = [NSString stringWithFormat:@"x%u",model.commodityQuantity];
    cell.nameLabel.text  = model.goodsName;
    [cell.coverView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];

    cell.priceLabel.text  = [NSString stringWithFormat:@"¥%.2f",model.commoditySalePrice/100.00];
    cell.desLabel.text    = [NSString stringWithFormat:@"%@ %@",model.commodityModel,model.commoditySpec];
    cell.amountLabel.text  = [NSString stringWithFormat:@"订单总额:¥%.2f",model.payAmount/100.00];
    if (model.postage > 0) {
        cell.postageLabel.text = [NSString stringWithFormat:@"邮费¥%.2f",model.postage/100.00];
    }else{
        cell.postageLabel.text = @"免运费";
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MIOrderPayAnotherHeader *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MIOrderPayAnotherHeader identify]];

    XKOrderPaymentModel *model = self.dataArray[section];
    head.titleLabel.text = model.merchantName;
    head.subLabel.text   = [NSString stringWithFormat:@"由 %@ 发起",model.buyerNickName];
    head.subLabel.textColor = HexRGB(0xcccccc, 10.0f);
    return head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    MIOrderPayAnotherFooter *foot = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MIOrderPayAnotherFooter identify]];
    if ([foot.button.allTargets containsObject:self] == NO) {
        [foot.button addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    XKOrderPaymentModel *model = self.dataArray[section];
    if (self.status == OSUnPay) {
        foot.button.tag = section;
        [foot reloadTime:model.orderTime anDuration:model.waitPaymentTime];
    }else{
        foot.leftLabel.hidden = NO;
        foot.countDownView.hidden = YES;
        foot.leftLabel.text = model.payTime;
        [foot.button setTitle:@"已代付" forState:UIControlStateNormal];
        [foot.button setEnabled:NO];
    }
    
    return foot;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 101;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 55;
}

- (void)payClick:(UIButton *)sender{
    XKOrderBaseModel *disModel = [XKOrderBaseModel new];
    XKOrderPaymentModel *model = self.dataArray[sender.tag];
    disModel.payAmount = @(model.payAmount);
    disModel.isPayByOthers = YES;
    if (model.couponAmount > 0) {
        disModel.type  = OTWug;
        disModel.deductionCouponAmount = @(model.couponAmount);
    }else{
        disModel.type  = OTGlobalSeller;
        disModel.deductionCouponAmount = @(model.deductionCouponAmount);
    }
    disModel.orderNo      = model.orderNo;
    disModel.goodsName    = model.goodsName;
    [MGJRouter openURL:kRouterPay withUserInfo:@{@"key":disModel} completion:nil];
}

- (void)orderStatusHasUpdate:(NSString *)orderNo andOrderStatus:(XKOrderStatus)orderStaus{
    [self.dataArray enumerateObjectsUsingBlock:^(XKOrderPaymentModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.orderNo isEqualToString:orderNo]) {
            [self.dataArray removeObject:model];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationFade];
            *stop = true;
        }
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [XKUIUnitls safeBottom])];
        _tableView.showsVerticalScrollIndicator  = NO;
        [_tableView registerClass:[MIOrderPayAnotherGoodCell class] forCellReuseIdentifier:[MIOrderPayAnotherGoodCell identify]];
        [_tableView registerClass:[MIOrderPayAnotherHeader class] forHeaderFooterViewReuseIdentifier:[MIOrderPayAnotherHeader identify]];
        [_tableView registerClass:[MIOrderPayAnotherFooter class] forHeaderFooterViewReuseIdentifier:[MIOrderPayAnotherFooter identify]];
        _tableView.ly_emptyView = [XKEmptyView orderListNoDataView];
    }
    return _tableView;
}
@end
