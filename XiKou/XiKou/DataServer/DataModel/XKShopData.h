//
//  XKShopData.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKUnitls.h"
#import "XKHomeData.h"
#import "XKBaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKShopIndustryData : NSObject <YYModel>

@property (nonatomic,strong) NSNumber *industry1;//行业id

@property (nonatomic,strong) NSString *industryName;//行业id

@property (nonatomic,strong) NSArray<NSString *> *bannerImageList;

@end


@interface XKShopIndustryResponse : XKBaseResponse

@property (nonatomic,strong)NSArray<XKShopIndustryData *> *data;

@end

typedef NS_ENUM(int,XKShopRate) {
    XKShopRateNone      =   0,
    XKShopRateAscend    =   1,
    XKShopRateDescend   =   2,
};

typedef NS_ENUM(int,XKShopPop) {
    XKShopPopNone      =   0,
    XKShopPopAscend    =   1,
    XKShopPopDescend   =   2,
};

@interface XKShopBriefParams : NSObject <YYModel>

@property (nonatomic,strong) NSNumber *industry1;//行业id

@property (nonatomic,strong) NSString  *industryName;//行业名称

@property (nonatomic,assign) XKShopRate rate;//折扣最优排序;1:升序；2：降序 XKShopRate

@property (nonatomic,assign) XKShopPop pop;//人气最旺排序;1:升序；2：降序 XKShopPop

@property (nonatomic,strong) NSNumber *longitude;//经度

@property (nonatomic,strong) NSNumber *latitude;//纬度

@property (nonatomic,strong) NSNumber *page;

@property (nonatomic,strong) NSNumber * limit;

@end


typedef NS_ENUM(int,XKShopImageType) {
    XKShopImageTypeNone         =   0,
    XKShopImageTypeAvatar       =   1,
    XKShopImageTypeBackground   =   2,
    XKShopImageTypeShow         =   3,
};

/**
 商铺图片信息
 */
@interface XKShopImageModel : NSObject <YYModel>

@property (nonatomic,strong) NSString  *createTime;//创建时间

@property (nonatomic,strong) NSString  *id;//主键ID

@property (nonatomic,strong) NSString  *imageUrl;//图片地址

@property (nonatomic,assign) BOOL   isShow;//是否展示店铺图片样式

@property (nonatomic,strong) NSString  *shopId;

@property (nonatomic,assign) XKShopImageType  type;//图片类型;1-头像;2-店铺背景;3-店铺展示

//....本地请求阿里云拿值
@property (nonatomic,assign) CGFloat ImageWidth;

@property (nonatomic,assign) CGFloat ImageHeight;

@end

typedef NS_ENUM(int,XKShopCellStyle) {
    XKShopCellStyleBig      =   0,//一张大图，两张小图
    XKShopCellStyleNomal    =   1,//三张小图
};

/**
 商铺特色服务信息
 */
@interface XKShopServiceModel : NSObject <YYModel>

@property (nonatomic,strong) NSString  *createTime;//创建时间

@property (nonatomic,strong) NSString  *id;//特色服务主键ID

@property (nonatomic,strong) NSNumber  *serviceId;//特色服务ID：12-好停车;13-免预约;14-24小时服务;15-其他服务

@property (nonatomic,strong) NSString  *serviceName;//特色服务名称

@property (nonatomic,strong) NSString  *shopId;//店铺ID

@end

@interface XKShopBriefData : NSObject <YYModel>

@property (nonatomic,strong) NSString  *address;//地址

@property (nonatomic,strong) NSNumber *area;//区

@property (nonatomic,strong) NSNumber  *city;//市

@property (nonatomic,strong) NSNumber  *province;//省

@property (nonatomic,strong) NSString  *desc;//描述

@property (nonatomic,strong) NSNumber  *discountRate;//优惠比例

@property (nonatomic,strong) NSNumber  *distance;//距离

@property (nonatomic,strong) NSString  *endTime;//营业结束时间

@property (nonatomic,strong) NSNumber  *fanCnt;//粉丝数

@property (nonatomic,strong) NSString  *id;//

@property (nonatomic,strong) NSArray<XKShopImageModel *> *imageList;//图片集合

