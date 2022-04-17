//
//  XKOrderManger.m
//  XiKou
//
//  Created by L.O.U on 2019/7/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKOrderManger.h"
#import "XKShareView.h"
#import "XKCustomAlertView.h"

#import "XKWeakDelegate.h"
#import "XKOrderService.h"
#import "XKDataService.h"
#import "XKUserService.h"
#import "MIOrderAlertView.h"
#import "XKShareTool.h"

@interface XKOrderManger ()

@property (nonatomic,strong) XKWeakDelegate *weakDelegates;

@property (nonatomic,strong) XKOrderBaseModel *orderModel;
@end

@implementation XKOrderManger
+ (XKOrderManger *)sharedMange
{
    static XKOrderManger *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[XKOrderManger alloc] init];
    });
    return handler;
}

#pragma mark set delegate
- (void)addWeakDelegate:(id<XKOrderMangerDelegate>)delegate{
    [self.weakDelegates addDelegate:delegate];
}

- (void)removeWeakDelegate:(id<XKOrderMangerDelegate>)delegate{
    [self.weakDelegates removeDelegate:delegate];
}

#pragma mark getter
- (XKWeakDelegate *)weakDelegates{
    if (!_weakDelegates) {
        _weakDelegates = [[XKWeakDelegate alloc] init];
    }
    return _weakDelegates;
}

#pragma mark ---------------------- 业务
- (void)orderListButtonClick:(OrderActionType)type andModel:(nonnull XKOrderBaseModel *)model{
    _orderModel = model;
    switch (type) {
        case OActionPay:  //支付
            if (model.type == OTZeroBuy) {
                @weakify(self);
                [self checkAddressCompletion:^(BOOL valid) {
                    @strongify(self);
                    if (valid) {
                        [self goPay];
                    }
                }];
            }else{
                [self goPay];
            }
            break;
        case OActionCancle: //取消订单
            [self cancleOrder];
            break;
        case OActionDelete: //删除订单
            [self deleteOrder];
            break;
        case OActionSure: //确认收货
            [self sureReceive];
            break;
        case OActionDeliver: //发货
            [self modifyGlobalOrderhandleType:OActionDeliver];
            break;
        case OActionConsign: //寄卖
            [self modifyGlobalOrderhandleType:OActionConsign];
            break;
        case OActionPayForOther://代付
            [self goPayByOther];
            break;
        case OActionExpedite://提醒发货
            [self remindDeliver];
            break;
        case OActionLogistics:
            if (![NSString isNull:model.orderNo]) {
                [MGJRouter openURL:kRouterLogistics withUserInfo:@{@"OrderBaseModel":model} completion:nil];
            }else{
                XKShowToast(@"订单号不能为空");
            }
            break;
        case OActionExtend://延长收货
            [self delayDeliver];
            break;
        case OActionShare:
            [self shareAction];
            break;
        default:
            XKShowToast(@"功能开发中");
            break;
    }
}

- (void)checkAddressCompletion:(void(^)(BOOL valid))completionBlock{
    NSString *addressRef = [self.orderModel receiptAddressRef];
    if ([NSString isNull:addressRef]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.orderModel.orderNo forKey:@"orderNo"];
        [params setObject:@(self.orderModel.type) forKey:@"orderType"];
        XKCustomAlertView *alert = [[XKCustomAlertView alloc] initWithType:CanleAndTitle andTitle:@"提示" andContent:@"请选择地址再付款" andBtnTitle:@"知道了"];
        [alert setSureBlock:^{
            [MGJRouter openURL:kRouterOrderDetail withUserInfo:params completion:nil];
        }];
        [alert show];
        return;
    }
    [XKLoading show];
    [[XKFDataService() orderService] checkIsOutRangeWithOrderAddress:addressRef completion:^(XKBaseResponse * _Nonnull response) {
        [XKLoading dismiss];
        if (response.isSuccess) {
            BOOL valid = [response.data boolValue];
            if (NO == valid) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:self.orderModel.orderNo forKey:@"orderNo"];
                [params setObject:@(self.orderModel.type) forKey:@"orderType"];
                XKCustomAlertView *alert = [[XKCustomAlertView alloc] initWithType:CanleAndTitle andTitle:@"提示" andContent:@"收货地址超出配送范围，请更换收货地址再付款" andBtnTitle:@"知道了"];
                [alert setSureBlock:^{
                    [MGJRouter openURL:kRouterOrderDetail withUserInfo:params completion:nil];
                }];
                [alert show];
                return;
            }
            if (completionBlock) {
                completionBlock(valid);
            }
        }else{
            [response showError];
        }
    }];
}

