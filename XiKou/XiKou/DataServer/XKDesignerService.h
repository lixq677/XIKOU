//
//  XKDesignerService.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKDesignerData.h"

NS_ASSUME_NONNULL_BEGIN

@class XKDesignerService;
@protocol XKDesignerServiceDelegate <NSObject>
@optional

- (void)commentWithService:(XKDesignerService *)service comments:(XKDesignerCommentVoModel *)voModel;

- (void)concernDesignerWithService:(XKDesignerService *)service param:(XKDesignerFollowVoParams *)param;

- (void)thumbupDesignerWithService:(XKDesignerService *)service param:(XKDesignerFollowVoParams *)param;

@end

@interface XKDesignerService : NSObject

- (void)addWeakDelegate:(id<XKDesignerServiceDelegate>)delegate;

- (void)removeWeakDelegate:(id<XKDesignerServiceDelegate>)delegate;

/**
 请求获取设计师简介，展示在设计师圈

 @param page 页数
 @param limit 每页最大记录条数
 @param completionBlock 回调
 */
- (void)queryDesignersWithPage:(NSUInteger)page limit:(NSUInteger)limit completion:(void (^)(XKDesignerBriefResponse * _Nonnull response))completionBlock;


/**
 从缓存中取出最新的设计师信息

 @return <#return value description#>
 */
- (NSArray<XKDesignerBriefData *> *)queryLastestDesignerFromCache;

/**
 请求设计师主页信息

 @param designerId 设计师id
 @param userId 自己的用户id
 @param completionBlock 回调
 */
- (void)queryDesignerHomePageInfoWithDesignerId:(NSString *)designerId userId:(NSString *)userId completion:(void (^)(XKDesignerHomeResponse * _Nonnull response))completionBlock;


/**
 从缓存中查询设计师主页信息
 
 @param designerId <#designerId description#>
 */
- (XKDesignerHomeData *)queryDesignerHomePageInfoFromCacheWithDesignerId:(NSString *)designerId;


/**
 查询设计
 */
- (void)queryDesignerWorksWithParams:(XKDesignerWorksParams *)params completion:(void (^)(XKDesignerWorkResponse * _Nonnull response))completionBlock;



/**
 从缓存中查询设计师的作品


 */
- (NSArray<XKDesignerWorkData *> *)queryWorksFromCacheWithParams:(XKDesignerWorksParams *)params;


/**
 设置是否关注或取消关注设计师

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)setConcernDesignerWithParams:(XKDesignerFollowVoParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 点赞

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)setThumbupDesignerWithParams:(XKDesignerFollowVoParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 查询评论

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryDesignerCommentsWithParams:(XKDesignerCommentsRequestParams *)params completion:(void(^)(XKDesignerCommentResponse *response))completionBlock;


/**
 提交评论
 @param commentVoModel <#commentParams description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)commentWithVoModel:(XKDesignerCommentVoModel *)commentVoModel  completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;



/**
 获取我关注的设计师

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryDesignersOfMyConcernParams:(XKDesignerMyConcernParams *)params completion:(void (^)(XKDesignerMyConcernResponse * _Nonnull response))completionBlock;


/**
 从缓存中查询关注的设计师

 @param params <#params description#>
 @return <#return value description#>
 */
- (NSArray<XKDesignerMyConcernData *> *)queryDesignerOfMyConcernFromCache:(XKDesignerMyConcernParams *)params;

@end

NS_ASSUME_NONNULL_END
