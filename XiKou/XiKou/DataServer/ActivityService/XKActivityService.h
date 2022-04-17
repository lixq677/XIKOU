//
//  ACTService.h
//  XiKou
//
//  Created by L.O.U on 2019/7/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKNetworkManager.h"
#import "XKActivityData.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKActivityService : NSObject

/**
 获取活动模块首页数据

 @param completionBlock <#completionBlock description#>
 */
- (void)getActivityHomeDataComplete:(void(^)(ACTHomeRespnse *_Nonnull response))completionBlock;


/**
 缓存里面获取活动模块首页数据

 @return <#return value description#>
 */
- (ACTHomeBaseModel *)activityHomeDataFromCache;

/**
 获取活动下的模块信息(除了全球买手)

 @param type <#type description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getActivityMoudleByActivityType:(XKActivityType)type
                               Complete:(void(^)(ACTMoudleResponse *_Nonnull response))completionBlock;


/**
 从缓存中查找模块数据

 @param activityType <#activityType description#>
 @return <#return value description#>
 */
- (ACTMoudleData *)queryModuleDataFromCache:(XKActivityType)activityType;


/**
 根据分类ID获取商品列表

 @param type 活动类型
 @param categoryId 分类ID
 @param page 页码
 @param limit 每页长度
 @param userId 用户ID
 @param completionBlock <#completionBlock description#>
 */
- (void)getGoodListByActivityType:(XKActivityType)type
                    andCategoryId:(NSString *)categoryId
                          andPage:(NSInteger)page
                         andLimit:(NSInteger)limit
                        andUserId:(NSString *)userId
                         Complete:(void(^)(ACTGoodListRespnse *_Nonnull response))completionBlock;

/**
 根据分类ID获取商品列表 从缓存中获取
 
 @param type 活动类型
 @param categoryId 分类ID
 @param page 页码
 @param limit 每页长度
 @param userId 用户ID
 */
- (NSArray<XKGoodListModel *> *)queryGoodListModelFromCacheByActivityType:(XKActivityType)type
                                                            andCategoryId:(NSString *)categoryId
                                                                  andPage:(NSInteger)page
                                                                 andLimit:(NSInteger)limit
                                                                andUserId:(nullable NSString *)userId;


/**
 查询吾G商品

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryGoodsListForWgWithParams:(ACTGoodsListParams *) params completion:(void (^)(ACTGoodListRespnse * _Nonnull response))completionBlock;


/**
 从缓存中查询全球买手数据

 @return <#return value description#>
 */
- (ACTGlobalHomeModel *)queryGlobalHomeModelFromCache;


/**
 获取全球买手首页数据

 @param completionBlock <#completionBlock description#>
 */
- (void)getGlobalHomePageDataComplete:(void(^)(ACTGlobalHomeRespnse *_Nonnull response))completionBlock;
 

/**
 根据分类ID，升序降序，排序方式获取全球买手商品列表

 @param param <#param description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getGlobalGoodListByClass:(NSDictionary *)param
                        Complete:(void(^)(ACTGoodListRespnse *_Nonnull response))completionBlock;

/**
 获取商品详情
 @param activityGoodId 活动商品ID
 @param activityType 活动类型
 @param userId 活动类型
 @param completionBlock 回调block
 */
- (void)getActivityGoodDetailByActivityGoodId:(NSString *)activityGoodId
                              andActivityType:(XKActivityType)activityType
                                    andUserId:(NSString *)userId
                                     Complete:(void(^)(ACTGoodDetailRespnse *_Nonnull response))completionBlock;


/**
 获取砍立得为你推荐数据

 @param param <#param description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getBargainGoodListByParam:(NSDictionary *)param
                         Complete:(void(^)(ACTGoodListRespnse *_Nonnull response))completionBlock;


/**
 获取砍立得最新上架数据(page, limit)

 @param param <#param description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getBargainNewnestGoodListByParam:(NSDictionary *)param
                                Complete:(void(^)(ACTGoodListRespnse *_Nonnull response))completionBlock;

/**
 砍立得发起砍价

 @param param <#param description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)startBargainByParam:(NSDictionary *)param
                   Complete:(void(^)(ACTBargainRespnse *_Nonnull response))completionBlock;


/**
 用户参与砍价

 @param icon <#icon description#>
 @param name <#name description#>
 @param userId <#userId description#>
 @param ID <#ID description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)userJoinBargainByIcon:(NSString *)icon
                      andName:(NSString *)name
                    andUserId:(NSString *)userId
                        andID:(NSString *)ID
                     Complete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;


/**
 砍立得获取砍价详情
 
 @param commodityId 商品sku ID
 @param activityId 商品绑定活动ID
 @param userId 用户ID
 */
- (void)getBargainDetailByUserId:(NSString *)userId
                   andActivityId:(NSString *)activityId
                  andCommodityId:(NSString *)commodityId
                        Complete:(void(^)(XKBargainInfoRespnse *_Nonnull response))completionBlock;


/**
 获取竞拍活动轮次
 
 @param activityType 活动类型
 */
- (void)getRoundByType:(XKActivityType)activityType
              Complete:(void(^)(ACTRoundRespnse *_Nonnull response))completionBlock;


/**
 通过轮次ID获取轮次竞拍商品列表
 
 @param roundId 轮次 id
 */
- (void)getRoundGoodListByRoundId:(NSString *)roundId
                         Complete:(void(^)(ACTRoundGoodListRespnse *_Nonnull response))completionBlock;


/**
 通过轮次ID获取商品竞拍情况
 
 @param roundId 轮次 id
 */
- (void)getGoodAuctionInfoByRoundId:(NSString *)roundId
                            Complete:(void(^)(ACTGoodAuctionRespnse *_Nonnull response))completionBlock;


/**
 通过活动商品ID和用户ID获取商品竞拍情况
 
 @param activityGoodId 活动商品 id
 @param userId 用户 id
 */
- (void)getGoodAuctionInfoByActivityGoodId:(NSString *)activityGoodId
                                 andUserId:(NSString *)userId
                                  Complete:(void(^)(ACTGoodDetailAuctionRespnse *_Nonnull response))completionBlock;


/**
 通过商品ID获取商品竞拍出价记录
 
 @param activityGoodId 活动商品 id
 */
- (void)getGoodAuctionListByActivityGoodId:(NSString *)activityGoodId
                                  Complete:(void(^)(ACTGoodAuctionRecondRespnse *_Nonnull response))completionBlock;
/**
 商品竞拍出价
 
 @param param 活动商品 id
 */
- (void)postGoodAuctionListByparam:(NSDictionary *)param
                          Complete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

/**
 获取多买多折活动商品列表
 
 @param commodityId 商品skuId
 @param activityId  活动Id
 */
- (void)getMutilGoodDiscountRateByCommodityId:(NSString *)commodityId
                                andActivityId:(NSString *)activityId
                                     Complete:(void(^)(ACTMutilBuyDiscountRespnse *_Nonnull response))completionBlock;


/**
 获取定制拼团商品列表

 @param page <#page description#>
 @param limit <#limit description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getCustomGoodListByPage:(NSInteger)page
                       andLimit:(NSInteger)limit
                       Complete:(void(^)(ACTGoodListRespnse *_Nonnull response))completionBlock;

@end


NS_ASSUME_NONNULL_END