/*
 *  支付
 */
- (void)goPay{
    XKOrderBaseModel *disModel = [XKOrderBaseModel new];
    
    disModel.type      = self.orderModel.type;
    if (disModel.type == OTDiscount) {
        if ([self.orderModel isMemberOfClass:[XKOrderDetailModel class]]) {
            XKOrderDetailModel *model = (XKOrderDetailModel *)self.orderModel;
            disModel.orderNo   = model.tradeNo;
            disModel.payAmount = model.discountPayAmount;
        }else{
            XKOrderListModel *model = (XKOrderListModel *)self.orderModel;
            disModel.orderNo   = model.tradeNo;
            disModel.payAmount = model.payAmount;
        }
    }else{
        if ([self.orderModel isMemberOfClass:[XKOrderDetailModel class]]) {
            XKOrderDetailModel *model = (XKOrderDetailModel *)self.orderModel;
            disModel.goodsName = model.goodsVo.commodityName;
        }else{
            XKOrderListModel *model = (XKOrderListModel *)self.orderModel;
            disModel.goodsName = model.goodsName;
        }
        disModel.orderNo  = _orderModel.orderNo;
        disModel.payAmount = _orderModel.payAmount;
    }
    disModel.couponAmount = _orderModel.couponAmount;
    disModel.deductionCouponAmount = _orderModel.deductionCouponAmount;
    [MGJRouter openURL:kRouterPay withUserInfo:@{@"key":disModel} completion:nil];
}

/**
 *  删除订单
 */
- (void)deleteOrder{
    XKCustomAlertView *alert = [[XKCustomAlertView alloc]initWithType:CanleAndTitle
                                                             andTitle:@"删除订单"
                                                           andContent:@"确认删除订单吗？"
                                                          andBtnTitle:@"确定"];
    [alert setSureBlock:^{
        [XKLoading showNeedMask:YES];
        [[XKFDataService() orderService]deleteOrderByOrderNo:self.orderModel.orderNo andOrdertype:self.orderModel.type comlete:^(XKBaseResponse * _Nonnull response) {
            [XKLoading dismiss];
            if ([response isSuccess]) {
                [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                    if([delegate respondsToSelector:@selector(orderHasDelete:)]){
                        [delegate orderHasDelete:self.orderModel.orderNo];
                    }
                }];
            }else{
                XKShowToast(@"订单删除失败");
            }
        }];
    }];
    [alert show];
}

/**
 *  取消订单
 */
- (void)cancleOrder{
    [XKLoading showNeedMask:YES];
    [[XKFDataService() orderService]cancleOrderByOrderNo:self.orderModel.orderNo andOrdertype:self.orderModel.type comlete:^(XKBaseResponse * _Nonnull response) {
        [XKLoading dismiss];
        if ([response isSuccess]) {
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(orderStatusHasUpdate:andOrderStatus:)]){
                    [delegate orderStatusHasUpdate:self.orderModel.orderNo andOrderStatus:OSCancle];
                }
            }];
        }else{
            XKShowToast(@"订单取消失败");
        }
    }];
}

/**
 *  提醒发货
 */
