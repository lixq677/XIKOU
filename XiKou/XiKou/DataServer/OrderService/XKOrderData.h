//
//  XKOrderData.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/26.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKUnitls.h"
#import "XKBaseResponse.h"
#import "XKOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@class XKOrderListData;
@interface XKOrderListResponse : XKBaseResponse

@property (nonatomic, strong) XKOrderListData *data;

@end

@class XKOrderListModel;
@interface XKOrderListData : NSObject

@property (nonatomic, copy) NSArray <XKOrderListModel *>*result;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) NSInteger pageCount;

@end

@class XKOrderDetailModel;
@interface XKOrderDetailResponse : XKBaseResponse

@property (nonatomic, strong) XKOrderDetailModel *data;

@end

@interface XKMutilOrderDetailResponse : XKBaseResponse

@property (nonatomic, strong) NSArray<XKOrderDetailModel *> *data;

@end

@class XKConsigningGoodData;
@interface XKConsignGoodResponse : XKBaseResponse

@property (nonatomic, strong) XKConsigningGoodData *data;

@end

@class MIConsigningGoodModel;
@interface XKConsigningGoodData : NSObject

@property (nonatomic, copy) NSArray <MIConsigningGoodModel *>*result;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) NSInteger pageCount;

@end
@class XKWugOderLimitBanalce;
@interface XKWugOderLimitBanalceData : XKBaseResponse
@property (nonatomic,strong) XKWugOderLimitBanalce *data;
@end
@interface XKWugOderLimitBanalce : NSObject
@property (nonatomic,assign) NSInteger balance;
@property (nonatomic,assign) NSInteger limitAmount;
@property (nonatomic,strong) NSString *expirationTime;
@end

@interface XKOTOParams : NSObject<YYModel>

@property (nonatomic,strong) NSString *buyerAccount;//用户buyerAccount

@property (nonatomic,strong) NSNumber *page;//页码

@property (nonatomic,strong) NSNumber *limit;//每页多少条数据

@end

@interface XKOTOResponse : XKBaseResponse

@property (nonatomic,strong) NSArray<XKOTOData *> *data;

@end

typedef enum : NSUInteger {
    OS_Android = 1,
    OS_Ios,
    OS_H5,
} OsType;
typedef enum : NSUInteger {
    Tencent_TAS = 1, //公众号
    Tencent_MiniApp, //小程序
    App,
} AppType;

typedef enum : NSUInteger {
    Pay_Wx = 1,     //微信
    Pay_Ali,        //支付宝
    Pay_BankCard,   //银行卡
    Pay_Coupon,     //优惠券
    Pay_Redpackge,  //红包
} PayWay;

@interface XKOrderPayRequestParam : NSObject

@property (nonatomic, strong) NSString *clientType;//客户端类型 android、ios、h5，写死为ios

@property (nonatomic, assign) OsType osType;//写死为2

@property (nonatomic, assign) AppType payType;//写死为三

@property (nonatomic, strong) NSString *orderNo;//订单号

@property (nonatomic, assign) PayWay payWay;//支付方式

@property (nonatomic, assign) NSInteger orderType;

@property (nonatomic, strong) NSNumber *paymentAmount;

@property (nonatomic, strong) NSNumber *timestamp;//发起请求时间戳,单位毫秒

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *payPassword;


@end


/**************代付订单数据***************/


/**
 代付订单参数
 */
@interface XKInsteadPaymentParams : NSObject<YYModel>

@property (nonatomic,strong) NSString *buyerAccount;//买家账号(查询代付订单时传代付人账号

/*(订单状态；不传数据-全部;1-待支付;2-待发货;3-待收货;
 4-已取消;5-已完成;6-已关闭;7-待确认;8-待成团;9-成团成功;
 10-拼团失败;11-已寄卖;12-已付款(OTO订单)
 */
@property (nonatomic,assign) XKOrderStatus state;

@property (nonatomic,strong) NSString *searchName;//商品名称/商品编号/订单编号

//创建时间标识;不限：不传值:1：创建时间一个月;2：创建时间最近三个月
@property (nonatomic,strong) NSString *createTimeFlag;

@property (nonatomic,strong) NSString *orderAmountL;//订单金额左区间

@property (nonatomic,strong) NSString *orderAmountR;//订单金额右区间

@property (nonatomic,strong) NSNumber *page;//页码

@property (nonatomic,strong) NSNumber *limit;//每页多少条数据

@end

@interface XKOrderPaymentModel : NSObject <YYModel>

@property (nonatomic,strong) NSString *commodityModel;//商品型号

@property (nonatomic,assign) uint32_t commodityQuantity;//购买数量

@property (nonatomic,assign) uint32_t commoditySalePrice;//销售价

@property (nonatomic,assign) uint32_t waitPaymentTime;//支付时间

@property (nonatomic,strong) NSString *orderTime;//创建时间

@property (nonatomic,strong) NSString *payTime;

@property (nonatomic,strong) NSString *commoditySpec;//商品规格

@property (nonatomic,assign) uint32_t couponAmount;//赠券金额(吾G活动)

@property (nonatomic,assign) uint32_t deductionCouponAmount;//优惠券可抵扣金额(全球买手活动)

@property (nonatomic,strong) NSString *buyerNickName;

@property (nonatomic,strong) NSString *goodsImageUrl;//商品图片

@property (nonatomic,strong) NSString *goodsName;//商品名称

@property (nonatomic,strong) NSString *id;//订单ID

@property (nonatomic,strong) NSString *merchantName;//商家名称

@property (nonatomic,strong) NSString *orderNo;//订单号

@property (nonatomic,assign) BOOL paid;//是否代付;0-否;1-是

@property (nonatomic,strong) NSString *partnerId;//上级合伙人ID

@property (nonatomic,assign) uint32_t payAmount;//应付金额

@property (nonatomic,assign) uint32_t postage;//邮费

@property (nonatomic,assign) XKOrderStatus state;//

@end

/*服务器返回数据*/
@interface XKInsteadPaymentData : NSObject <YYModel>

@property (nonatomic,assign) uint32_t hasPaid;//已代付金额

@property (nonatomic,assign) uint32_t notPaid;//未代付金额

@property (nonatomic,strong) NSArray<XKOrderPaymentModel *> *insteadPaymentOrderPageModels;

@end

@interface XKInsteadPaymentResponse : XKBaseResponse

@property (nonatomic,strong) NSArray<XKInsteadPaymentData *> *data;

@end

@interface XKAddOrModifyAddressVoParams: NSObject <YYModel>

@property (nonatomic,strong)NSString *orderNo;

@property (nonatomic,strong)NSString *receiptAddressRef;

@end


NS_ASSUME_NONNULL_END
