//
//  XKPropertyService.h
//  XiKou
//
//  Created by Tony on 2019/6/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKNetworkManager.h"
#import "XKPropertyData.h"
#import "XKUnitls.h"


NS_ASSUME_NONNULL_BEGIN

@class XKPropertyService;

@protocol XKPropertyServiceDelegate <NSObject>
@optional
- (void)changeAmountStateWithService:(XKPropertyService *)service userId:(NSString *)userId isHidden:(BOOL)hidden;


/// 绑定银行卡成功
/// @param service <#service description#>
/// @param params <#params description#>
- (void)propertyService:(XKPropertyService *)service bindBankCardSuccess:(XKBankBindParams *)params;

/// 删除银行卡成功
/// @param service <#service description#>
/// @param bankId <#params description#>
- (void)propertyService:(XKPropertyService *)service deleteBankCardSuccess:(NSString *)bankId;


/// 提现成功
/// @param service <#service description#>
/// @param params <#params description#>
- (void)propertyService:(XKPropertyService *)service cashoutSuccess:(XKCashVoParams *)params;

@end


@interface XKPropertyService : NSObject


/**
 根据用户ID查询可使用的优惠券列表

 @param params <#params description#>
 @param prefrenceState 请求数据类型
 @param completionBlock <#completionBlock description#>
 */
- (void)getPreferenceWithParams:(XKPrefrenceParams *)params  prefrenceState:(XKPreferenceState)prefrenceState completion:(void (^)(XKPreferenceResponse * _Nonnull response))completionBlock;

/*获取缓存中的优惠券信息*/
- (NSArray<XKPreferenceData *> *)queryPreferenceFromCacheWithPrefrenceState:(XKPreferenceState)prefrenceState userId:(NSString *)userId;


/*通过优惠券id从缓存中查找优惠券明细*/
-(XKPreferenceDetailData *)queryPreferenceDetailDataFromCacheWithId:(NSString *)prefenceId;



/// 查看优惠券总额
/// @param userId <#userId description#>
/// @param completionBlock <#completionBlock description#>
- (void)getTicketTotalWithUserId:(NSString *)userId completion:(void (^)(XKTicketTotalResponse * _Nonnull response))completionBlock;

/**
 *从服务器获取优惠券明细*
 @param preferenceId 优惠券id
 @param completionBlock 回调
 */
- (void)getPreferenceRecordWithId:(NSString *)preferenceId completion:(void (^)(XKPreferenceDetailResponse * _Nonnull response))completionBlock;


/**
 获取优惠券总额

 @param userId <#userId description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)getPreferenceAmountWithId:(NSString *)userId completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 取消用户关注信息

 @param userId 自己的用户id
 @param followedUserId 要取消关注用户的id
 @param completionBlock 回调block
 */
- (void)cancelConcernWithUserId:(NSString *)userId followedUserId:(NSString *)followedUserId completion:(void (^)(XKConcernResponse * _Nonnull response))completionBlock;



/**
 根据用户ID查询账户信息

 @param userId 要查询用户的id
 @param completionBlock 回调
 */
- (void)getRedBagWithUserId:(NSString *)userId completion:(void (^)(XKRedBagResponse * _Nonnull))completionBlock;



/**
 查询待结算明细

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryAccountUnSettledWithParams:(XKAmountParams *)params completion:(void (^)(XKAmountResponse * _Nonnull response))completionBlock;


/**
 红包明细

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryAccountRedBagWithParams:(XKAmountParams *)params completion:(void (^)(XKAmountResponse * _Nonnull response))completionBlock;


/**
 提现明细

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryAccountCashoutWithParams:(XKCashOutParams *)params completion:(void (^)(XKCashOutResponse * _Nonnull response))completionBlock;


//查询提现详情
- (void)queryAccountCashoutDetailWithId:(NSString *)id completion:(void (^)(XKCashOutDetailResponse * _Nonnull response))completionBlock;

/**
 查询红包收支月统计

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryAccountIncomeAndExpenditurMonthlyTotalWithParams:(XKAmountMonthlyTotalParams *)params completion:(void (^)(XKAmountMonthlyTotalResponse * _Nonnull response))completionBlock;

/**
 查询红包提现月统计
 
 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryAccountCashoutMonthlyTotalWithParams:(XKAmountMonthlyTotalParams *)params completion:(void (^)(XKAmountMonthlyTotalResponse * _Nonnull response))completionBlock;



/******************银行卡********************/

/**
 添加银行卡，请求发送验证码

 @param mobile <#mobile description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)requestSendValidCode:(NSString *)mobile  completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;



/**
 查询验证码

 @param userId <#userId description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryMyBankCardsWithUserId:(NSString *)userId  completion:(void (^)(XKBankResponse * _Nonnull response))completionBlock;


/**
 绑定银行卡

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)addBankCardWithParams:(XKBankBindParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;

/// 提现
/// @param params <#params description#>
/// @param completionBlock <#completionBlock description#>
- (void)cashoutWithParams:(XKCashVoParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


- (NSString *)imageNameFromBankName:(NSString *)bankName;

/// 获取验证码
/// @param number <#number description#>
/// @param completionBlock <#completionBlock description#>
- (void)getValidCodeWithNumber:(NSString *)number completion:(void (^)(XKBaseResponse * _Nonnull))completionBlock;


/// 验证支付密码
/// @param password <#password description#>
/// @param userId <#userId description#>
/// @param completionBlock <#completionBlock description#>
- (void)verifyPayPassword:(NSString *)password userId:(NSString *)userId completion:(void (^)(XKBaseResponse * _Nonnull))completionBlock;

/**
 修改银行卡信息

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)changeBankCardWithParams:(XKBankBindParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/// 转账
/// @param params <#params description#>
/// @param completionBlock <#completionBlock description#>
- (void) transportAccountWithParams:(XKTransportAccounParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 删除银行卡

 @param bankId <#bankId description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)removeBankCardWithBankId:(NSString *)bankId completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/// 查询银行卡
/// @param completionBlock <#completionBlock description#>
- (void)queryBankListDataWithCompletion:(void (^)(XKBankListResponse * _Nonnull response))completionBlock;


/// 查询分类
/// @param completionBlock <#completionBlock description#>
- (void)queryRedbagCategoryWithCompletion:(void (^)(XKRedbagCategoryResponse * _Nonnull response))completionBlock;

- (void)queryRedPacketDetailWithParams:(XKRedPacketDetailParams *)params completion:(void (^)(XKRedPacketDetailResponse * _Nonnull response))completionBlock;


- (NSArray<XKBankListData *> *)queryBankListDataFromCache;

///**
// 支付红包
//
// @param params <#params description#>
// @param completionBlock <#completionBlock description#>
// */
//- (void)payRedbagWithParams:(XKRedbagPayParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 设置是否隐藏红包数额

 @param userId <#userId description#>
 @param hidden <#hidden description#>
 */
- (void)setUserId:(NSString *)userId amountHidden:(BOOL)hidden;


/**
 获取是否隐藏红包数额状态

 @param userId <#userId description#>
 @return <#return value description#>
 */
- (BOOL)amountHiddenByUserId:(NSString *)userId;

- (void)addWeakDelegate:(id<XKPropertyServiceDelegate>)delegate;

- (void)removeWeakDelegate:(id<XKPropertyServiceDelegate>)delegate;

@end




NS_ASSUME_NONNULL_END
