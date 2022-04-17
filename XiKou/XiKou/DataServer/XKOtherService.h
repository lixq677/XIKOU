//
//  XKOtherService.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKOtherData.h"
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKOtherService : NSObject


/**
 获取 task 任务

 @param userId 用户id
 @param completionBlock <#completionBlock description#>
 */
- (void)queryTasksWithUserId:(NSString *)userId completion:(void (^)(XKTaskResponse * _Nonnull response))completionBlock;

/**
 获取 是否可以下单开关
 
 @param completionBlock completionBlock description
 */
- (void)queryPaySwitchCompletion:(void (^)(XKPaySwitchResponse * _Nonnull response))completionBlock;


/**
 查询资料

 @param userId <#userId description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryCirclesWithUserId:(NSString *)userId completion:(void (^)(XKSocialResponse * _Nonnull response))completionBlock;

/**
 请求阿里云服务器获取图片尺寸
 
 @param urlString <#urlString description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryImageSizeWithUrl:(NSString *)urlString completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 查询物流信息
 @param orderNo <#orderNo description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryLogisticsWithOrderNo:(NSString *)orderNo orderType:(XKOrderType)orderType completion:(void (^)(XKLogisticsResponse * _Nonnull response))completionBlock;


/// 根据砍价进度ID查询发送红包详情
/// @param scheduleId <#scheduleId description#>
/// @param completionBlock <#completionBlock description#>
- (void)queryBargainRecordByScheduleId:(NSString *)scheduleId completion:(void (^)(XKBargainScheduleResponse * _Nonnull response))completionBlock;



/// 查询最新版本
/// @param completionBlock <#completionBlock description#>
- (void)queryTheLastestAppVersionWithCompletion:(void (^)(XKVersionResponse * _Nonnull response))completionBlock;

@end

NS_ASSUME_NONNULL_END
