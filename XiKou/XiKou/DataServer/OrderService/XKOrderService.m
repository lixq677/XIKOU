//
//  XKOrderService.m
//  XiKou
//
//  Created by L.O.U on 2019/7/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKOrderService.h"
#import "XKMakeOrderParam.h"
#import "XKOrderModel.h"
#import "XKOrderData.h"
#import "XKWeakDelegate.h"
#import "XKShareData.h"

@interface XKOrderService ()

@property (nonatomic, strong) XKWeakDelegate *weakDelegates;

@end

@implementation XKOrderService

#pragma mark getter
- (XKWeakDelegate *)weakDelegates{
    if (_weakDelegates == nil) {
        _weakDelegates = [[XKWeakDelegate alloc] init];
    }
    return _weakDelegates;
}

#pragma mark set delegate
- (void)addWeakDelegate:(id<XKOrderServiceDelegate>)delegate{
    [self.weakDelegates addDelegate:delegate];
}

- (void)removeWeakDelegate:(id<XKOrderServiceDelegate>)delegate{
    [self.weakDelegates removeDelegate:delegate];
}


/**
 生成c除多买多折之外的其他订单

 @param model <#model description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)creatNormalOrderWithModel:(XKMakeOrderParam *)model
                          comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    
    NSMutableDictionary *param = @{@"activityGoodsId":model.activityGoodsId ? model.activityGoodsId :@0,
                                   @"activityId":model.activityId ? model.activityId : @0,
                                   @"buyerId":model.buyerId,
                                   @"commodityId":model.commodityId ? model.commodityId : @0,
                                   @"commodityModel":model.commodityModel,
                                   @"commoditySpec":model.commoditySpec,
                                   @"commodityQuantity":model.commodityQuantity,
                                   @"goodsCode":model.goodsCode ? model.goodsCode : @0,
                                   @"goodsId":model.goodsId ? model.goodsId : @0,
                                   @"goodsImageUrl":model.goodsImageUrl ? model.goodsImageUrl : @0,
                                   @"goodsName":model.goodsName ? model.goodsName : @0,
                                   @"merchantId":model.merchantId ? model.merchantId : @0,
                                   @"orderAmount":@(model.orderAmount ? model.orderAmount : 0),
                                   @"orderSource":@1,
                                   @"receiptAddressRef":model.receiptAddressRef,
                                   @"remarks":model.remarks?:@""}.mutableCopy;
    NSString *url;
    if (model.activityType == Activity_Global) {
        url = @"/order/order/createGlobalBuyerOrder";
        [param setObject:model.deductionCouponAmount forKey:@"deductionCouponAmount"];
        [param setObject:model.insteadPay forKey:@"insteadPay"];
        [param setObject:model.payPhone forKey:@"payPhone"];
    }else if (model.activityType == Activity_WG) {
        url = @"/order/order/createConsignmentOrder";
        [param setObject:model.consignmentId forKey:@"consignmentId"];
        [param setObject:model.originalOrderNo forKey:@"originalOrderNo"];
        [param setObject:model.insteadPay forKey:@"insteadPay"];
        [param setObject:model.payPhone forKey:@"payPhone"];
    }else if (model.activityType == Activity_Custom) {
        url = @"/order/order/createGroupOrder";
        [param setObject:model.fightGroupNumber forKey:@"fightGroupNumber"];
    }else if (model.activityType == Activity_ZeroBuy) {
        url = @"/order/order/createAuctionOrder";
        [param setObject:model.commodityAuctionPrice forKey:@"commodityAuctionPrice"];
    }else if (model.activityType == Activity_Bargain) {
        url = @"/order/order/createBargainOrder";
        [param setObject:model.id forKey:@"id"];
        [param setObject:model.salePrice forKey:@"salePrice"];
        [param setObject:model.createType forKey:@"createType"];
    }else if(model.activityType == Activity_NewUser){
        url = @"/order/order/createNewComerOrder";
    }
    request.url   = url;
    request.param = param;
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
            if([delegate respondsToSelector:@selector(creatOrderSuccessComplete)]){
                [delegate creatOrderSuccessComplete];
            }
        }];
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

/**
 生成多买多折订单

 @param activityId <#activityId description#>
 @param totalAmount <#totalAmount description#>
 @param buyerId <#buyerId description#>
 @param goods <#goods description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)creatMutilBuyOrderWithActivityID:(NSString *)activityId
                          andTotalAmount:(CGFloat)totalAmount
                                andBuyid:(NSString *)buyerId
                                andGoods:(NSArray*)goods
                                 comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/order/order/createMoreBuyMoreDiscountOrders";
    request.param       = @{@"activityId":activityId,
                            @"buyerId":buyerId,
                            @"orderSource":@1,
                            @"totalAmount":@(totalAmount),
                            @"buyMoreFoldsVoList":goods,
                            };
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 获取订单列表

 @param type 订单类型，根据type来区分url
 @param param 请求参数，都是一样
 @param completionBlock <#completionBlock description#>
 */
