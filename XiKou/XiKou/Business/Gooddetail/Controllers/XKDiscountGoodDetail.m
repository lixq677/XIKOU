//
//  XKMutilBuyGoodDetail.m
//  XiKou
//
//  Created by L.O.U on 2019/7/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKDiscountGoodDetail.h"
#import "XKGoodRowTagCell.h"
#import "XKDiscountGoodInfoCell.h"

#import "XKActivityCartService.h"

@interface XKDiscountGoodDetail ()

@end

@implementation XKDiscountGoodDetail

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self reloadBuyButtonTitle];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCartCount];
}

- (void)reloadData{
    XKActivityRulerModel *ruleModel = self.detailModel.baseRuleModel;
    NSString *duration = ruleModel.deliveryDuration ? [NSString stringWithFormat:@"下单后%@小时内发货",ruleModel.deliveryDuration] : @"下单后尽快安排发货";
    self.rowDataArray = @[@{@"time":duration}].mutableCopy;
    
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
            button.enabled = self.paySwitchData.moreDisCount;
            [button setTitle:@"加入购物车" forState:UIControlStateNormal];
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
        XKDiscountGoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discountCell"];
        if (!cell) {
            cell = [[XKDiscountGoodInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"discountCell"];
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
    view.swt = self.paySwitchData.moreDisCount;
    [view showWithData:self.detailModel andComplete:^(XKGoodSKUModel * _Nonnull skuModel, NSInteger number) {
        [self addCartClick:skuModel andNum:number];
    }];
}

#pragma mark -------加入购物车
- (void)addCartClick:(XKGoodSKUModel *)skuModel andNum:(NSInteger)selectNum{

    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    
    NSDictionary *param = @{@"activityId":      gModel.activityId,
                            @"activityGoodsId": skuModel.id,
                            @"commodityName":   skuModel.commodityName?:gModel.commodityName,
                            @"goodsId":         gModel.goodsId,
                            @"goodsImageUrl":   skuModel.skuImage?:gModel.goodsImageUrl,
                            @"merchantId":      gModel.merchantId,
                            @"merchantName":    gModel.merchantName,
                            @"salePrice":       skuModel.marketPrice,
                            @"commodityId":     skuModel.commodityId,
                            @"activityPrice":   skuModel.salePrice,
                            @"commoditySpec":   skuModel.commoditySpec  ? skuModel.commoditySpec  : @"",
                            @"commodityModel":  skuModel.commodityModel ? skuModel.commodityModel : @"",
                            @"commodityUnit":   skuModel.goodsUnit  ? skuModel.goodsUnit  : @"",
                            @"buyerNumber":     @(selectNum),
                            @"buyerUserId":     [XKAccountManager defaultManager].account.userId,
                            };
    [[XKFDataService() cartService]mutilGoodAddCart:param Complete:^(XKBaseResponse * _Nonnull response) {
        if ([response isSuccess]) {
            XKShowToast(@"已加入购物车");
            [self getCartCount];
        }else{
            [response showError];
        }
    }];
}

- (void)getCartCount{
    if(![[XKAccountManager defaultManager] isLogin]) {
        return ;
    }
    [[XKFDataService() cartService]getCartDataByUserId:[XKAccountManager defaultManager].account.userId Complete:^(ACTCartDataResponse * _Nonnull response) {
        if ([response isSuccess]) {
            NSInteger number = 0;
            for (ACTCartStoreModel *model in response.data) {
                number += model.list.count;
            }
            self.navView.cartNum = number;
        }
    }];
}

@end
