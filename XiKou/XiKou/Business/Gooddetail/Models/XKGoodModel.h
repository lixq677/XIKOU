//
//  XKGoodModel.h
//  XiKou
//
//  Created by L.O.U on 2019/7/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKEnum.h"
#import "XKActivityRulerModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark --------------- 商品基础模型
typedef enum : NSUInteger {
    Saleing,//在售
    Saled,  //售罄
} SaleStatus; //是否在售
typedef enum : NSUInteger {
    Online = 1,//上架
    Offline,   //未上架
} OnlineStatus;//上架状态

typedef enum : NSUInteger {
    BargainDis = 1,//未砍价
    Bargained,     //已砍过价
    BargainIng,    //正在砍价
} BargainStatus;//砍价状态

typedef enum : NSUInteger {
    BargainUn,             //未砍价
    BargainContinue,       //继续砍价
    BargainCanOrder,       //砍价已可以下单（已砍满或者未砍满但达到了购买条件）
    BargainOrder,          //砍价成功已成单未支付
    BargainBuy,            //砍价成功已支付购买
} BargainState;//砍价状态（判断成单状态）


@interface XKGoodListModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *id;//活动与商品绑定的唯一ID(活动商品ID，activityGoodsId 和 id)

@property (nonatomic,copy) NSString *activityId;//活动ID

@property (nonatomic,copy) NSString *commodityId;//商品SKU ID

@property (nonatomic,copy) NSString *commodityName;//活动商品名称

@property (nonatomic,copy) NSString *goodsId;//商品ID

@property (nonatomic,copy) NSString *goodsImageUrl;//商品主图 (详情里面不返回的，在需要用到的地方从imglist里面取)

@property (nonatomic,strong) NSNumber *commodityPrice;//活动价

@property (nonatomic,strong) NSNumber *startPrice;//起拍价，零元拍专用

@property (nonatomic,strong) NSNumber *salePrice;//销售价

@property (nonatomic,strong) NSNumber *marketPrice;//市场价

@property (nonatomic,strong) NSNumber *couponValue;//优惠券面值;吾G活动、全球买手活动展示此字段

@property (nonatomic,strong) NSNumber *deductionCouponAmount;//优惠券面值;吾G活动、全球买手活动展示此字段

@property (nonatomic,strong) NSNumber *discount;//折扣（多买多折标注为最低折扣、砍立得标注为底价折扣、全球买手标注为折扣率2.5-4折）

@property (nonatomic,copy) NSString *bargainCreateTime;//发起砍价时间

@property (nonatomic,assign) NSInteger bargainNumber;//参与砍价最大人数;砍立得活动展示此字段

@property (nonatomic,assign) NSInteger bargainedNum;//已砍价人数;砍立得活动展示此字段

@property (nonatomic,assign) NSInteger bargainCount;//砍价次数

@property (nonatomic,strong) NSNumber *bargainEffectiveTime;//此次砍价有效时长--到分钟

@property (nonatomic,assign) BargainStatus bargainStatus;//砍价状态(砍价整体状态)

@property (nonatomic,assign) BargainState bargainState;//砍价状态（砍价过后用来判断是否成功的字段）

@property (nonatomic,strong) NSNumber *currentPrice;//当前价格

@property (nonatomic,strong) NSNumber *shareAmount;//当前价格

@property (nonatomic,assign) XKActivityType activityType;

//定制拼团时候需要用到
@property (nonatomic,strong) NSNumber *currentFightGroupNum;//当前成团量

@property (nonatomic,strong) NSNumber *targetNumber;//

@property (nonatomic,copy) NSString *categoryId;//分类id

@property (nonatomic,copy) NSString *userId;//userId


//排行榜
@property (nonatomic,strong) NSNumber *couponAmount;//优惠券面值;吾G活动、全球买手活动展示此字段

@property (nonatomic,strong) NSNumber *shareCount;//转发量

@property (nonatomic,strong) NSNumber *saveMoney;//省钱

@property (nonatomic,assign) NSUInteger salesVolume;//销量

//全球买手
@property (nonatomic,strong) NSNumber *commodityPriceOne;//折扣价1

@property (nonatomic,strong) NSNumber *commodityPriceTwo;//折扣价2

@property (nonatomic,strong) NSNumber *commodityPriceThree;//折扣价3

@property (nonatomic,strong) NSNumber *rateThree;

@property (nonatomic,strong) NSNumber *rateTwo;

@property (nonatomic,strong) NSNumber *rateOne;

@property (nonatomic,assign) NSInteger stock;//活动商品库存

@end


@class XKGoodImageModel;
@class XKGoodSKUModel;
@class ACTMutilBuyDiscountModel;
@class XKGoodSKUSpec;
@interface XKGoodModel : XKGoodListModel

