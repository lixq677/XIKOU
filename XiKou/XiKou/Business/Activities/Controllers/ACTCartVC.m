//
//  ACTCartVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTCartVC.h"
#import "XKDiscountGoodMakeOrderVC.h"
#import "MIOrderHeadView.h"
#import "ACTCartCell.h"
#import "XKCartButtonsView.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKActivityCartService.h"
#import "XKActivityService.h"
#import "XKAccountManager.h"
#import "MJDIYHeader.h"

@interface ACTCartVC ()<UITableViewDelegate,UITableViewDataSource,CartCellDetagate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) XKCartButtonsView *bottomView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *selectArray;

@end

static NSString *const cellId = @"ACTCartCell";
static NSString *const headId = @"headId";
@implementation ACTCartVC
{
    CGFloat _payAmount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _selectArray = [NSMutableArray array];
    [self setUI];
    [self getCartData];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    self.title = @"购物车";
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(65+[XKUIUnitls safeBottom]);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    @weakify(self);
    self.bottomView.actionBlock = ^{
        @strongify(self);
        [self creatOrder];
    };
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCartData)];
}

- (void)getCartData{
    [[XKFDataService() cartService]getCartDataByUserId:[XKAccountManager defaultManager].account.userId Complete:^(ACTCartDataResponse * _Nonnull response) {
        if ([response isSuccess]) {
            self.dataArray = response.data.mutableCopy;
            if (self.dataArray.count > 0) {
                [self getGoodDiscountRate];
            }else{
                [self reloadPrice:0 andDiscount:0];
                [self.tableView reloadData];
            }
        }else{
            [response showError];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)getGoodDiscountRate{
    ACTCartStoreModel *model = self.dataArray[0];
    ACTCartGoodModel *gModel = model.list[0];
    [[XKFDataService() actService]getMutilGoodDiscountRateByCommodityId:gModel.commodityId andActivityId:gModel.activityId    Complete:^(ACTMutilBuyDiscountRespnse * _Nonnull response) {
        if ([response isSuccess]) {
            ACTMutilBuyDiscountModel *discountModel = response.data;
            [self.dataArray enumerateObjectsUsingBlock:^(ACTCartStoreModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                for (ACTCartGoodModel *gModel in model.list) {
                    gModel.selectNum   = [gModel.buyerNumber integerValue];
                    gModel.maxNum      = 0;
                    gModel.rateOne     = discountModel.rateOne ? discountModel.rateOne :@5;
                    gModel.rateTwo     = discountModel.rateTwo ? discountModel.rateTwo :@4;
                    gModel.rateThree   = discountModel.rateThree ? discountModel.rateThree :@3;
                    //********  这三个赋值为生成订单做准备  ********//
                    gModel.merchantId  = model.merchantId;
                    gModel.merchantName= model.merchantName;
                    gModel.postage     = model.postage;
                }
            }];
        }else{
            [response showError];
        }
        [self handleData];
    }];
}

- (void)reloadPrice:(CGFloat)price andDiscount:(CGFloat)discount{
    NSString *discountStr = [NSString stringWithFormat:@"优惠 ¥%.2f",discount/100];
    self.bottomView.priceLabel.text  = [NSString stringWithFormat:@"合计 ¥%.2f  %@",price/100,discountStr];
    [self.bottomView.priceLabel setAttributedStringWithSubString:@"¥" font:FontSemibold(13.f)];
    [self.bottomView.priceLabel setAttributedStringWithSubString:discountStr color:COLOR_PRICE_GRAY font:Font(10.f)];
    [self.bottomView.priceLabel setAttributedStringWithSubString:@"合计" color:COLOR_TEXT_BLACK font:Font(12.f)];
}

#pragma mark 创建订单
- (void)creatOrder{
    if (_selectArray.count == 0) {
        XKShowToast(@"请先选择商品");
        return;
    }
    XKDiscountGoodMakeOrderVC *vc = [[XKDiscountGoodMakeOrderVC alloc]initWithGoods:_selectArray];
    vc.totalAmount = _payAmount;
    vc.makeOrderSuccess = ^{
        [self.selectArray removeAllObjects];
        [self getCartData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark uitableview delegate && datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ACTCartStoreModel *model = _dataArray[section];
    return model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ACTCartCell *cell       = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.delegate           = self;
    ACTCartStoreModel *model = _dataArray[indexPath.section];
    ACTCartGoodModel *gModel = model.list[indexPath.row];
    cell.model = gModel;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    MIOrderHeadView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId];
    ACTCartStoreModel *model = _dataArray[section];
    head.titleLabel.text = model.merchantName;

    return head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    
    UIBezierPath *bezierPath;
    CGRect rect = CGRectMake(0, 0, cell.width - 30, cell.height);
    if (indexPath.row == numberOfRows - 1) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(4, 4)];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:rect];
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    cell.contentView.layer.mask = layer;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        ACTCartStoreModel *model = self.dataArray[indexPath.section];
        ACTCartGoodModel *gModel = model.list[indexPath.row];
        [XKLoading showNeedMask:YES];
        [[XKFDataService() cartService]deleteCartGoodById:gModel.id Complete:^(XKBaseResponse * _Nonnull response) {
            [XKLoading dismiss];
            if ([response isSuccess]) {
                [model.list removeObject:gModel];
                if (model.list.count == 0) {
                    [self.dataArray removeObject:model];
                }
                if ([self.selectArray containsObject:gModel]) {
                    [self.selectArray removeObject:gModel];
                }
                [self handleData];
            }else{
                XKShowToast(@"删除失败");
            }
        }];
    }];
    rowAction.backgroundColor = COLOR_TEXT_BROWN;
    NSArray *arr = @[rowAction];
    return arr;
}

