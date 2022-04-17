//
//  XKOrderModel.h
//  XiKou
//
//  Created by L.O.U on 2019/7/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN
@interface XKOrderBaseModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *orderNo;//订单号

@property (nonatomic, copy) NSString *merchantName;//店铺名字

@property (nonatomic, strong) NSNumber * payAmount;//实付金额

@property (nonatomic, strong) NSNumber * orderAmount;//订单金额

@property (nonatomic, strong) NSNumber * deductionCouponAmount;//wug赠送优惠券，全球买手消耗优惠券

@property (nonatomic, strong) NSNumber * couponAmount;//wug赠送优惠券

@property (nonatomic, strong) NSNumber * postage;//邮费

@property (nonatomic, assign) BOOL paid;//是否可以找人代付

@property (nonatomic, assign) XKOrderStatus state;//订单状态

@property (nonatomic, assign) XKOrderType type;//订单类型

@property (nonatomic, assign) BOOL isPayByOthers;//是否是代付

@property (nonatomic, copy) NSString *remarks;//订单备注

@property (nonatomic, copy) NSString *receiptAddressRef;//订单信息

//****************  这俩个字段放在父类是为了方便传到支付页面去

@property (nonatomic, copy) NSString *goodsName;//商品名称

@property (nonatomic, copy) NSString *partnerId;//合伙人I

@property (nonatomic, assign) BOOL alwaysSelectMg;//0：不必须选中，1：必须选中）

@property (nonatomic, copy) NSString *scheduleId;//砍价进度id

//****************  自添字段
@property (nonatomic, copy) NSString *statusTitle;//订单状态名字

@property (nonatomic, assign) BOOL bargain;//是否通过砍价购买

@property (nonatomic, assign) XKConsignType consignmentType;//寄卖规则

@end


@interface XKOrderListModel : XKOrderBaseModel

@property (nonatomic, copy) NSString *tradeNo;//多买多折的主订单ID

@property (nonatomic, copy) NSString *commodityModel;//商品型号

@property (nonatomic, copy) NSString *commoditySpec;//商品规格

@property (nonatomic, copy) NSString *goodsImageUrl;//商品图片

@property (nonatomic, copy) NSString *id;//订单ID

@property (nonatomic, copy) NSString *waitConfirmTime;//剩余时间字符串

@property (nonatomic, copy) NSString *payTime;//支付时间

@property (nonatomic, assign) NSInteger timeToBeConfirmed;//全球买手自动发货倒计时(天)

@property (nonatomic, strong) NSNumber *commodityAuctionPrice;//竞拍价

@property (nonatomic, strong) NSNumber *commodityQuantity;//购买数量

@property (nonatomic, strong) NSNumber *commoditySalePrice;//销售价

@property (nonatomic, strong) NSNumber *discountPrice;//折扣价

@property (nonatomic, strong) NSNumber *timesNum;//0元竞拍活动竞拍次数

@property (nonatomic, assign) BOOL isSearchResult;//判断是否是搜索结果，搜索出来的结果如果是多买多折不能在列表页支付，因为出来的是子订单，


@end


@class XKAddressVoData;
@class XKOrderGoodModel;
@interface XKOrderDetailModel : XKOrderListModel

@property (nonatomic, strong) NSNumber *cutPrice;//砍后价

@property (nonatomic, copy) NSString *externalPlatformNo;//交易流水号

@property (nonatomic, copy) NSString * orderTime;//下单时间

@property (nonatomic, copy) NSString * shipTime;//发货时间

@property (nonatomic,strong) NSString *buyerAccount;//买家账号

@property (nonatomic,strong) NSString *buyerHeadImage;//买家头像

@property (nonatomic,strong) NSString *buyerNickName;//买家昵称

@property (nonatomic,strong) NSString *autoDeliveryTime;//自动收货时间

@property (nonatomic, strong) XKOrderGoodModel *goodsVo;//商品信息商品vo对象

@property (nonatomic, strong) NSNumber * payInvalidTime;//支付失效时长

@property (nonatomic, strong) NSString * confirmReceiptTime;//确认收货时间

@property (nonatomic, copy) NSString * lastUpdateTime;//最后更新时间


