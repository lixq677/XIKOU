//
//  XKActivityData.h
//  XiKou
//
//  Created by L.O.U on 2019/8/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XKBaseResponse.h"
#import "XKEnum.h"
#import "XKGoodModel.h"
#import "XKBannerData.h"
#import <LKDBHelper.h>

NS_ASSUME_NONNULL_BEGIN
#pragma mark ----------------------- 活动首页
@class ACTHomeBaseModel;
@interface ACTHomeRespnse : XKBaseResponse

@property (nonatomic, strong) ACTHomeBaseModel *data;

@end

@class ACTHomeModel;
@interface ACTHomeBaseModel : NSObject<YYModel>

@property (nonatomic,strong) ACTHomeModel *auctionHomeActivityVo;

@property (nonatomic,strong) ACTHomeModel *globalBuyerHomeActivityVo;

@property (nonatomic,strong) ACTHomeModel *bargainHomeActivityVo;

@property (nonatomic,strong) ACTHomeModel *discountHomeActivityVo;

@end

@interface ACTHomeModel:NSObject<YYModel>

@property (nonatomic, copy) NSString *activityDesc;//活动描述

@property (nonatomic, copy) NSString *activityId;  //活动ID

@property (nonatomic, copy) NSString *activityName;//活动名称

@property (nonatomic, copy) NSString *bannerUrl;//banner

@property (nonatomic, strong) NSNumber *activityType;//活动类型
//全球买手
@property (nonatomic, strong) NSArray<XKGoodListModel *> *globalBuyerCommodityList;
//0元竞拍
@property (nonatomic, strong) NSNumber *auctionCommodityCounts;//竞拍活动商品数量

@property (nonatomic, strong) NSNumber *auctionUserCounts;//正参与竞拍活动用户数量

@property (nonatomic, strong) NSString *endTime;//活动结束时间
//砍立得
@property (nonatomic, strong) NSArray<XKGoodListModel *> *bargainCommodityList;
//多买多折
@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, strong) NSArray *rule;//三个折扣数字
@end

#pragma mark ----------------------- 活动模块信息

@class ACTMoudleData;
@interface ACTMoudleResponse : XKBaseResponse

@property (nonatomic, strong) ACTMoudleData *data;

@end

@class XKBannerData;
@class ACTMoudleModel;
@interface ACTMoudleData : NSObject <YYModel>

@property (nonatomic, copy) NSArray <XKBannerData *> *bannerList;

@property (nonatomic, copy) NSArray <ACTMoudleModel *> *sectionList;

@property (nonatomic, assign) XKActivityType activityType;

@end

@interface ACTMoudleModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *id;//版块ID

@property (nonatomic,copy) NSString *categoryName;//版块名称

@property (nonatomic,copy) NSString *categoryDescribe;//副标题

@property (nonatomic,copy) NSArray <ACTMoudleModel *> *childSectionList;//子板块

@property (nonatomic,strong) NSMutableArray <XKGoodListModel *>*commodityList;//商品数据

@end

#pragma mark ------------------------- 全球买手

@class ACTGlobalHomeModel;
@interface ACTGlobalHomeRespnse : XKBaseResponse

@property (nonatomic, strong) ACTGlobalHomeModel *data;

@end

@class ACTGlobalPlateModel;
@interface ACTGlobalHomeModel : NSObject<YYModel>

@property (nonatomic,copy) NSArray <XKBannerData *> *bannerList;
@property (nonatomic,copy) NSArray <ACTGlobalPlateModel *> *sectionCommodityList;

@end

@class ACTGoodListData;
@interface ACTGlobalPlateModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *categoryId;//版块ID

@property (nonatomic,copy) NSString *categoryName;//版块名称

@property (nonatomic,strong) ACTGoodListData *commodityList;
@end

#pragma mark ---------------------- 分页商品列表

@interface ACTGoodsListParams : NSObject <YYModel>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *sort;

@property (nonatomic, strong,nullable) NSNumber *sortDirect;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger limit;

@end

@class ACTGoodListData;
@interface ACTGoodListRespnse : XKBaseResponse

@property (nonatomic, strong) ACTGoodListData *data;

@end

@interface ACTGoodListData : NSObject <YYModel>

@property (nonatomic, strong) NSMutableArray <XKGoodListModel *> *result;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger pageCount;

@end

#pragma mark -------------------  商品详情

@class ACTGoodDetailModel;

@interface ACTGoodDetailRespnse : XKBaseResponse

@property (nonatomic, strong) ACTGoodDetailModel *data;

@end

@interface ACTGoodDetailModel : NSObject<YYModel>