#pragma mark cell delegate
- (void)cartSelected:(UITableViewCell *)cell andSelected:(BOOL)isSelected{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ACTCartStoreModel *model = _dataArray[indexPath.section];
    ACTCartGoodModel *gModel = model.list[indexPath.row];
    if (isSelected && (gModel.maxNum == 3 || gModel.maxNum + gModel.selectNum > 3)) {
        XKShowToast(@"最多选择三个产品");
        return;
    }
    if (!isSelected) {
        gModel.selected    = NO;
        [_selectArray removeObject:gModel];
    }else{
        gModel.selected  = YES;
        [_selectArray addObject:gModel];
    }
    [self handleData];
}
- (void)cartNumberUpdate:(UITableViewCell *)cell andNumber:(NSInteger)number complete:(nonnull void (^)(void))complete{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ACTCartStoreModel *model = _dataArray[indexPath.section];
    ACTCartGoodModel *gModel = model.list[indexPath.row];
    [[XKFDataService() cartService]updateCartGoodNumById:gModel.id andNum:number Complete:^(XKBaseResponse * _Nonnull response) {
        if ([response isSuccess]) {
            gModel.selectNum = number;
            if (number == 0 && [self.selectArray containsObject:gModel]) {//商品已选中，数量减为0时移除选中
                gModel.selected  = NO;
                [self.selectArray removeObject:gModel];
            }
            [self handleData];
        }else{
            [response showError];
        }
        complete();
    }];
}
#pragma mark data handle ----
- (void)handleData{
    
    ACTCartGoodModel *gModel;
    NSInteger maxNum = 0;
    CGFloat totalAmount = 0;
    CGFloat totalActivityAmount = 0;
    NSInteger rateIndex = 0;
    // 这里一件商品选多件时，每件的折扣率时不一样的，根据选择顺序来选择折扣率
    for (int i = 0; i<_selectArray.count; i++) {
        gModel = _selectArray[i];
        maxNum += gModel.selectNum;// 后台返回的所有跟价格相关的字段都需要除去100，换算成元，比率都需要除去10
        totalAmount += [gModel.salePrice doubleValue]*gModel.selectNum;
        [gModel.indexs removeAllObjects];
        for (int j = 0; j<gModel.selectNum; j++) {
            if (rateIndex == 0) totalActivityAmount += ([gModel.activityPrice doubleValue] * [gModel.rateOne doubleValue]/10);
            if (rateIndex == 1) totalActivityAmount += ([gModel.activityPrice doubleValue] * [gModel.rateTwo doubleValue]/10);
            if (rateIndex == 2) totalActivityAmount += ([gModel.activityPrice doubleValue] * [gModel.rateThree doubleValue]/10);
            [gModel.indexs addObject:@(rateIndex)];
            rateIndex++;
        }
    }
    for (ACTCartStoreModel *cModel in _dataArray) {
        for (int i = 0; i< cModel.list.count; i++) {
            gModel = cModel.list[i];
            gModel.maxNum = maxNum;
        }
    }
    _payAmount = totalActivityAmount;
    [self reloadPrice:totalActivityAmount andDiscount:totalAmount - totalActivityAmount];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
  
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [XKUIUnitls safeBottom])];
        _tableView.ly_emptyView = [XKEmptyView goodListNoDataView];
        [_tableView registerClass:[ACTCartCell class] forCellReuseIdentifier:cellId];
        [_tableView registerClass:[MIOrderHeadView class] forHeaderFooterViewReuseIdentifier:headId];
    }
    return _tableView;
}

- (XKCartButtonsView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[XKCartButtonsView alloc]init];
    }
    return _bottomView;
}
@end
