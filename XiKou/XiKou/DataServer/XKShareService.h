//
//  XKShareService.h
//  XiKou
//
//  Created by L.O.U on 2019/7/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKBaseResponse.h"
#import "XKNetworkManager.h"
#import "XKShareData.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKShareService : NSObject
/**
 获取推广分享的背景图和链接
 
 @param completionBlock <#completionBlock description#>
 */
- (void)getPopularizeShareInfomationCompletion:(void (^)(XKPopularizeInfoResponse * _Nonnull response))completionBlock;

/**
 获取分享链接
 
 @param completionBlock completionBlock description
 */
- (void)queryShareDataByModel:(XKShareRequestModel *)model Completion:(void (^)(XKShareResponse * _Nonnull response))completionBlock;

/**
 分享回调
 
 @param completionBlock completionBlock description
 */
- (void)shareCallbackByModel:(XKShareCallbackRequestModel *)model Completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


@end

NS_ASSUME_NONNULL_END
