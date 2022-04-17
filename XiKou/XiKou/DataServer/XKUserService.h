//
//  XKUserService.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKNetworkManager.h"
#import "XKUserData.h"
#import "XKUnitls.h"

NS_ASSUME_NONNULL_BEGIN
@class XKUserService;
@class XKAccountData;

@protocol XKUserServiceDelegate <NSObject>
@optional
/*登录成功调用*/
- (void)loginWithService:(XKUserService *)service userInfo:(XKAccountData *)data;

/*退出登录调用*/
- (void)logoutWithService:(XKUserService *)service userId:(NSString *)userId;

/*刷新token*/
- (void)refreshTokenWithService:(XKUserService *)service userInfo:(XKAccountData *)data;

/*查询用户基本信息*/
- (void)queryUserBasicInfoWithService:(XKUserService *)service userInfoData:(XKUserInfoData *)userInfoData;

/*查询用户我的页面信息*/
- (void)queryUserMineInfoWithService:(XKUserService *)service userInfoData:(XKUserInfoData *)userInfoData;

/*修改用户信息*/
- (void)modifyWithSevice:(XKUserService *)service userInfomation:(XKModifyUserVoParams * __nullable)params userId:(NSString *)userId;

- (void)changePaymentPasswordWithService:(XKUserService *)service userId:(NSString *)userId;


/**
 *实名认证成功
 @param service <#service description#>
 @param userId <#userId description#>
 */
- (void)verifySuccessWithSevice:(XKUserService *)service userId:(NSString *)userId;


@end

@interface XKUserService : NSObject

- (void)addWeakDelegate:(id<XKUserServiceDelegate>)delegate;

- (void)removeWeakDelegate:(id<XKUserServiceDelegate>)delegate;

/**
 获取验证码

 @param number 手机号码
 @param completionBlock 返回回调
 */
- (void)getValidCodeWithNumber:(NSString *)number completion:(void (^)(XKCodeResponse * _Nonnull))completionBlock;


/**
 登录

 @param number 手机号码
 @param code 验证码
 @param completionBlock 回调
 */
- (void)loginWithNumber:(NSString *)number code:(NSString *)code completion:(void (^)(XKCodeResponse * _Nonnull))completionBlock;


/**
 微信登录

 @param appId appid
 @param wxcode code
 @param completionBlock 回调
 */
- (void)loginWithWXAppid:(NSString *)appId code:(NSString *)wxcode completion:(void (^)(XKCodeResponse * _Nonnull))completionBlock;

/**
 退出登录,未完成接口
 
 @param userId 手机号码
 @param completionBlock 回调
 */
- (void)logoutWithUserId:(NSString *)userId completion:(nullable void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 判断是否已注册

 @param mobile <#mobile description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)isRegisterWithMobile:(NSString *)mobile completion:(void (^)(XKBaseResponse * _Nonnull))completionBlock;


/**
 注册

 @param number 手机号码
 @param vCode 验证码
 @param iCode 邀请码
 @param completionBlock 回调
 */
- (void)registerWithNumber:(NSString *)number verifyCode:(NSString *)vCode inviteCode:(NSString *)iCode completion:(void (^)(XKCodeResponse * _Nonnull))completionBlock;


/**
 注册

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)registerWithParams:(XKRegisterParams *)params completion:(void (^)(XKCodeResponse * _Nonnull))completionBlock;

/**
 认证
 
 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)verifyWithParams:(XKVerifyParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;

/**
 获取认证信息
 
 @param userId params description
 @param completionBlock <#completionBlock description#>
 */
- (void)getVerifyInfoWithUserId:(NSString *)userId completion:(void (^)(XKVerifyInfoResponse* _Nonnull response))completionBlock;

/**
 获取推荐人信息
 
 @param userId params description
 @param completionBlock completionBlock description
 */
- (void)getReferrerInfoWithUserId:(NSString *)userId completion:(void (^)(XKReferrerResponse* _Nonnull response))completionBlock;

/**
 刷新JWT

 @param token <#token description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)refreshToken:(NSString *)token completion:(void (^)(XKCodeResponse * _Nonnull))completionBlock;


/**
 获取用户的基本信息

 @param id <#ids description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getUserBasicInfomationWithId:(NSString *)id completion:(nullable void (^)(XKUserInfoResponse * _Nonnull response))completionBlock;


/*获取用户的我的界面的信息*/
- (void)getUserMineInfomationWithId:(NSString *)id completion:(nullable void (^)(XKUserInfoResponse * _Nonnull response))completionBlock;

/*从缓存中查找数据*/
- (XKUserInfoData *)queryUserInfoFromCacheWithId:(NSString *)id;


/**
 修改用户基本信息

 @param params <#params description#>
 @param userId <#id description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)modifyUserInfomation:(XKModifyUserVoParams *)params withUserId:(NSString *)userId   completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 上传文件
 */
- (void)uploadWithConstructingBodyBlock:(XKBlockConstructingBody)constructingBodyBlock completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 修改支付密码

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)changePayPasswordWithParams:(XKPayPasswordParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 为修改支付密码获取验证码

 @param mobile <#mobile description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)changePayPasswordForGetVerifyCodeWithMobile:(NSString *)mobile completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;

/**
 查询是否设置过密码

 @param userId <#userId description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryPaymentPasswordIsSettingWithUserId:(NSString *)userId completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;

/**
 验证码是否有效

 @param mobile <#mobile description#>
 @param code <#code description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)isValidCodeWithMobile:(NSString *)mobile code:(NSString *)code completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 解绑第三方

 @param userId <#userId description#>
 @param type <#type description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)unBindThirdRelationWithUserId:(NSString *)userId type:(XKThirdPlatformType)type completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


- (void)queryUserInfoWithMobile:(NSString *)mobile completion:(nullable void (^)(XKUserInfoResponse * _Nonnull response))completionBlock;

@end

NS_ASSUME_NONNULL_END
