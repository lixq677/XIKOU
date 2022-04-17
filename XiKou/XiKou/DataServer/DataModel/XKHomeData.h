//
//  XKHomeData.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKUnitls.h"
#import "XKBaseResponse.h"
#import "XKBannerData.h"
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class XKGoodListModel;
/**
 基类，抽出共有参数
 */
@interface XKHomeActivityBaseModel : NSObject<YYModel>

@property (nonatomic,strong) NSString  *activityDesc;//活动描述

@property (nonatomic,strong) NSString  *activityId;//活动id

@property (nonatomic,strong) NSString  *activityName;//活动名称

@property (nonatomic,assign) XKActivityType  activityType;//活动类型

@property (nonatomic,strong) NSString  *bannerUrl;//banner

@end

/*0元抢专区商品Model对象*/
@interface XKHomeAuctionActivityModel : XKHomeActivityBaseModel<YYModel>

@property (nonatomic,strong) NSNumber  *endTime;//活动结束时间

@property (nonatomic,strong) NSArray<XKGoodListModel *>  *homeAuctionCommodityModels;//活动商品

@end


/*砍立得专区商品Model对象*/

@interface XKHomeBargainActivityModel : XKHomeActivityBaseModel<YYModel>

@property (nonatomic,strong) NSArray<XKGoodListModel *>  *homeBargainCommodityModels;//活动商品

@end

/*吾G专区商品Model对象*/

@interface XKHomeBuyGiftActivityModel : XKHomeActivityBaseModel<YYModel>

@property (nonatomic,strong) NSArray<XKGoodListModel *>  *homeBuyGiftCommodityModels;//活动商品

@end


/*多买多折专区商品Model对象*/

@interface XKHomeDiscountActivityModel : XKHomeActivityBaseModel<YYModel>

@property (nonatomic,strong) NSArray<XKGoodListModel *>  *homeDiscountCommodityModels;//活动商品

@end

/*全球买手专区商品Model对象*/
@interface XKHomePageGlobalBuyerActivityModel : XKHomeActivityBaseModel<YYModel>

@property (nonatomic,strong) NSArray<XKGoodListModel *>  *homeGlobalBuyerCommodityModels;//活动商品

@end


@interface XKHomeActivityModel : NSObject <YYModel>

@property (nonatomic,strong) XKHomeAuctionActivityModel  *homeAuctionActivityModel;//0元抢专区商品Model对象

@property (nonatomic,strong) XKHomeBargainActivityModel  *homeBargainActivityModel;//砍立得专区商品Model对象

@property (nonatomic,strong) XKHomeBuyGiftActivityModel  *homeBuyGiftActivityModel;//吾G专区商品Model对象

@property (nonatomic,strong) XKHomeDiscountActivityModel  *homeDiscountActivityModel;//多买多折专区商品Model对象

@property (nonatomic,strong) XKHomePageGlobalBuyerActivityModel  *homePageGlobalBuyerActivityModel;//全球买手专区商品Model对象

@end

@interface XKHomeActivityResponse : XKBaseResponse

@property (nonatomic,strong)XKHomeActivityModel *data;

@end

@interface XKBannerParams : NSObject <YYModel>

@property (nonatomic,assign)XKBannerMoudle moudle;//模块(1: 首页 2: 活动首页 3: 吾G频道)

@property (nonatomic,assign)XKBannerPosition position;//位置(1： 头部BANNER 2： 中部BANNER 3: 活动主图)

@end

@interface XKBannerResponse : XKBaseResponse

@property (nonatomic,strong)NSArray<XKBannerData *> *data;

@end

@class XKGoodListModel;
@interface XKRankResponse : XKBaseResponse

@property (nonatomic,strong)NSArray<XKGoodListModel *> *data;

@end


@interface XKGoodsSearchParams : NSObject <YYModel>

@property (nonatomic,assign) int page;

@property (nonatomic,assign) int limit;

@property (nonatomic,strong,nullable) NSNumber *salesNumFlag;//销量;1-从多到少;2-从少到多

@property (nonatomic,strong,nullable) NSNumber *priceFlag;//价格;1-从多到少;2-从少到多

@property (nonatomic,strong,nullable) NSNumber *nwFlag;//上新;1-从新到旧到少;2-从旧到新

@property (nonatomic,strong) NSString *commodityName;// 商品名称

@end

@interface XKGoodsSearchData : NSObject <YYModel>

@property (nonatomic,assign) XKActivityType activityType;//活动类型(1:买一赠二(吾G)，2: 全球买手, 3：0元竞拍 4:多买多折，5:砍价得红包，6:定制拼团)

@property (nonatomic,strong) NSString *commodityName;//活动商品名称

@property (nonatomic,assign) NSUInteger commodityPrice;

@property (nonatomic,strong) NSString *createTime;//创建时间；

@property (nonatomic,strong) NSString *id;// 活动商品ID

@property (nonatomic,strong) NSString *imageUrl;//商品主图

@property (nonatomic,assign) NSUInteger salePrice;//销售价(划横线的价格)

@property (nonatomic,assign) NSUInteger salesVolume;//销量

@end

@interface XKGoodsSearchResponse : XKBaseResponse <YYModel>

@property (nonatomic,strong) NSArray<XKGoodsSearchData *> *data;//销量

@end

@interface XKGoodsSearchText: NSObject <YYModel>

@property (nonatomic,strong) NSString *commodityName;

@property (nonatomic,strong) NSNumber *timestamp;//时间戳

@end

NS_ASSUME_NONNULL_END