@property (nonatomic,strong) NSNumber  *industry1;//行业

@property (nonatomic,strong) NSString  *industryName;//行业名称

@property (nonatomic,strong) NSNumber  *isFollow;//是否关注商铺（1:已关 0:未关）

@property (nonatomic,strong) NSString  *merchantId;//商家ID

@property (nonatomic,strong) NSString  *mobile;//手机号

@property (nonatomic,strong) NSString  *popCnt;//人气数

@property (nonatomic,strong) NSArray  <XKShopServiceModel *> *serviceList;//特色服务集合

@property (nonatomic,strong) NSString  *shopName;//店铺名称

@property (nonatomic,strong) NSString  *startTime;//营业开始时间

@property (nonatomic,assign) XKShopCellStyle  style;//样式

@end

@interface XKShopBriefResponse : XKBaseResponse

@property (nonatomic,strong)NSArray<XKShopBriefData *> *data;

@end

@interface XKShopDetailResponse : XKBaseResponse

@property (nonatomic,strong)XKShopBriefData *data;

@end


@interface XKShopFollowVoParams : NSObject <YYModel>

@property (nonatomic,strong)NSString *createTime;

@property (nonatomic,strong)NSString *id;

@property (nonatomic,strong)NSString *userId;

@property (nonatomic,strong)NSString *shopId;//店铺ID

@property (nonatomic,assign)BOOL follow;//是否关注（1-已关注；0-未关注）

@end

@interface XKShopOrderParams : NSObject <YYModel>

@property (nonatomic,strong)NSString *buyerId;//买家用户ID
@property (nonatomic,strong)NSNumber *deductionCouponAmount;//抵扣优惠券金额;没有传0
@property (nonatomic,strong)NSNumber *discount;//优惠比例
@property (nonatomic,strong)NSString *merchantId;//商家ID
@property (nonatomic,strong)NSNumber *nonOfferAmount;//不参与优惠金额；没有传0
@property (nonatomic,strong)NSNumber *orderAmount;//订单金额
@property (nonatomic,strong)NSNumber *orderSource;//订单来源 (1: APP 2:公众号 3: 小程序 4：H5
@property (nonatomic,strong)NSNumber *payAmount;//实付金额
@property (nonatomic,strong)NSString *shopId;//店铺ID

@end

@interface XKShopOrderData : NSObject <YYModel>

@property (nonatomic,strong)NSNumber *deductionCouponAmount;//订单优惠券金额
@property (nonatomic,strong)NSString *orderNo;//订单号
@property (nonatomic,strong)NSNumber *nonOfferAmount;//不参与优惠金额；没有传0
@property (nonatomic,strong)NSNumber *orderAmount;//订单金额
@property (nonatomic,strong)NSNumber *payAmount;//实付金额

@end

@interface XKShopOrderResponse : XKBaseResponse

@property (nonatomic,strong)XKShopOrderData *data;

@end

@interface XKShopMyConcernParams : NSObject <YYModel>

@property (nonatomic,strong)NSString *userId;//用户id

@property (nonatomic,strong)NSNumber *page;//page

@property (nonatomic,strong)NSNumber *limit;//

@end

@interface XKShopMyConcernData : NSObject <YYModel>

@property (nonatomic,strong) NSString  *shopImageUrl;//店铺头像

@property (nonatomic,strong) NSString  *id;//店铺ID

@property (nonatomic,strong) NSString  *followTime;//关注时间

@property (nonatomic,strong) NSString  *shopName;//店铺名称

@end


@interface XKShopMyConcernResponse : XKBaseResponse

@property (nonatomic,strong) NSArray<XKShopMyConcernData *> *data;

@end

@interface XKShopSearchParams : NSObject <YYModel>

@property (nonatomic,assign) int page;

@property (nonatomic,assign) int limit;

@property (nonatomic,strong) NSNumber *longitude;//经度

@property (nonatomic,strong) NSNumber *latitude;//纬度

@property (nonatomic,strong) NSString *shopName;

@end

@interface XKShopSearchText: NSObject <YYModel>

@property (nonatomic,strong) NSString *shopName;

@property (nonatomic,strong) NSNumber *timestamp;//时间戳

@end


NS_ASSUME_NONNULL_END


