//
//  XKMakeOrderModel.h
//  XiKou
//
//  Created by L.O.U on 2019/7/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN
//除了多买多折，其他生成订单的模型都是直接用这个,多买多折需要封装一个数组，此模型基于商品
@interface XKMakeOrderParam : NSObject <YYModel>

@property (nonatomic, assign) XKActivityType activityType;

@property (nonatomic, strong) NSNumber *postage;//为0说明包邮

@property (nonatomic, copy) NSString * activityGoodsId;//活动商品ID

@property (nonatomic, copy) NSString * activityId;//活动ID

@property (nonatomic, copy) NSString * buyerId;//买家ID

@property (nonatomic, copy) NSString * commodityId;//商品SKUID

@property (nonatomic, copy) NSString * commodityModel;//商品型号

@property (nonatomic, copy) NSString * commoditySpec;//商品规格

@property (nonatomic, copy) NSString * goodsCode;//商品货号

@property (nonatomic, copy) NSString * goodsId;//商品ID

@property (nonatomic, copy) NSString * goodsImageUrl;//商品主图Url

@property (nonatomic, copy) NSString * goodsName;//商品名称

@property (nonatomic, copy) NSString * merchantId;//商家ID

@property (nonatomic, copy) NSString * receiptAddressRef;//收货人信息ID

@property (nonatomic, strong) NSNumber * goodsPrice;//商品价格

@property (nonatomic, strong) NSNumber * orderSource;//订单来源;1: APP 2:公众号 3: 小程序 4：H5

@property (nonatomic, assign) CGFloat orderAmount;//订单金额

@property (nonatomic, strong) NSNumber * deductionCouponAmount;//抵扣优惠券总金额

@property (nonatomic, strong) NSNumber * commodityQuantity;//购买数量

@property (nonatomic, copy) NSString * remarks;//订单

@property (nonatomic, copy) NSString * payPhone;//代付手机号


//************************  wg
@property (nonatomic, copy) NSString * consignmentId;//寄卖用户ID

@property (nonatomic, copy) NSString * originalOrderNo;//寄卖用户原始订单号(全球买手购买商品生成的订单号)

@property (nonatomic, strong) NSNumber *insteadPay;//是否代付，wg和全球买手需要传  0否  1是

//************************  定制拼团
@property (nonatomic, strong) NSNumber *fightGroupNumber;//拼团人数

//************************  0元购
@property (nonatomic, strong) NSNumber *commodityAuctionPrice;//竞拍价;拍中者最后拍出的价格;与订单价格相同

//************************  多买多折 购物车商品序号(1: 第一件 2: 第二件 3: 第三件 ...)
@property (nonatomic, assign) NSInteger orderNo;

@property (nonatomic, strong) NSNumber *discount;//折扣

//************************  砍立得字断
@property (nonatomic, strong) NSNumber *salePrice;//销售价

@property (nonatomic, copy) NSString *id;//户发起砍价主键id

@property (nonatomic, strong) NSNumber *createType;//购买类型：1：单独购买，2：分享砍价购买

@property (nonatomic, copy) NSArray<NSString *> *condition;
@end

@class XKGoodModel;
@interface XKMakeOrderResultModel : NSObject <YYModel>

@property (nonatomic, assign) XKOrderType type;//订单类型

@property (nonatomic, strong) NSString *orderNo;//订单编号

@property (nonatomic, strong) NSString *tradeNo;//多买多折时返回的主订单编号

@property (nonatomic, strong) NSNumber *payAmount;//实付金额

@property (nonatomic, strong) NSNumber *postage;//邮费

@property (nonatomic, strong) XKMakeOrderParam *goods;

@property (nonatomic, strong) NSArray<XKMakeOrderResultModel *> *list;//多买多折时的子订单列表

@property (nonatomic, strong) NSNumber *deductionCouponAmount;//抵扣优惠券总金额

@property (nonatomic, strong) NSNumber *commodityAuctionPrice;//

@property (nonatomic, strong) NSNumber *cutPrice;//砍后价

@end
NS_ASSUME_NONNULL_END
