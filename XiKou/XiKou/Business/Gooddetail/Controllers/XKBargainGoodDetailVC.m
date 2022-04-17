//
//  XKBargainGoodDetailVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBargainGoodDetailVC.h"
#import "ACTBargainDetailVC.h"
#import "MIEditAddressVC.h"
#import "XKChooseAddressPopView.h"
#import "XKCustomAlertView.h"
#import "XKGoodRowTagCell.h"
#import "XKBargainGoodInfoCell.h"
#import "CMOrderVC.h"
#import "NSDate+Extension.h"

#import "XKAddressService.h"
#import "XKBargainInfoModel.h"



@interface XKBargainGoodDetailVC ()<XKAddressServiceDelegate>

@property (nonatomic,strong)NSMutableArray<XKGoodSKUModel *> *bragainSkuModels;


@end

@implementation XKBargainGoodDetailVC

- (void)viewDidLoad { 
    [super viewDidLoad];
    [[XKFDataService() addressService] addWeakDelegate:self];

    self.btnsView.needBrownBtn = YES;
    [self.tableView registerClass:[XKBargainGoodInfoCell class] forCellReuseIdentifier:@"XKBargainGoodInfoCell"];
    [self.tableView registerClass:[XKGoodRowTagCell class] forCellReuseIdentifier:@"XKGoodRowTagCell"];
    [self.tableView registerClass:[XKBargainUserInfoCell class] forCellReuseIdentifier:@"XKBargainUserInfoCell"];

    // Do any additional setup after loading the view.
}


- (void)reloadData{
    
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    XKActivityRulerModel *ruleModel = self.detailModel.baseRuleModel;
    
    NSString *duration = ruleModel.deliveryDuration ? [NSString stringWithFormat:@"下单后%@小时内发货",ruleModel.deliveryDuration] : @"下单后尽快安排发货";
//    已购买数量
   // NSString *buyLimit = [NSString stringWithFormat:@"当前购买: %ld",(long)gModel.salesVolume];

   // NSString *saleNum = [NSString stringWithFormat:@"已有%ld人砍价成功",gModel.bargainSuccessCount];
    NSMutableArray *array = @[
                              @{@"time":duration},
                              //@{@"number":buyLimit},
                              ].mutableCopy;
    NSString *time;
    
    if (gModel.bargainStatus == BargainIng && gModel.bargainState == BargainContinue)
    {
        time = @"离砍价结束时间: 0小时0分0秒";
        
    }else if (gModel.bargainStatus == BargainIng && gModel.bargainState == BargainCanOrder)
    {
        time = @"已砍价成功,前往购买吧";
    }else
    {
        time = [NSString stringWithFormat:@"砍价时长%@小时",gModel.bargainEffectiveTime ? gModel.bargainEffectiveTime : @0];
    }
    
    [array addObject:@{@"waitTime":time}];
    self.rowDataArray = array;
    
    [self reloadBuyButtonTitle];
    [super reloadData];
}

- (void)reloadBuyButtonTitle{
    
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    /*获取需要砍价的SKU*/
    NSMutableArray<XKGoodSKUModel *> *bragainSkuModels = [NSMutableArray array];
    [gModel.skuList enumerateObjectsUsingBlock:^(XKGoodSKUModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.bargainStatus == BargainIng && obj.bargainCreateTime && obj.bargainEffectiveTimed) {
            [bragainSkuModels addObject:obj];
        }
    }];
    self.bragainSkuModels = bragainSkuModels;
    
    @weakify(self);
    [self.btnsView reloadBlackBtnStatus:^(UIButton * _Nonnull button) {
        @strongify(self);
        if (gModel.stock == 0) {
            [button setTitle:@"已售罄" forState:UIControlStateNormal];
            button.enabled = NO;
        }else{
            button.enabled = self.paySwitchData.bargin;
            [button setTitle:@"我要砍价" forState:UIControlStateNormal];
        }
    }];
    //@weakify(self);
    [self.btnsView reloadBrownBtnTitle:^(UIButton * _Nonnull button) {
        @strongify(self);
        button.enabled = self.paySwitchData.bargin;
        NSString *price = [NSString stringWithFormat:@"￥%.2f",[gModel.salePrice floatValue]/100];
        NSString *title = [NSString stringWithFormat:@"%@\n单独购买",price];
        [button setTitle:title forState:UIControlStateNormal];
        //[button setBackgroundImage:[UIImage imageWithColor:HexRGB(0x999999, 1.0f)] forState:UIControlStateDisabled];
        [button.titleLabel setAttributedStringWithSubString:price font:Font(11.f)];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        if (button.enabled && gModel.stock == 0) {
            button.enabled = NO;
        }
    }];
}