@property (nonatomic, strong) XKGoodModel *activityCommodityAndSkuModel;

@property (nonatomic, assign) XKActivityType activityType;

@property (nonatomic, strong) XKActivityRulerModel *baseRuleModel;

@property (nonatomic, strong) NSString *officialPictures;

@end

#pragma mark -------------------  0元购竞拍

@class ACTRoundModel;

@interface ACTRoundRespnse : XKBaseResponse

@property (nonatomic, strong) NSArray<ACTRoundModel *> *data;

@end

//  0元购竞拍轮次商品列表
@interface ACTRoundGoodListRespnse : XKBaseResponse

@property (nonatomic, strong) NSArray<XKGoodModel *> *data;

@end

//  0元购商品列表竞拍信息
@class ACTGoodAuctionModel;

@interface ACTGoodAuctionRespnse : XKBaseResponse

@property (nonatomic, strong) NSArray<ACTGoodAuctionModel *> *data;

@end

//  0元购商品详情竞拍信息
@class ACTGoodAuctionModel;

@interface ACTGoodDetailAuctionRespnse : XKBaseResponse

@property (nonatomic, strong) ACTGoodAuctionModel *data;

@end

//  0元购商品详情竞拍出价列表
@class ACTAuctionRecordModel;

@interface ACTGoodAuctionRecondRespnse : XKBaseResponse

@property (nonatomic, strong) NSArray<ACTAuctionRecordModel *> *data;

@end

// 轮次
typedef enum : NSUInteger {
    Round_UnBegin = 1, //未开始
    Round_Fail,        //失效
    Round_End,         //结束
    Round_Ing,         //进行中
} RoundStatus;
@interface ACTRoundModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *endTime;//结束时间

@property (nonatomic, copy) NSString *id;//场次Id

@property (nonatomic, copy) NSString *roundTitle;//场次标题(C端展示用)

@property (nonatomic, copy) NSString *startTime;//开始时间

@property (nonatomic, assign) RoundStatus state;

@property (nonatomic, assign) XKActivityType activityType;

@end

#pragma mark -------------------  多买多折商品折扣率

//  多买多折商品折扣率
@class ACTMutilBuyDiscountModel;
@interface ACTMutilBuyDiscountRespnse : XKBaseResponse

@property (nonatomic, strong) ACTMutilBuyDiscountModel *data;

@end

#pragma mark -------------------  砍立得

//  砍立得发起砍价
@class ACTBargainResponseModel;

@interface ACTBargainRespnse : XKBaseResponse

@property (nonatomic, strong) ACTBargainResponseModel *data;

@end

//  砍立得砍价详情
@class XKBargainInfoModel;

@interface XKBargainInfoRespnse : XKBaseResponse

@property (nonatomic, strong) XKBargainInfoModel *data;

@end

//  砍立得详情

@class ACTBargainRecordModel;

@interface ACTBargainResponseModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *activityId;//活动Id

@property (nonatomic, copy) NSString *address;//用户收货地址ID

@property (nonatomic, copy) NSString *id;//规则Id

@property (nonatomic, copy) NSString *merchantId;//商家Id

@property (nonatomic, copy) NSString *commodityId;//商品skuId

@property (nonatomic, copy) NSString *userId;//砍价发起人Id

@property (nonatomic, copy) NSString *createTime;//发起时间

@property (nonatomic, copy) NSString *updateTime;//修改时间

@property (nonatomic, strong) NSNumber *bargainEffectiveTimed;//时长

@property (nonatomic, copy) NSArray<ACTBargainRecordModel *> *userBargainRecordVoList;//砍价记录列表

@property (nonatomic, strong) NSNumber *bargainCount;//被砍价成功次数

@property (nonatomic, strong) NSNumber *currentPrice;//当前已砍至价格

@property (nonatomic, strong) NSNumber *finalPrice;//最终成交价格

@property (nonatomic, strong) NSNumber *state;//是否成单：1: 未成单 2: 已成单

@end

@interface ACTBargainRecordModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *assistUserHeadImageUrl;//帮砍用户头像url

@property (nonatomic, copy) NSString *assistUserId;//帮砍用户Id

@property (nonatomic, copy) NSString *assistUserName;//帮砍用户昵称

@property (nonatomic, copy) NSString *bargainScheduleId;//砍价进度Id

@property (nonatomic, copy) NSString *createTime;//参与时间

@property (nonatomic, copy) NSString *userId;//砍价发起人Id

@property (nonatomic, strong) NSNumber *bargainPrice;//帮砍价格

@end


NS_ASSUME_NONNULL_END
