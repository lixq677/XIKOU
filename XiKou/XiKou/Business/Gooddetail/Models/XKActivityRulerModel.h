//
//  XKActivityRulerModel.h
//  XiKou
//
//  Created by L.O.U on 2019/7/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PersonNum = 1, //按成团人数
    GoodNum,  //按成团件数
} FightGroupType;//拼团类型

typedef enum : NSUInteger {
    BargainByShare = 1, //只允许分享用户帮忙砍价
    BargainWithSelf,    //分享前允许用户给自己砍价
    BargainWithPlatform,//分享前允许平台帮忙砍价

} BargainType;//砍价方式

typedef enum : NSUInteger {
    BargainRandom = 1, //随机
    BargainAverage,    //平均
    BargainDecrease,   //递减
    BargainLastMax,    //最后一个红包最大
} BargainValueWayType;//砍价值计算方式

typedef enum : NSUInteger {
    ConsignmentEnabel = 1, //支持寄卖
    ConsignmentDisabel,    //不支持寄卖
} ConsignmentEnableStyle;

@class BuyUserLimitModel;
@class CommodityPostageModel;
@class ConsignmentModel;
@class ACTGoodAuctionModel;
@class ACTAuctionRecordModel;
@interface XKActivityRulerModel : NSObject<YYModel>

@property (nonatomic, strong) NSNumber * postage;//邮费

@property (nonatomic, strong) NSNumber *deliveryDuration;//下单后最晚发货时长(小时)

@property (nonatomic, assign) BOOL flag;//是否包邮;false-否;true-是

#pragma mark -----------全球买手规则字段
@property (nonatomic, assign) BOOL buyLimited;//是否限购

@property (nonatomic, assign) NSInteger maxLimit;// 最大购买数量

@property (nonatomic, assign) NSInteger minLimit;// 最小购买数量

@property (nonatomic, strong) NSNumber *deductionCouponAmount;//商品可用优惠券金额



#pragma mark -----------砍立得
@property (nonatomic, assign) NSInteger bargainNumber;//参与砍价最大人数、

@property (nonatomic, strong) NSNumber *reservePriceRate;//商品底价占商品原价的百分比(0-100)

//@property (nonatomic, strong) NSNumber *limitNumber;// 限购数量

@property (nonatomic, strong) NSNumber *minRangPrice;//砍价商品销售价最小值

#pragma mark -----------wug
@property (nonatomic, strong) NSNumber *couponValue;//购买商品返回优惠券金额

@property (nonatomic, assign) ConsignmentEnableStyle isConsignment;// 是否支持寄卖(1：支持，2：不支持)

@property (nonatomic, assign) NSInteger consignmentDuration; //最大寄卖天数

@property (nonatomic, assign) NSInteger buyLimit;// 限购数量

@property (nonatomic, assign) NSInteger generateType; //1：支付成功后赠送   2：确认收货后赠送用这个字段;

#pragma mark -----------0元竞拍规则字段
@property (nonatomic, assign) NSInteger expendNumber;//每次消耗数量

@property (nonatomic, assign) NSInteger postponeRange;//每次顺延的秒数

@property (nonatomic, strong) NSNumber *appLoopSeconds;//轮巡时间
#pragma mark -----------定制拼团规则字段
@property (nonatomic, strong) NSNumber *targetNumber;//拼团目标人数/拼团目标件数

@property (nonatomic, assign) FightGroupType fightGroupType;

@end

#pragma mark ------------  竞拍规则信息
typedef enum : NSUInteger {
    Auction_UnBegin = 1, //未开始
    Auction_Begin,       //已开始
    Auction_End,         //已结束
    Auction_Cancle,      //已取消
    Auction_Abortive,    //已流拍
} AuctionStatus;
@class ACTAuctionRecordModel;
@interface ACTGoodAuctionModel : NSObject<YYModel>
@property (nonatomic, assign) NSInteger expendNumber;//每次消耗数量

@property (nonatomic, assign) AuctionStatus status;//拍卖状态

@property (nonatomic, copy)   NSString *statusTitle;//拍卖状态

@property (nonatomic, strong) NSNumber *currentPrice;//当前价格

@property (nonatomic, retain) NSNumber *auctionCommodityId;//

@property (nonatomic, strong) NSNumber *remainingTime;//剩余秒数

@property (nonatomic, strong) NSNumber *finishPrice;//中标价格

@property (nonatomic, strong) NSNumber *recordCount;//出价记录数

@property (nonatomic, assign) NSInteger recordCountForUser;//用户出价记录数

@property (nonatomic, copy) NSString *winerName;//中标用户名称

@property (nonatomic, copy) NSString *winnerId;//中标用户ID

@property (nonatomic, copy) NSString *orderNo;//中标生成订单号

@property (nonatomic, copy) NSArray <ACTAuctionRecordModel *>*recordList;//出价记录

@end


#pragma mark ------------  商品多买多商品折扣model
@interface ACTMutilBuyDiscountModel : NSObject<YYModel>
@property (nonatomic, strong) NSNumber *dividedRatio;//推荐用户参与购买分润比例(百分比)

@property (nonatomic, strong) NSNumber *maxLimit;//最大购买件数

@property (nonatomic, strong) NSNumber *minLimit;//最小购买件数

@property (nonatomic, strong) NSNumber *outDiscountValuationWay;//超出折扣件数计价方式(1：按最后一件折扣计价 2：按商品销售价计价 ）

@property (nonatomic, strong) NSNumber *rateOne;//费率1

@property (nonatomic, strong) NSNumber *rateThree;//费率3

@property (nonatomic, strong) NSNumber *rateTwo;//费率2

@end

NS_ASSUME_NONNULL_END
