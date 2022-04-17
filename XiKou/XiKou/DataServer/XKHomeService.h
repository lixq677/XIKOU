//
//  XKHomeService.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKHomeData.h"
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKHomeService : NSObject

- (void)queryHomePageActivityWithCompletion:(void (^)(XKHomeActivityResponse * _Nonnull response))completionBlock;


/**
 首页数据，从首页查询

 @return <#return value description#>
 */
- (XKHomeActivityModel *)activityModelFromCache;



/**
 查询banner

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryBannerWithParams:(XKBannerParams *)params completion:(void (^)(XKBannerResponse * _Nonnull response))completionBlock;



/**
 爆品排行

 @param rank <#rank description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryRankDataByType:(RanKType)rank Completion:(void (^)(XKRankResponse * _Nonnull response))completionBlock;


/**
 查询h首页banner

 @param position <#position description#>
 @return <#return value description#>
 */
- (NSArray<XKBannerData *> *)queryHomeBannerFromCacheWithPostion:(XKBannerPosition)position;


/**
 查询活动首页banner

 @param position <#position description#>
 @return <#return value description#>
 */
- (NSArray<XKBannerData *> *)queryActivityBannerFromCacheWithPostion:(XKBannerPosition)position moudle:(XKBannerMoudle)moudle;
/**
 搜索商品

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)searchGoodsWithParams:(XKGoodsSearchParams *)params completion:(void (^)(XKGoodsSearchResponse * _Nonnull response))completionBlock;


/**
 查询搜索历史
 
 @return <#return value description#>
 */
- (NSArray<XKGoodsSearchText *> *)searchLastKeywordFromCache;

/*存储搜索历史*/
- (void)saveKeyworkdToCache:(NSString *)keyword;

/**
 删除关键字
 */
- (void)deleteKeywordFromCache;

@end

NS_ASSUME_NONNULL_END