- (void)remindDeliver{
    [XKLoading showNeedMask:YES];
    NSString *orderNo ;
    if (self.orderModel.type == OTDiscount) {
        XKOrderListModel *model = (XKOrderListModel *)self.orderModel;
        orderNo  = model.tradeNo;
    }else{
        orderNo  = _orderModel.orderNo;
    }
    [[XKFDataService() orderService]remindDeliverByOrderNo:orderNo andOrderType:self.orderModel.type Comlete:^(XKBaseResponse * _Nonnull response) {
        [XKLoading dismiss];
        if ([response isSuccess]) {
            XKShowToast(@"已提醒卖家尽快发货");
        }else{
//            XKShowToast(@"提醒失败");
        }
    }];
}

/**
 *  延迟收货
 */
- (void)delayDeliver{
    XKCustomAlertView *alert = [[XKCustomAlertView alloc]initWithType:CanleAndTitle
                                                             andTitle:@"提示"
                                                           andContent:@"确认延长收货时间？"
                                                          andBtnTitle:@"确定"];
    alert.sureBlock = ^{
        [XKLoading showNeedMask:YES];
        [[XKFDataService() orderService]delayDeliverByOrderNo:self.orderModel.orderNo andOrderType:self.orderModel.type Comlete:^(XKBaseResponse * _Nonnull response) {
            [XKLoading dismiss];
            if ([response isSuccess]) {
                XKShowToast(@"延迟收货成功");
            }else{
                XKShowToast(@"确认收货失败");
            }
        }];
    };
    [alert show];
}
/**
 *  确认收货
 */
- (void)sureReceive{
//    NSString *content = [NSString stringWithFormat:@"确定收到商品了吗？\n确认后将获得"];
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:content];
//    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",self.orderModel.couponAmount.doubleValue/100.00] attributes:@{NSForegroundColorAttributeName:HexRGB(0xf94119, 1.0f)}];
//    [attri appendAttributedString:attribute];
//    [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@"元优惠券。"]];
    XKCustomAlertView *alert = [[XKCustomAlertView alloc] initWithType: CanleAndTitle andTitle:@"确认收货" andContent:@"确定收到商品了吗?" andBtnTitle:@"确定"];
    alert.sureBlock = ^{
        [XKLoading showNeedMask:YES];
        [[XKFDataService() orderService]sureReceiveByOrderNo:self.orderModel.orderNo andOrdertype:self.orderModel.type comlete:^(XKBaseResponse * _Nonnull response) {
            [XKLoading dismiss];
            if ([response isSuccess]) {
                if (![NSString isNull:response.msg]) {
                    XKShowToast(response.msg);
                }
                [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                    if([delegate respondsToSelector:@selector(orderStatusHasUpdate:andOrderStatus:)]){
                        [delegate orderStatusHasUpdate:self.orderModel.orderNo andOrderStatus:OSComlete];
                    }
                }];
            }else{
                XKShowToast(@"确认收货失败");
            }
        }];
    };
    [alert show];
}

/**
 *  发货 、 寄卖
 */
