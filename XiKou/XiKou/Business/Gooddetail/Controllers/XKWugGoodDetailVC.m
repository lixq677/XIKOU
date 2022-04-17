//
//  XKWugGoodDetailVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKWugGoodDetailVC.h"
#import "XKGoodRowTagCell.h"
#import "XKWugGoodInfoCell.h"

@interface XKWugGoodDetailVC ()

@end

@implementation XKWugGoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self reloadBuyButtonTitle];
    // Do any additional setup after loading the view.
}

- (void)reloadData{
    
    XKActivityRulerModel *ruleModel = self.detailModel.baseRuleModel;
    NSString *coupon = nil;
    if (ruleModel.generateType == 1) {
         coupon = [NSString stringWithFormat:@"支付成功后即可获得优惠劵%.2f",[ruleModel.couponValue doubleValue]/100.00];
    }else if(ruleModel.generateType == 2){
         coupon = [NSString stringWithFormat:@"确认收货即可获得优惠劵%.2f",[ruleModel.couponValue doubleValue]/100.00];
    }else{
         coupon = [NSString stringWithFormat:@"即将获得优惠劵%.2f",[ruleModel.couponValue doubleValue]/100.00];
    }
   
    NSString *duration = ruleModel.deliveryDuration ? [NSString stringWithFormat:@"下单后%@小时内发货",ruleModel.deliveryDuration] : @"下单后尽快安排发货";
    NSString *buyLimit = ruleModel.buyLimited ? [NSString stringWithFormat:@"限购数量: %ld",ruleModel.buyLimit] : @"不限购";
    
    self.rowDataArray = @[@{@"tag":coupon},
                          @{@"time":duration},
                          @{@"number":buyLimit},
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
        XKWugGoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKWugGoodInfoCell"];
        if (!cell) {
            cell = [[XKWugGoodInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"XKWugGoodInfoCell"];
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

#pragma mark ---------------------底部购买按钮处理
- (void)reloadBuyButtonTitle{
    [self.btnsView reloadBlackBtnStatus:^(UIButton * _Nonnull button) {
        XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
        if (gModel.stock == 0) {
            [button setTitle:@"已售罄" forState:UIControlStateNormal];
            button.enabled = NO;
        }else{
            button.enabled = self.paySwitchData.buyGift;
            [button setTitle:@"立即抢购" forState:UIControlStateNormal];
        }
    }];
}

- (void)bottomBlackButtonClick{
    XKGoodSkuView *view = [XKGoodSkuView new];
    view.swt = self.paySwitchData.buyGift;
    [view showWithData:self.detailModel andComplete:^(XKGoodSKUModel * _Nonnull skuModel, NSInteger number) {
        [self makeOrderClick:skuModel andNum:number];
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
    makeOrderModel.goodsImageUrl         = skuModel.skuImage ?: gModel.goodsImageUrl;
    makeOrderModel.merchantId            = gModel.merchantId;
    makeOrderModel.consignmentId         = gModel.consignmentId;
    makeOrderModel.originalOrderNo       = gModel.originalId;
    makeOrderModel.goodsPrice            = skuModel.salePrice;
    makeOrderModel.commodityModel        = skuModel.commodityModel;
    makeOrderModel.commoditySpec         = skuModel.commoditySpec;
    makeOrderModel.condition             = skuModel.contition;
    makeOrderModel.commodityQuantity     = @(selectNum);
    makeOrderModel.orderSource           = @1;
    makeOrderModel.buyerId               = [XKAccountManager defaultManager].account.userId;
    makeOrderModel.activityType          = self.detailModel.activityType;
    makeOrderModel.postage               = self.detailModel.baseRuleModel.postage;
    makeOrderModel.deductionCouponAmount = self.detailModel.baseRuleModel.couponValue;
    makeOrderModel.orderAmount           = [makeOrderModel.goodsPrice doubleValue]*selectNum;
    
    CMOrderVC *vc = [[CMOrderVC alloc]initWithModel:makeOrderModel];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
