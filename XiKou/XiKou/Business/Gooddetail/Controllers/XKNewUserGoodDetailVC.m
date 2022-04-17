//
//  XKNewUserGoodDetailVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKNewUserGoodDetailVC.h"
#import "XKGoodRowTagCell.h"
#import "XKNewUserGoodInfoCell.h"

@interface XKNewUserGoodDetailVC ()

@end

@implementation XKNewUserGoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self reloadBuyButtonTitle];
    // Do any additional setup after loading the view.
}

- (void)reloadData{
    
    XKActivityRulerModel *ruleModel = self.detailModel.baseRuleModel;
    NSString *duration = ruleModel.deliveryDuration ? [NSString stringWithFormat:@"下单后%@小时内发货",ruleModel.deliveryDuration] : @"下单后尽快安排发货";
    NSString *buyLimit = ruleModel.buyLimited ? [NSString stringWithFormat:@"限购数量: %ld",ruleModel.buyLimit] : @"不限购";
    
    self.rowDataArray = @[@{@"time":duration},
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
        XKNewUserGoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKNewUserGoodInfoCell"];
        if (!cell) {
            cell = [[XKNewUserGoodInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"XKNewUserGoodInfoCell"];
        }
        if (self.detailModel) cell.detailModel = self.detailModel;
        return cell;
    }else{
        XKGoodRowTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKGoodRowTagCell"];
        if (!cell) {
            cell = [[XKGoodRowTagCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XKGoodRowTagCell"];
        }
        NSDictionary *dic = self.rowDataArray[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:[dic allKeys][0]];
        cell.titleLabel.text = [dic allValues][0];
        return cell;
    }
}

#pragma mark ---------------------底部购买按钮处理
- (void)reloadBuyButtonTitle{
    [self.btnsView reloadBlackBtnStatus:^(UIButton * _Nonnull button) {
        XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
        if (gModel.stock == 0) {
            [button setTitle:@"已售罄" forState:UIControlStateNormal];
            button.enabled = NO;
        }else{
            button.enabled = self.paySwitchData.nwPerson;
            [button setTitle:@"立即抢购" forState:UIControlStateNormal];
        }
    }];
}

- (void)bottomBlackButtonClick{
    XKGoodSkuView *view = [XKGoodSkuView new];
    view.swt = self.paySwitchData.nwPerson;
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
    makeOrderModel.goodsPrice            = skuModel.commodityPrice;
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
