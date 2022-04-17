//
//  WXApiManager.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WXApiManagerDelegate <NSObject>

- (void)authRespCode:(NSString *)code state:(NSString *)state;

- (void)payRespCode:(int)errCode resp:(PayResp *)response;

@end

@interface WXApiManager : NSObject<WXApiDelegate>

+(WXApiManager *)defaultManager;

/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url     第三方sdk的打开本app的回调的url
 *  @param options 回调的参数
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 */
-(BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary*)options;

- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;

/*! @brief WXApi的成员函数，向微信终端程序注册第三方应用。
 *
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现，默认开启MTA数据上报。
 * iOS7及以上系统需要调起一次微信才会出现在微信的可用应用列表中。
 * @attention 请保证在主线程中调用此函数
 * @param appid 微信开发者ID
 * @return 成功返回YES，失败返回NO。
 */
- (BOOL)registerApp:(NSString *)appid;

- (void)getCodeCompletion:(void(^)(NSString *code,NSError *error))completion;

@property (nonatomic,copy,readonly)NSString *appKey;

- (void)addWeakDelegate:(id<WXApiManagerDelegate>)delegate;

- (void)removeWeakDelegate:(id<WXApiManagerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