- (void)modifyGlobalOrderhandleType:(OrderActionType)type{
    
    void(^block)(NSNumber *handleMenthod,XKShareMode shareMode) = ^(NSNumber *handleMenthod,XKShareMode shareMode){
        [XKLoading showNeedMask:YES];
        [[XKFDataService() orderService]modifyGlobalOrderHandleTypeByOrderNo:self.orderModel.orderNo andBuyerId:[XKAccountManager defaultManager].account.userId andProcessingMethod:handleMenthod andShareMode:shareMode comlete:^(XKBaseResponse * _Nonnull response) {
            [XKLoading dismiss];
            if ([response isSuccess]) {
                XKOrderStatus status = type == OActionDeliver ? OSUnDeliver : OSConsign;
                [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                    if([delegate respondsToSelector:@selector(orderStatusHasUpdate:andOrderStatus:)]){
                        [delegate orderStatusHasUpdate:self.orderModel.orderNo andOrderStatus:status];
                    }
                }];
                if (type != OActionDeliver) {
                    if (shareMode == XKShareModeForFriend || shareMode == XKShareModeForAll) {
                        NSString *content = nil;
                        if (shareMode == XKShareModeForAll) {
                            content = @"您的商品已进入寄卖序列中，请耐心等待...";
                        }
                        [[XKShareTool defaultTool] shareWithData:response.data andCallbackModel:nil andTitle:@"分享给好友购买" andContent:content andNeedSina:NO andNeedPhoto:NO];
                    }else{
                        XKCustomAlertView *alert = [[XKCustomAlertView alloc] initWithType:CanleAndTitle andTitle:@"寄卖成功" andAttributeContent:[[NSAttributedString alloc] initWithString:@"您的商品已进入寄卖序列中，请耐心等待..." attributes:@{NSForegroundColorAttributeName:HexRGB(0x9b9b9b, 1.0f),NSFontAttributeName:[UIFont systemFontOfSize:10.0f]}] andBtnTitle:@"知道了" otherBtnTitle:@"去吾G"];
                        [alert setOtherBlock:^{
                            [MGJRouter openURL:kRouterWg];
                        }];
                        [alert show];
                    }
                }
            }else{
                [response showError];
            }
        }];
    };
    
    NSNumber *handleMenthod;
    if (type == OActionDeliver) {
        handleMenthod = @1;
        XKCustomAlertView *alert = [[XKCustomAlertView alloc]initWithType:CanleAndTitle
           andTitle:@"提示"
         andContent:@"确认申请该商品自用收货"
        andBtnTitle:@"确定"];
        alert.sureBlock = ^{
            block(handleMenthod,XKShareModeForNone);
        };
        [alert show];
    }else{
        handleMenthod = @2;
        //content = @"确认申请该商品到吾G网寄卖？";
        MIOrderAlertView *alert= [[MIOrderAlertView alloc] init];
        alert.alwaysSelect1 = NO;//self.orderModel.alwaysSelectMg;
        if (self.orderModel.consignmentType == XKConsignTypeWg) {
            alert.disableWg = NO;
            alert.disableShare = YES;
        }else if (self.orderModel.consignmentType == XKConsignTypeShare){
            alert.disableWg = YES;
            alert.disableShare = NO;
        }else{
            alert.disableWg = NO;
            alert.disableShare = NO;
        }
        [alert setDefaultSelect];
        alert.sureBlock = ^(BOOL select1,BOOL select2){
            if (select1 && select2) {
                block(handleMenthod,XKShareModeForAll);
            }else if (select1 && !select2){
                block(handleMenthod,XKShareModeForDeliver);
            }else if (!select1 && select2){
                block(handleMenthod,XKShareModeForFriend);
            }else{
                
            }
        };
        [alert show];
    }
}
/**
 *  分享
 */
- (void)shareAction{
//    XKShareView *shareView = [[XKShareView alloc]initWithType:ShareUICenter];
//    NSString *content = [NSString stringWithFormat:@"分享给好友"];
//    [shareView showWithTitle:@"请好友帮忙砍一刀吧" andContent:content andNeedPhoto:NO andComplete:^(ShareType type) {
//        
//    }];
}

/**
 找人代付
 */
- (void)goPayByOther{
    XKOrderBaseModel *disModel = [XKOrderBaseModel new];
    disModel.payAmount = _orderModel.payAmount;
    disModel.type      = self.orderModel.type;
    disModel.orderNo   = _orderModel.orderNo;
    disModel.goodsName = _orderModel.goodsName;
    disModel.couponAmount = _orderModel.couponAmount;
    disModel.deductionCouponAmount = _orderModel.deductionCouponAmount;
    disModel.partnerId = _orderModel.partnerId;
    [MGJRouter openURL:kRouterPayByOther withUserInfo:@{@"key":disModel} completion:nil];
}

///**
// *  更改订单状态
// */
//- (void)updateOrderStatusByModel:(MIOrderModel *)model
//                        Complete:(void(^)(MIOrderModel *model))cpmplete;
///**
// *  查看物流
// */
//- (void)lookLogist;
///**
/**
 *  代付
 */


@end
