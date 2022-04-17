//
//  XKCustomGoodDetailVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKCustomGoodDetailVC.h"
#import "XKGoodRowTagCell.h"
#import "XKCustomGoodInfoCell.h"

@interface XKCustomGoodDetailVC ()

@end

@implementation XKCustomGoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self reloadBuyButtonTitle];
    // Do any additional setup after loading the view.
}

- (void)reloadData{
    
    XKGoodModel *goodModel = self.detailModel.activityCommodityAndSkuModel;
    XKActivityRulerModel *ruleModel = self.detailModel.baseRuleModel;
    NSString *duration = ruleModel.deliveryDuration ? [NSString stringWithFormat:@"下单后发货时间: 成团后%@小时",ruleModel.deliveryDuration] : @"下单后发货时间: 成团后尽快安排发货";
    NSString *saleNum = [NSString stringWithFormat:@"已拼团成功%@件",goodModel.currentFightGroupNum?goodModel.currentFightGroupNum:@0];
    NSString *time = @"离拼团结束时间: 00小时00分00秒";
    self.rowDataArray = @[@{@"tag":saleNum},
                          @{@"waitTime":time},
                          @{@"time":duration},
                          ].mutableCopy;
    [self reloadBuyButtonTitle];
    [super reloadData];
}

- (void)reloadBuyButtonTitle{
    [self.btnsView reloadBlackBtnStatus:^(UIButton * _Nonnull button) {
        XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
        if (gModel.stock == 0) {
            [button setTitle:@"已售罄" forState:UIControlStateNormal];
            button.enabled = NO;
        }else{
            button.enabled = self.paySwitchData.assemble;
            [button setTitle:@"立即抢购" forState:UIControlStateNormal];
        }
    }];
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
        XKCustomGoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[XKCustomGoodInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
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
    if (self.detailModel.activityCommodityAndSkuModel.endTime && indexPath.row == 1) {
        [cell reloadTimeByCreatTime:self.detailModel.activityCommodityAndSkuModel.endTime
                        andDuration:@0
                            andType:Activity_Custom];
    }
    return cell;
}


- (void)bottomBlackButtonClick{
    XKGoodSkuView *view = [XKGoodSkuView new];
    view.swt = self.paySwitchData.assemble;
    [view showWithData:self.detailModel andComplete:^(XKGoodSKUModel * _Nonnull skuModel, NSInteger number) {
        [self makeOrderClick:skuModel andNum:number];
    }];
}


#pragma mark ---------------------生成订单
- (void)makeOrderClick:(XKGoodSKUModel *)skuModel andNum:(NSInteger)selectNum{

    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    
    XKMakeOrderParam *makeOrderModel = [XKMakeOrderParam new];
    
    makeOrderModel.activityGoodsId     = skuModel.id;
    makeOrderModel.activityId          = gModel.activityId;
    makeOrderModel.goodsCode           = gModel.goodsCode;
    makeOrderModel.goodsId             = gModel.goodsId;
    makeOrderModel.merchantId          = gModel.merchantId;
    makeOrderModel.goodsPrice          = skuModel.commodityPrice;
    makeOrderModel.condition           = skuModel.contition;
    makeOrderModel.goodsName           = skuModel.commodityName?:gModel.commodityName;
    makeOrderModel.commodityId         = skuModel.commodityId;
    makeOrderModel.goodsImageUrl       = skuModel.skuImage ?:gModel.goodsImageUrl;
    makeOrderModel.commodityModel      = skuModel.commodityModel;
    makeOrderModel.commoditySpec       = skuModel.commoditySpec;
    makeOrderModel.commodityQuantity   = @(selectNum);
    makeOrderModel.orderSource         = @1;
    makeOrderModel.orderAmount         = [makeOrderModel.goodsPrice doubleValue]*selectNum;
    makeOrderModel.activityType        = self.detailModel.activityType;
    makeOrderModel.postage             = self.detailModel.baseRuleModel.postage;
    makeOrderModel.fightGroupNumber    = self.detailModel.baseRuleModel.targetNumber;
    makeOrderModel.buyerId             = [XKAccountManager defaultManager].account.userId;
    
    CMOrderVC *vc = [[CMOrderVC alloc]initWithModel:makeOrderModel];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