@property (nonatomic,copy) NSString *goodsCode;//商品货号

@property (nonatomic,copy) NSString *merchantId;//商家id

@property (nonatomic,copy) NSString *merchantName;//商家名字

@property (nonatomic,copy) NSString *categoryName;//商品分类名称(商品品类)

@property (nonatomic,strong) NSNumber *virtualStock;//活动商品虚拟库存

@property (nonatomic,copy) NSArray <XKGoodImageModel *>*imageList;

@property (nonatomic,copy) NSArray <XKGoodSKUModel *>*skuList;

@property (nonatomic,copy) NSArray <XKGoodSKUSpec *> *models;

//wug时候需要用到
@property (nonatomic,copy) NSString *originalId;//寄卖商品原始订单ID

@property (nonatomic,copy) NSString *consignmentId;//寄卖用户ID

//定制拼团时候需要用到
@property (nonatomic,copy) NSString *endTime;//结束时间

@property (nonatomic, assign) XKConsignType consignmentType;//寄卖规则

@property (nonatomic,strong) NSNumber *biddingNumber;//每次竞价金额变更量(正数：每次递增，负数：每次递减)

@property (nonatomic,strong) ACTGoodAuctionModel *adctionModel;//0元购商品竞拍信息

@property (nonatomic,strong) ACTMutilBuyDiscountModel *discountModel;//多买多折折扣率模型
//砍立得
@property (nonatomic,strong) NSNumber *cutPrice;//可砍金

@property (nonatomic,assign) NSInteger bargainSuccessCount;//砍成功人数
@end

#pragma mark --------------- 商品图片模型
typedef enum : NSUInteger {
    PositionBanner = 1, //轮播图
    PositionDes,       //主图
} GoodImgPosition;
@interface XKGoodImageModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *url;//图片URL地址

@property (nonatomic,strong) NSNumber *rankNum;//图片排序

@property (nonatomic,assign) GoodImgPosition type;
//....本地请求阿里云拿值
@property (nonatomic,assign) CGFloat ImageWidth;

@property (nonatomic,assign) CGFloat ImageHeight;
@end

#pragma mark --------------- 商品Sku模型
@interface XKGoodSKUModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *goodsModel;   //型号

@property (nonatomic,copy) NSString *goodsSpec;    //规格

@property (nonatomic,copy) NSString *goodsUnit;    //单位

@property (nonatomic,copy) NSString *id;           //skuId

@property (nonatomic,strong)NSArray<NSString *> *contition;  //条件

@property (nonatomic,strong)NSString *skuImage;

@property (nonatomic,strong)NSString *categoryName;

@property (nonatomic,strong)NSString *commodityName;

@property (nonatomic,strong)NSString *commodityId;

@property (nonatomic,strong)NSString *commodityModel;

@property (nonatomic,strong)NSNumber *commodityPrice;

@property (nonatomic,strong)NSNumber *marketPrice;

@property (nonatomic,strong) NSNumber *commodityPriceOne;//折扣价1

@property (nonatomic,strong) NSNumber *commodityPriceTwo;//折扣价2

@property (nonatomic,strong) NSNumber *commodityPriceThree;//折扣价3

@property (nonatomic,assign)NSUInteger stock;

@property (nonatomic,strong)NSString *commoditySpec;

@property (nonatomic,strong)NSNumber *salePrice;

@property (nonatomic,assign)NSUInteger virtualStock;

@property (nonatomic,strong)NSNumber *couponValue;//优惠券

@property (nonatomic,strong)NSNumber *deductionCouponAmount;

//砍立得
@property (nonatomic,strong)NSString *bargainCreateTime;//发起砍价时间

@property (nonatomic,strong) NSNumber *bargainEffectiveTimed;//此次砍价有效时长--到分钟

@property (nonatomic,assign) BargainState bargainState;//砍价进度状态;0-未发起砍价;1-继续砍价;2-砍价成功;3-生成订单成功;4-支付成功

@property (nonatomic,assign) BargainStatus bargainStatus;//砍价状态：1：未发起砍价，2：已砍过价，3：正在砍价

@end

@interface XKGoodSKUSpec : NSObject<YYModel>

@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSArray<NSString *> *value;

@end

#pragma mark --------------- 0元抢出价记录模型
@interface ACTAuctionRecordModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *area;//地区

@property (nonatomic, copy) NSString *commodityId;//商品ID

@property (nonatomic, copy) NSString *userId;//竞拍用户ID

@property (nonatomic, copy) NSString *userName;//用户名称

@property (nonatomic, strong) NSNumber *auctionPrice;//竞拍价

@property (nonatomic, strong) NSNumber *currentPrice;//当前价格
@end

NS_ASSUME_NONNULL_END
