//
//  XKShopService.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKShopData.h"

NS_ASSUME_NONNULL_BEGIN

@class XKShopService;

@protocol XKShopServiceDelegate <NSObject>
@optional

- (void)concernShopWithService:(XKShopService *)service param:(XKShopFollowVoParams *)param;

@end

@interface XKShopService : NSObject


/**
 查询商铺分类

 @param completionBlock 回调
 */
- (void)queryShopIndustryWithCompletion:(void (^)(XKShopIndustryResponse * _Nonnull response))completionBlock;



/**
 查询商铺信息

 @param briefParams <#briefParams description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryShopBriefWithShopBriefParams:(XKShopBriefParams *) briefParams completion:(void (^)(XKShopBriefResponse * _Nonnull response))completionBlock;


/**
 从本地缓存中查找数据

 @param briefParams <#briefParams description#>
 @return <#return value description#>
 */
-(NSArray<XKShopBriefData *> *)queryShopBriefFromCacheWithShopBriefParams:(XKShopBriefParams *)briefParams;


/**
 请求店铺详情

 @param shopId <#shopId description#>
 @param userId <#userId description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryShopDetailWithShopId:(NSString *)shopId userId:(NSString *)userId completion:(void (^)(XKShopDetailResponse * _Nonnull response))completionBlock;

/**
 从缓存中查找商品分类

 @return <#return value description#>
 */
- (NSArray<XKShopIndustryData *> *)queryShopIndustryFromCache;


/**
 设置关注店铺

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)setConcernShopWithParams:(XKShopFollowVoParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 创建商铺订单

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)createOTOOrderWithParams:(XKShopOrderParams *)params  completion:(void (^)(XKShopOrderResponse * _Nonnull response))completionBlock;


/**
 查询我关注的商铺

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryShopesOfMyConcernParams:(XKShopMyConcernParams *)params completion:(void (^)(XKShopMyConcernResponse * _Nonnull response))completionBlock;



/**
 搜索店铺

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)searchShopWithParams:(XKShopSearchParams *)params completion:(void (^)(XKShopBriefResponse * _Nonnull response))completionBlock;

/**
 从缓存中查找我关注的店铺

 @param params <#params description#>
 @return <#return value description#>
 */
- (NSArray<XKShopMyConcernData *> *)queryShopesOfMyConcernFromCache:(XKShopMyConcernParams *)params;


/**
 查询搜索历史

 @return <#return value description#>
 */
- (NSArray<XKShopSearchText *> *)searchLastKeywordFromCache;

/*存储搜索历史*/
- (void)saveKeyworkdToCache:(NSString *)keyword;

- (void)deleteKeywordFromCache;

- (void)addWeakDelegate:(id<XKShopServiceDelegate>)delegate;

- (void)removeWeakDelegate:(id<XKShopServiceDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