@property (nonatomic, strong) XKAddressVoData *address;//收货人信息

@property (nonatomic, strong) NSNumber *discountPayAmount;//多买多折订单详情支付金额需要自己累加起来
@end


@interface XKOrderGoodModel : NSObject

@property (nonatomic, copy)   NSString *commodityId;//商品SKUID

@property (nonatomic, copy)   NSString *commodityModel;//商品型号

@property (nonatomic, copy)   NSString *commoditySpec;//商品规格

@property (nonatomic, copy)   NSString *goodsCode;//商品货号

@property (nonatomic, copy)   NSString *goodsId;//商品ID

@property (nonatomic, copy)   NSString *goodsImageUrl;//商品主图Url

@property (nonatomic, copy)   NSString *commodityName;//商品名称

@property (nonatomic, strong) NSNumber *postage;//邮费

@property (nonatomic, strong) NSNumber *commodityQuantity;//购买数量

//@property (nonatomic, assign) XKConsignType consignmentType;//寄卖规则

@end


@interface MIConsigningGoodModel : NSObject

@property (nonatomic, copy) NSString *activityId;//活动ID

@property (nonatomic, copy) NSString *commodityId;//商品id

@property (nonatomic, copy) NSString *commodityModel;//商品型号

@property (nonatomic, copy) NSString *commodityName;//商品名称

@property (nonatomic, copy) NSString *createTime;//创建时间

@property (nonatomic, copy) NSString *goodsId;//商品SPU ID

@property (nonatomic, copy) NSString *goodsImageUrl;//商品图片主图

@property (nonatomic, copy) NSString *id;//主键ID

@property (nonatomic, copy) NSString *marketPrice;//市场价

@property (nonatomic, copy) NSString *merchantName;//商家名称

@property (nonatomic, copy) NSString *originalId;//原始订单ID

@property (nonatomic, copy) NSString *userId;//寄卖用户

@property (nonatomic, copy) NSString *userName;//寄卖用户名称

@property (nonatomic, copy) NSString *commoditySpec;//商品规格

@property (nonatomic, strong) NSNumber *commodityPrice;//活动价

@property (nonatomic, strong) NSNumber *consumptionNum;//消耗次数

@property (nonatomic, strong) NSNumber *consumptionTaskValue;//消耗任务值

@property (nonatomic, strong) NSNumber *costPrice;//成本价

@property (nonatomic, strong) NSNumber *couponValue;//该商品获赠的优惠券面值

@property (nonatomic, strong) NSNumber *priority;//优先级

@property (nonatomic, assign) NSInteger ranking;//当前排名

@property (nonatomic, strong) NSNumber *salePrice;//销售价

@property (nonatomic, strong) NSNumber *shareModel;//分享模式: 1-分享给好友;2-寄卖;3-两者都有

@property (nonatomic, strong) NSNumber *linkExpiredTime;//分享链接失效时间

@property (nonatomic, assign) XKConsignType consignmentType;//寄卖规则

@end


typedef NS_ENUM(int,XKOTOState) {
    XKOTOStateNone      =   0,
    XKOTOStateNoPay     =   1,//待支付
    XKOTOStateFinshed   =   5,//已完成
};
@interface XKOTOData : NSObject <YYModel>

@property (nonatomic,strong) NSString  *address;//详细地址

@property (nonatomic,strong) NSString  *areaName;//区域

@property (nonatomic,strong) NSString  *cityName;//市

@property (nonatomic,strong) NSString  *provinceName;//省份

@property (nonatomic,strong) NSString  *imageUrl;//店铺头像

@property (nonatomic,strong) NSString  *industry1;//店铺类型

@property (nonatomic,strong) NSString  *industryName;//店铺类型名称

@property (nonatomic,strong) NSString  *payTime;//订单时间

@property (nonatomic,strong) NSString  *shopName;//店铺名称

@property (nonatomic,assign) XKOTOState  state;//订单状态 1：待支付， 5：已完成

@property (nonatomic,assign) int32_t  offerAmount;//优惠券支付金额

@property (nonatomic,assign) int32_t  payAmount;//实付支付金额

@property (nonatomic,assign) int32_t  totalAmount;//订单金额

@end

NS_ASSUME_NONNULL_END