- (void)getOrderListByType:(XKOrderType)type
                  andParam:(NSDictionary *)param
                   comlete:(void(^)(XKOrderListResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType   = XKHttpRequestTypeGet;
    request.param         = param;
    request.responseClass = [XKOrderListResponse class];
    if (type == OTZeroBuy) {
        request.url = @"/order/order/selectAuctionOrderPageToClient";
    }else if (type == OTGlobalSeller) {
        request.url = @"/order/order/selectGlobalBuyerOrderPageToClient";
    }else if (type == OTWug) {
        request.url = @"/order/order/selectConsignmentOrderPageToClient";
    }else if (type == OTCustom) {
        request.url = @"/order/order/selectFightGroupOrderPageToClient";
    }else if (type == OTDiscount) {
        request.url = @"/order/order/selectBuyMoreFoldsOrderPageToClient";
    }else if (type == OTBargain) {
        request.url = @"/order/order/selectBargainOrderPageToClient";
    }else if (type == OTConsigned) {
        request.url = @"/order/order/queryMyConsignmentOrderPageToClient";
    }else if (type == OTNewUser){
        request.url = @"/order/order/selectNewComerOrderPageToClient";
    }
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        XKOrderListResponse *response = (XKOrderListResponse *)result;
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 获取我的寄卖商品

 @param userId <#userId description#>
 @param page <#page description#>
 @param limit <#limit description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getMyMailGoodByUserId:(NSString *)userId
                      andPage:(NSInteger)page
                     andLimit:(NSInteger)limit
                      comlete:(void(^)(XKOrderListResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType   = XKHttpRequestTypeGet;
    request.param         = @{@"page":@(page),@"limit":@(limit)};
    request.responseClass = [XKOrderListResponse class];
    request.url = [NSString stringWithFormat:@"/promotion/promotion/buyGiftCommodity/queryBuyGiftCommodity/%@",userId];
    
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        XKOrderListResponse *response = (XKOrderListResponse *)result;
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 获取我要寄卖订单列表

 @param buyerAccount <#buyerAccount description#>
 @param page <#page description#>
 @param limit <#limit description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getCanConsignOrderByUserId:(NSString *)buyerAccount
                           andPage:(NSInteger)page
                          andLimit:(NSInteger)limit
                           comlete:(void(^)(XKOrderListResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType   = XKHttpRequestTypeGet;
    request.param         = @{@"page":@(page),@"limit":@(limit)};
    request.responseClass = [XKOrderListResponse class];
    request.url = [NSString stringWithFormat:@"/order/order/queryGlobalBuyerConsignmentOrderPage/%@",buyerAccount];
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        XKOrderListResponse *response = (XKOrderListResponse *)result;
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 获取我的寄卖商品

 @param userId <#userId description#>
 @param page <#page description#>
 @param limit <#limit description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getConsignIngByUserId:(NSString *)userId
                      andPage:(NSInteger)page
                     andLimit:(NSInteger)limit
                      comlete:(void(^)(XKConsignGoodResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType   = XKHttpRequestTypeGet;
    request.param         = @{@"page":@(page),@"limit":@(limit)};
    request.responseClass = [XKConsignGoodResponse class];
    request.url = [NSString stringWithFormat:@"/promotion/promotion/buyGiftCommodity/queryBuyGiftCommodity/%@",userId];
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        XKConsignGoodResponse *response = (XKConsignGoodResponse *)result;
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 获取普通订单详情

 @param orderNo <#orderNo description#>
 @param type <#type description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getOrderDetailByOrderNo:(NSString *)orderNo
                        andType:(XKOrderType)type
                        comlete:(void(^)(XKOrderDetailResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType   = XKHttpRequestTypeGet;
    request.responseClass = [XKOrderListResponse class];
    NSString *urlStr = @"";
    if (type == OTZeroBuy) {
        urlStr = @"/order/order/selectAuctionOrderDetailByOrderNoToClient";
    }else if (type == OTGlobalSeller) {
        urlStr = @"/order/order/selectGlobalBuyerOrderDetailByOrderNoToClient";
    }else if (type == OTWug) {
        urlStr = @"/order/order/selectConsignmentOrderDetailByOrderNoToClient";
    }else if (type == OTCustom) {
        urlStr = @"/order/order/selectFightGroupOrderDetailByOrderNoToClient";
    }else if (type == OTBargain) {
        urlStr = @"/order/order/selectBargainOrderDetailByOrderNoToClient";
    }else if(type == OTNewUser){
        urlStr = @"/order/order/selectNewComerOrderDetailByOrderNoToClient";
    }else if (type == OTConsigned){
        urlStr = @"/order/order/selectMyConsignmentOrderDetailByOrderNo";
    }
     request.url = [NSString stringWithFormat:@"%@/%@",urlStr,orderNo];
    request.responseClass = [XKOrderDetailResponse class];
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        XKOrderDetailResponse *response = (XKOrderDetailResponse *)result;
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)getWugLimitBlanceWithUserId:(NSString *)userId comlete:(void (^)(XKWugOderLimitBanalceData * _Nonnull))completionBlock {
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType   = XKHttpRequestTypeGet;
    request.responseClass = [XKWugOderLimitBanalce class];
    request.url = [NSString stringWithFormat:@"/order/order/queryLimitAmount/%@",userId];
    request.responseClass = [XKWugOderLimitBanalceData class];
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        XKWugOderLimitBanalceData *response = (XKWugOderLimitBanalceData *)result;
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}
/**
 获取多买多折订单详情

 @param orderNo <#orderNo description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getMutilOrderDetailByOrderNo:(NSString *)orderNo
                             comlete:(void(^)(XKMutilOrderDetailResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType   = XKHttpRequestTypeGet;
    request.responseClass = [XKOrderListResponse class];
    request.url = [NSString stringWithFormat:@"/order/order/selectBuyMoreFoldsOrderDetailByOrderNoToClient/%@",orderNo];
    request.responseClass = [XKMutilOrderDetailResponse class];
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        XKMutilOrderDetailResponse *response = (XKMutilOrderDetailResponse *)result;
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

#warning 下面三个是废弃接口，统一用统一支付接口
/**
  微信支付支付

 @param paymentAmount 金额
 @param type 订单类型
 @param orderNo 订单编号
 @param userId 用户ID
 @param completionBlock <#completionBlock description#>
 */
- (void)weixinPayByMoney:(NSNumber *)paymentAmount
            andOrderType:(XKOrderType)type
              andOrderNo:(NSString *)orderNo
               andUserId:(NSString *)userId
                 comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/pay/weixinPublic/payJson";
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%.f",a];
    request.param       = @{@"paymentAmount":paymentAmount,
                            @"orderNo":orderNo,
                            @"userId":userId,
                            @"orderType":@(type),
                            @"timestamp":time,
                            @"totalFee":paymentAmount
                            };
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];

}


/**
 支付宝支付支付

 @param orderNo <#orderNo description#>
 @param userId <#userId description#>
 @param type <#type description#>
 @param paymentAmount <#paymentAmount description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)aliPayByOrderNo:(NSString *)orderNo
              andUserId:(NSString *)userId
                andType:(XKOrderType)type
            andPaymount:(NSNumber *)paymentAmount
                comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/pay/aliPayPublic/pay";
    NSDate* dat      = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[dat timeIntervalSince1970];
    NSString *time   = [NSString stringWithFormat:@"%.f",a];
    request.param    = @{@"orderNo":orderNo, //除了订单编号和用户ID，其他的z参数可以没有值，但是字断一定得出传，不然接口会报错
                         @"userId":userId,
                         @"openId":@"",
                         @"paymentAmount":paymentAmount,
                         @"timestamp":time,
                         @"orderType":@(type)
                         };
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
    
}


/**
 红包支付

 @param orderNo 订单编号
 @param userId 用户ID
 @param type 订单类型
 @param paymentAmount 支付金额
 @param payPsd 支付密码
 @param completionBlock <#completionBlock description#>
 */
- (void)redpackgeByOrderNo:(NSString *)orderNo
                 andUserId:(NSString *)userId
                   andType:(XKOrderType)type
               andPaymount:(NSNumber *)paymentAmount
                 andPayPsd:(NSString *)payPsd
                   comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/order/order/order/payRedEnvelope";
    request.param       = @{@"orderNo":orderNo,
                            @"userId":userId,
                            @"payPassword":payPsd,
                            @"paymentAmount":paymentAmount,
                            @"orderType":@(type)
                            };
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 统一支付接口

 @param param <#param description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)orderPayWithParam:(XKOrderPayRequestParam *)param
                  comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/order/payment/uniformPaymentOfOrders";
    request.param       = param;
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

/**
 删除订单

 @param orderNo <#orderNo description#>
 @param orderType <#orderType description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)deleteOrderByOrderNo:(NSString *)orderNo
                andOrdertype:(XKOrderType)orderType
                     comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/order/order/deleteOrder";
    request.param       = @{@"orderNo":orderNo,@"orderType":@(orderType)};
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 取消订单

 @param orderNo <#orderNo description#>
 @param orderType <#orderType description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)cancleOrderByOrderNo:(NSString *)orderNo
                andOrdertype:(XKOrderType)orderType
                     comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/order/order/modifyOrderStateToCanceled";
    request.param       = @{@"orderNo":orderNo,@"orderType":@(orderType)};
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 提醒发货

 @param orderNo <#orderNo description#>
 @param type <#type description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)remindDeliverByOrderNo:(NSString *)orderNo
                  andOrderType:(XKOrderType)type
                       Comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/order/order/modifyRemindShipment";
    request.param       = @{@"orderNo":orderNo,@"orderType":@(type)};
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 延长收货

 @param orderNo <#orderNo description#>
 @param type <#type description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)delayDeliverByOrderNo:(NSString *)orderNo
                 andOrderType:(XKOrderType)type
                      Comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/order/order/extendTheTimeOfReceipt";
    request.param       = @{@"orderNo":orderNo,@"orderType":@(type)};
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

/**
 确认收货

 @param orderNo <#orderNo description#>
 @param orderType <#orderType description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)sureReceiveByOrderNo:(NSString *)orderNo
                andOrdertype:(XKOrderType)orderType
                     comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/order/order/modifyOrderStateToCompleted";
    request.param       = @{@"orderNo":orderNo,@"orderType":@(orderType)};
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 找人代付

 @param orderNo <#orderNo description#>
 @param orderType <#orderType description#>
 @param userId <#userId description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)payByAnotherWithOrderNo:(NSString *)orderNo
                   andOrdertype:(XKOrderType)orderType
                      andUserId:(NSString *)userId
                       andPhone:(NSString *)phone
                        comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/order/order/createInitiatingInsteadOrder";
    request.param       = @{@"orderNo":orderNo,@"orderType":@(orderType),@"userId":userId,@"payPhone":phone};
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (result.isSuccess) {
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(payAnotherApplySuccess:)]){
                    [delegate payAnotherApplySuccess:orderNo];
                }
            }];
        }
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 修改全球买手订单处理方式

 @param orderNo <#orderNo description#>
 @param buyerId <#buyerId description#>
 @param processingMethod 1 发货。 2寄卖
 @param completionBlock <#completionBlock description#>
 */
- (void)modifyGlobalOrderHandleTypeByOrderNo:(NSString *)orderNo
                                  andBuyerId:(NSString *)buyerId
                         andProcessingMethod:(NSNumber *)processingMethod
                                andShareMode:(XKShareMode)shareMode
                     comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/order/order/modifyGlobalBuyerProcessingMethod";
    request.param       = @{@"orderNo":orderNo,
                            @"processingMethod":processingMethod,
                            @"buyerId":buyerId,
                            @"shareModel":@(shareMode)
    };
    request.responseClass = [XKShareResponse class];
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}
- (void)updateCosignStateByOrderNo:(NSString *)orderNo
                        andBuyerId:(NSString *)buyerId
               andProcessingMethod:(NSNumber *)processingMethod
                           comlete:(void (^)(XKBaseResponse * _Nonnull))completionBlock {
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = @"/order/order/modifyBuyGiftOrderProcessingMethod";
    request.param       = @{@"orderNo":orderNo,
                            @"processingMethod":processingMethod,
                            @"buyerId":buyerId};
    request.responseClass = [XKShareResponse class];
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)deliveGoodsById:(NSString *)id
                andShareMode:(XKShareMode)shareMode
                andUserId:(NSString *)userId
                comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url  = @"/promotion/promotion/buyGiftCommodity/shareFriendOrAll";
    request.param  = @{@"id":id?:@"",@"userId":userId?:@"",@"shareModel":@(shareMode)};
    request.responseClass = [XKShareResponse class];
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


/**
 我的寄卖商品排名提升

 @param Id <#Id description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)consignIngGoodPromoteRankById:(NSString *)Id
                              comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url         = [NSString stringWithFormat:@"/promotion/promotion/buyGiftCommodity/increaseRanking/%@",Id];
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
    
}


/**
 OTO订单列表

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryOTOWithParams:(XKOTOParams *)params completion:(void (^)(XKOTOResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/order/order/queryOtoOrderPage/%@",params.buyerAccount];
    request.param = params;
    request.responseClass = [XKOTOResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKOTOResponse *resp = (XKOTOResponse*)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};

/**
 代付订单列表
 
 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryInsteadPaymentWithParams:(XKInsteadPaymentParams *)params completion:(void (^)(XKInsteadPaymentResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/order/order/queryInsteadPaymentOrderPageToClient";
    request.param = params;
    request.responseClass = [XKInsteadPaymentResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKInsteadPaymentResponse *resp = (XKInsteadPaymentResponse*)response;
        if (response.isSuccess) {
            
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};


/// 修改地址
/// @param params <#params description#>
/// @param completionBlock <#completionBlock description#>
- (void)changeOrderAddress:(XKAddOrModifyAddressVoParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/order/order/addOrModifyDeliveryInfo";
    request.param = params;
    request.responseClass = [XKInsteadPaymentResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)checkIsOutRangeWithOrderAddress:(NSString *)addressRef completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/order/order/verifyUserAddressInfo";
    request.param = @{@"addressRef":addressRef};
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];

}


@end




