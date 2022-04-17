//
//  XKAddressService.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKAddressData.h"

NS_ASSUME_NONNULL_BEGIN

@class XKAddressService;

@protocol XKAddressServiceDelegate <NSObject>

@optional

- (void)addAddressWithSevice:(XKAddressService *)service address:(XKAddressVoData *)data;

- (void)updateAddressWithSevice:(XKAddressService *)service address:(XKAddressVoData *)data;

@end

@interface XKAddressService : NSObject


- (void)addWeakDelegate:(id<XKAddressServiceDelegate>)delegate;

- (void)removeWeakDelegate:(id<XKAddressServiceDelegate>)delegate;

/**
 查询用户地址信息

 @param userId 用户id
 @param completionBlock 回调
 */
- (void)queryAddressListWithUserId:(NSString *)userId completion:(nullable void (^)(XKAddressUserListResponse * _Nonnull response))completionBlock;



/**
 缓存中查找地址数据

 @param userId <#userId description#>
 @return <#return value description#>
 */
- (NSArray<XKAddressVoData *> *)queryAddressListFromCacheWithUserId:(NSString *)userId;

/**
 缓存中查找地址数据
 
 @param id 地址ID
 @return <#return value description#>
 */
- (XKAddressVoData *)queryAddressVoDataWithId:(NSString *)id;

/**
 查询地址信息

 @param level <#level description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryAllAddressInfoWithLevel:(XKAddressLevel)level completion:(nullable void (^)(XKAddressInfoListResponse * _Nonnull response))completionBlock;



/**
 新增地址消息

 @param voData <#voData description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)addAddress:(XKAddressVoData *)voData completion:(nullable void (^)(XKBaseResponse * _Nonnull response))completionBlock;


/**
 修改地址信息

 @param voData <#voData description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)updateAddress:(XKAddressVoData *)voData completion:(nullable void (^)(XKBaseResponse * _Nonnull response))completionBlock;



/**
 删除地址

 @param id <#id description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)deleteAddressWithId:(NSString *)id completion:(void (^)(XKAddressDeleteResponse * _Nonnull response))completionBlock;

@end

NS_ASSUME_NONNULL_END
