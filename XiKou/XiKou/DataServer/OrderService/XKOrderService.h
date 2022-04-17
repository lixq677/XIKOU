//
//  XKOrderService.h
//  XiKou
//
//  Created by L.O.U on 2019/7/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKNetworkManager.h"
#import "XKEnum.h"
#import "XKOrderData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XKOrderServiceDelegate <NSObject>

@optional
- (void)creatOrderSuccessComplete;

- (void)payAnotherApplySuccess:(NSString *)orderNo;

@end

typedef enum : NSUInteger {
    PayOnline = 1, //在线支付
    payCash, //现金支付
} XKPaymentWay;

typedef NS_ENUM(int,XKShareMode) {
    XKShareModeForNone      =   0,
    XKShareModeForFriend    =   1,//分享给好友
    XKShareModeForDeliver   =   2,//寄卖
    XKShareModeForAll       =   3//两者兼有
};

@class XKMakeOrderParam;
@class XKOrderListResponse;
@class XKOrderDetailResponse;
@class XKMutilOrderDetailResponse;
@interface XKOrderService : NSObject

- (void)addWeakDelegate:(id<XKOrderServiceDelegate>)delegate;

- (void)removeWeakDelegate:(id<XKOrderServiceDelegate>)delegate;

/**
 生成除多买多折之外的其他订单
 
 @param model <#model description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)creatNormalOrderWithModel:(XKMakeOrderParam *)model
                          comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

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
                                 comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

/**
 获取订单列表
 
 @param type 订单类型，根据type来区分url
 @param param 请求参数，都是一样
 @param completionBlock <#completionBlock description#>
 */
- (void)getOrderListByType:(XKOrderType)type
                  andParam:(NSDictionary *)param
                   comlete:(void(^)(XKOrderListResponse *_Nonnull response))completionBlock;

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
                           comlete:(void(^)(XKOrderListResponse *_Nonnull response))completionBlock;

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
                      comlete:(void(^)(XKConsignGoodResponse *_Nonnull response))completionBlock;

/**
 获取普通订单详情
 
 @param orderNo <#orderNo description#>
 @param type <#type description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getOrderDetailByOrderNo:(NSString *)orderNo
                        andType:(XKOrderType)type
                        comlete:(void(^)(XKOrderDetailResponse *_Nonnull response))completionBlock;


/**
 获取吾G限额
 */
- (void)getWugLimitBlanceWithUserId:(NSString *)userId
                            comlete:(void(^)(XKWugOderLimitBanalceData *_Nonnull response))completionBlock;

/**
 获取多买多折订单详情
 
 @param orderNo <#orderNo description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getMutilOrderDetailByOrderNo:(NSString *)orderNo
                             comlete:(void(^)(XKMutilOrderDetailResponse *_Nonnull response))completionBlock;

#warning 废弃接口
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
                 comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

#warning 废弃接口
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
                comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;
#warning 废弃接口
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
                   comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

/**
 统一支付接口
 
 @param param <#param description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)orderPayWithParam:(XKOrderPayRequestParam *)param
                  comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;
/**
 删除订单
 
 @param orderNo <#orderNo description#>
 @param orderType <#orderType description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)deleteOrderByOrderNo:(NSString *)orderNo
                andOrdertype:(XKOrderType)orderType
                     comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

/**
 取消订单
 
 @param orderNo <#orderNo description#>
 @param orderType <#orderType description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)cancleOrderByOrderNo:(NSString *)orderNo
                andOrdertype:(XKOrderType)orderType
                     comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

/**
 提醒发货
 
 @param orderNo <#orderNo description#>
 @param type <#type description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)remindDeliverByOrderNo:(NSString *)orderNo
                  andOrderType:(XKOrderType)type
                       Comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

/**
 延长收货
 
 @param orderNo <#orderNo description#>
 @param type <#type description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)delayDeliverByOrderNo:(NSString *)orderNo
                 andOrderType:(XKOrderType)type
                      Comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;
/**
 确认收货
 
 @param orderNo <#orderNo description#>
 @param orderType <#orderType description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)sureReceiveByOrderNo:(NSString *)orderNo
                andOrdertype:(XKOrderType)orderType
                     comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

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
                        comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

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
comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;


/// 修改寄卖订单状态
/// @param orderNo 订单号
/// @param buyerId 卖家ID
/// @param processingMethod 处理方式 1-自提 2-寄卖 3-分享给好友
/// @param completionBlock 回调
- (void)updateCosignStateByOrderNo:(NSString *)orderNo
                        andBuyerId:(NSString *)buyerId
               andProcessingMethod:(NSNumber *)processingMethod
                           comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

- (void)deliveGoodsById:(NSString *)id andShareMode:(XKShareMode)shareMode andUserId:(NSString *)userId comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

/**
 我的寄卖商品排名提升
 
 @param Id <#Id description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)consignIngGoodPromoteRankById:(NSString *)Id
                              comlete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

/**
 OTO订单列表
 
 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryOTOWithParams:(XKOTOParams *)params completion:(void (^)(XKOTOResponse * _Nonnull response))completionBlock;


/*代付订单列表*/
- (void)queryInsteadPaymentWithParams:(XKInsteadPaymentParams *)params completion:(void (^)(XKInsteadPaymentResponse * _Nonnull response))completionBlock;


/// 修改订单地址
/// @param params <#params description#>
/// @param completionBlock <#completionBlock description#>
- (void)changeOrderAddress:(XKAddOrModifyAddressVoParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/// 查询地址是否超出信息
/// @param addressRef <#addressRef description#>
/// @param completionBlock <#completionBlock description#>
- (void)checkIsOutRangeWithOrderAddress:(NSString *)addressRef completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


@end

NS_ASSUME_NONNULL_END