#pragma mark ---------------------tableview
- (NSInteger)numberOfSectionsInTableView{
    if (self.bragainSkuModels.count) {
        return 3;
    }else{
        return 2;
    }
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.detailModel.activityCommodityAndSkuModel ? 1 : 0;
    }else if(section == 1){
        return self.rowDataArray.count;
    }else{
        return self.bragainSkuModels.count;
    }
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath andTableView:(nonnull UITableView *)tableView{
    if (indexPath.section == 0) {
        XKBargainGoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKBargainGoodInfoCell" forIndexPath:indexPath];
        if (self.detailModel) cell.detailModel = self.detailModel;
        return cell;
    }else if (indexPath.section == 1){
        XKGoodRowTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKGoodRowTagCell" forIndexPath:indexPath];
        NSDictionary *dic = self.rowDataArray[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:[dic allKeys][0]];
        cell.titleLabel.text = [dic allValues][0];
        if (self.detailModel.activityCommodityAndSkuModel.bargainState == BargainContinue && indexPath.row == 2) {
            [cell reloadTimeByCreatTime:self.detailModel.activityCommodityAndSkuModel.bargainCreateTime
                            andDuration:self.detailModel.activityCommodityAndSkuModel.bargainEffectiveTime
                                andType:Activity_Bargain];
        }
        return cell;
    }else{
        XKBargainUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKBargainUserInfoCell" forIndexPath:indexPath];
        XKGoodSKUModel *model = [self.bragainSkuModels objectAtIndex:indexPath.row];
        NSMutableString *string = [NSMutableString string];
        [model.contition enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![NSString isNull:string]) {
                [string appendString:@", "];
            }
            [string appendString:obj];
        }];
        cell.textLabel.text = string;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.skuImage] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
       // cell.detailTextLabel.text = [NSString stringWithFormat:@"砍价时长%@小时",model.bargainEffectiveTimed ? model.bargainEffectiveTimed : @0];
        cell.separatorInset = UIEdgeInsetsMake(0, 30, 0, 30);
       // @weakify(self);
        @weakify(cell);
        NSDate *date = [NSDate date:model.bargainCreateTime WithFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval dateTime =[date timeIntervalSince1970];
        NSDate *expiredDate = [NSDate dateWithTimeIntervalSince1970:dateTime + model.bargainEffectiveTimed.intValue * 3600];
        
        __block RACDisposable *disposable = [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:[cell.rac_willDeallocSignal merge:cell.rac_prepareForReuseSignal]] subscribeNext:^(NSDate * _Nullable x) {
                           NSLog(@"%@",x);
            @strongify(cell);
           // @strongify(self);
            NSTimeInterval interval = [x timeIntervalSince1970];
            NSTimeInterval expired = [expiredDate timeIntervalSince1970];
            if(expired <= interval){
                [disposable dispose];
                cell.detailTextLabel.text = @"剩余: 00: 00: 00";
                [self dataRequest];
            }else{
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSCalendarUnit type =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
                NSDateComponents *cmps = [calendar components:type fromDate:x toDate:expiredDate options:0];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"剩余:%02ld:%02ld:%02ld",(long)cmps.hour,(long)cmps.minute,(long)cmps.second];
            }
        }];
        @weakify(self);
        [[[cell.button rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:[cell.rac_willDeallocSignal merge:cell.rac_prepareForReuseSignal]] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self continueBargainWithSkuModel:model];
        }];
        
        return cell;
    }
}

