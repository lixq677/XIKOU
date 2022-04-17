//
//  ACTCartService.h
//  XiKou
//
//  Created by L.O.U on 2019/7/18.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKNetworkManager.h"
#import "XKActivityCartData.h"

NS_ASSUME_NONNULL_BEGIN

@class ACTCartDataResponse;
@interface XKActivityCartService : NSObject

/**
 多买多折加入购物车

 @param param <#param description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)mutilGoodAddCart:(NSDictionary *)param
                Complete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;


/**
 获取购物车数据

 @param userId <#userId description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getCartDataByUserId:(NSString *)userId
                   Complete:(void(^)(ACTCartDataResponse *_Nonnull response))completionBlock;


/**
 根据ID删除购物车商品

 @param cartId <#cartId description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)deleteCartGoodById:(NSString *)cartId
                  Complete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;

/**
 根据ID修改购物车商品数量
 
 @param cartId <#cartId description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)updateCartGoodNumById:(NSString *)cartId
                       andNum:(NSInteger)num
                     Complete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock;
@end


NS_ASSUME_NONNULL_END

