//
//  XKGlobalGoodDetailVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGlobalGoodDetailVC.h"
#import "XKCustomAlertView.h"
#import "XKGoodRowTagCell.h"
#import "XKGlobalGoodInfoCell.h"

#import "XKPropertyService.h"

@interface XKGlobalGoodDetailVC ()

@end

@implementation XKGlobalGoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
  //  [self reloadBuyButtonTitle];
    // Do any additional setup after loading the view.
}

#pragma mark ---------------------底部购买按钮处理
- (void)reloadBuyButtonTitle{
    [self.btnsView reloadBlackBtnStatus:^(UIButton * _Nonnull button) {
        XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
        if (gModel.stock == 0) {
            [button setTitle:@"已售罄" forState:UIControlStateNormal];
            button.enabled = NO;
        }else{
            button.enabled = self.paySwitchData.globerBuyer;
            [button setTitle:@"立即抢购" forState:UIControlStateNormal];
        }
    }];
}

- (void)reloadData{

    XKActivityRulerModel *ruleModel = self.detailModel.baseRuleModel;
    XKGoodModel *goodsModel = [self.detailModel activityCommodityAndSkuModel];
    NSString *duration = ruleModel.deliveryDuration ? [NSString stringWithFormat:@"下单后%@小时内发货",ruleModel.deliveryDuration] : @"下单后尽快安排发货";
    NSString *buyLimit = ruleModel.buyLimited ? [NSString stringWithFormat:@"限购数量: %ld",ruleModel.maxLimit] : @"不限购";
    
    NSString *sellWay = nil;
    if (goodsModel.consignmentType == XKConsignTypeShare) {
        sellWay = @"支持商品分享给朋友";
    }else if (goodsModel.consignmentType == XKConsignTypeWg){
        sellWay = @"支持商品寄卖到吾G";
    }else{
        sellWay = @"支持所有寄卖方式";
    }
    self.rowDataArray = @[@{@"time":duration},
                          @{@"number":buyLimit,},
                          @{@"sellway":sellWay},
                          ].mutableCopy;
    [self reloadBuyButtonTitle];
    [super reloadData];
}

#pragma mark ---------------------tableview
- (NSInteger)numberOfSectionsInTableView{
    return 2;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return self.detailModel.activityCommodityAndSkuModel ? 1 : 0;
    return self.rowDataArray.count;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath andTableView:(nonnull UITableView *)tableView{
    if (indexPath.section == 0) {
        XKGlobalGoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKGlobalGoodInfoCell"];
        if (!cell) {
            cell = [[XKGlobalGoodInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XKGlobalGoodInfoCell"];
        }
        if (self.detailModel) cell.detailModel = self.detailModel;
        return cell;
    }
    
    XKGoodRowTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKGoodRowTagCell"];
    if (!cell) {
        cell = [[XKGoodRowTagCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XKGoodRowTagCell"];
    }
    NSDictionary *dic = self.rowDataArray[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:[dic allKeys][0]];
    cell.titleLabel.text = [dic allValues][0];
    return cell;
}

- (void)bottomBlackButtonClick{
    XKGoodSkuView *view = [XKGoodSkuView new];
    view.swt = self.paySwitchData.globerBuyer;
    [view showWithData:self.detailModel andComplete:^(XKGoodSKUModel * _Nonnull skuModel, NSInteger number) {
        [self checkCoupon:^(BOOL isComplete) {
            if (isComplete) {
                [self makeOrderClick:skuModel andNum:number];
            }else{
                XKCustomAlertView *alert = [[XKCustomAlertView alloc]initWithType:CanleNoTitle
                                                                         andTitle:nil
                                                                       andContent:@"您没有足够的优惠券 前往吾G限时购-购物即获双倍券"
                                                                      andBtnTitle:@"去看看"];
                alert.sureBlock = ^{
                    [MGJRouter openURL:kRouterWg];
                };
                [alert show];
            }
        }];
    }];
}

- (void)checkCoupon:(void(^)(BOOL isComplete))complete{
    NSString *userId = [XKAccountManager defaultManager].account.userId;
    [[XKFDataService() propertyService]getPreferenceAmountWithId:userId completion:^(XKBaseResponse * _Nonnull response) {
        if ([response isSuccess]) {
            CGFloat prefenceSum = [(NSNumber *)response.data intValue];
            if (prefenceSum < [self.detailModel.baseRuleModel.deductionCouponAmount integerValue]) {
                complete(NO);
            }else{
                complete(YES);
            }
        }else{
            [response showError];
        }
    }];
    
}

#pragma mark ---------------------生成订单
- (void)makeOrderClick:(XKGoodSKUModel *)skuModel andNum:(NSInteger)selectNum{
    
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    
    XKMakeOrderParam *makeOrderModel = [XKMakeOrderParam new];
    makeOrderModel.activityGoodsId       = skuModel.id;
    makeOrderModel.activityId            = gModel.activityId;
    makeOrderModel.commodityId           = skuModel.commodityId;
    makeOrderModel.goodsCode             = gModel.goodsCode;
    makeOrderModel.goodsId               = gModel.goodsId;
    makeOrderModel.goodsName             = skuModel.commodityName ?: gModel.commodityName;
    makeOrderModel.merchantId            = gModel.merchantId;
    makeOrderModel.goodsImageUrl         = skuModel.skuImage ?: gModel.goodsImageUrl;
    makeOrderModel.goodsPrice            = skuModel.salePrice;
    makeOrderModel.commodityModel        = skuModel.commodityModel;
    makeOrderModel.commoditySpec         = skuModel.commoditySpec;
    makeOrderModel.condition             = skuModel.contition;
    makeOrderModel.orderAmount           = [skuModel.commodityPrice doubleValue]*selectNum;
    makeOrderModel.commodityQuantity     = @(selectNum);
    makeOrderModel.orderSource           = @1;
    makeOrderModel.buyerId               = [XKAccountManager defaultManager].account.userId;
    makeOrderModel.activityType          = self.detailModel.activityType;
    makeOrderModel.postage               = self.detailModel.baseRuleModel.postage;
    makeOrderModel.deductionCouponAmount = skuModel.deductionCouponAmount;
    makeOrderModel.condition = skuModel.contition;
    CMOrderVC *vc = [[CMOrderVC alloc]initWithModel:makeOrderModel];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