- (void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 底部按钮
- (void)bottomBlackButtonClick{
    
    //XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    XKGoodSkuView *view = [XKGoodSkuView new];
    view.swt = self.paySwitchData.bargin;
    view.from = XKSKUFromBargainBuy;
    [view showWithData:self.detailModel andComplete:^(XKGoodSKUModel * _Nonnull skuModel, NSInteger number) {
        if (skuModel.bargainStatus == BargainIng){
            [self continueBargainWithSkuModel:skuModel];
        }else{
            [self bargainWithSkuModel:skuModel];
        }
    }];
}

- (void)bottomBrownButtonClick{
    XKGoodSkuView *view = [XKGoodSkuView new];
    view.swt = self.paySwitchData.bargin;
    [view showWithData:self.detailModel andComplete:^(XKGoodSKUModel * _Nonnull skuModel, NSInteger number) {
        [self buyWithSkuModel:skuModel];
    }];
}

- (void)buyWithSkuModel:(XKGoodSKUModel *)skuModel{
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
    makeOrderModel.goodsPrice            = skuModel.salePrice;
    makeOrderModel.salePrice             = skuModel.salePrice;
    makeOrderModel.commodityModel        = skuModel.commodityModel;
    makeOrderModel.commoditySpec         = skuModel.commoditySpec;
    makeOrderModel.condition             = skuModel.contition;
    makeOrderModel.orderSource           = @1;
    makeOrderModel.commodityQuantity     = @1;
    makeOrderModel.buyerId               = [XKAccountManager defaultManager].account.userId;
    makeOrderModel.postage               = self.detailModel.baseRuleModel.postage;
    makeOrderModel.activityType          = self.detailModel.activityType;
    makeOrderModel.createType            = @1;
    makeOrderModel.orderAmount           = [makeOrderModel.goodsPrice doubleValue];
    CMOrderVC *vc = [[CMOrderVC alloc]initWithModel:makeOrderModel];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -------砍价
- (void)bargainWithSkuModel:(XKGoodSKUModel *)skuModel{
    
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    if (gModel.skuList.count == 0) {
        XKShowToast(@"商品信息错误");
        return;
    }
    NSDictionary *param = @{@"id":skuModel.id,
                            @"merchantId":gModel.merchantId,
                            @"activityId":gModel.activityId,
                            @"commodityId":skuModel.commodityId,
                            @"userId":[XKAccountManager defaultManager].account.userId
                            };
    [[XKFDataService() actService]startBargainByParam:param Complete:^(ACTBargainRespnse * _Nonnull response) {
        if ([response isSuccess]) {
            XKShowToast(@"发起砍价成功");
            self.detailModel.activityCommodityAndSkuModel.bargainCreateTime = response.data.createTime;
            self.detailModel.activityCommodityAndSkuModel.bargainEffectiveTime = response.data.bargainEffectiveTimed;
            [self dataRequest];
            [self continueBargainWithSkuModel:skuModel];
            if (self.bargainSuccess) {
                self.bargainSuccess();
            }
        }else{
            [response showError];
        }
    }];
}

#pragma mark --------- 看详情
- (void)continueBargainWithSkuModel:(XKGoodSKUModel *)skuModel{
    ACTBargainDetailVC *vc = [ACTBargainDetailVC new];
    vc.detailModel = self.detailModel;
    vc.skuModel = skuModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark addAddress delegate
- (void)addAddressWithSevice:(XKAddressService *)service address:(XKAddressVoData *)data{
    [self bottomBlackButtonClick];
}

- (void)dealloc{
    [[XKFDataService() addressService] removeWeakDelegate:self];
}

@end
