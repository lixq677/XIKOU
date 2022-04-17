//
//  XKMessageService.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKMessageData.h"

NS_ASSUME_NONNULL_BEGIN

@class XKMessageService;
@protocol XKMessageServiceDelegate <NSObject>
@optional

- (void)readUnreadMsgWithService:(XKMessageService *)service msgData:(XKMsgData *)msgData;

- (void)readUnreadMsgWithService:(XKMessageService *)service msgTypeModel:(XKMsgTypeModel *)msgModel;

@end

@interface XKMessageService : NSObject


/**
 查询未读消息数

 @param userId <#userId description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryUnReadMsgNumWithUserId:(NSString *)userId completion:(void (^)(XKMsgUnReadResponse * _Nonnull response))completionBlock;



/**
 获取未读消息

 @param params <#params description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryMsgsWithParams:(XKMsgParams *)params completion:(void (^)(XKMsgResponse * _Nonnull response))completionBlock;


/**
 从缓存中查找消息

 @param params <#params description#>
 @return <#return value description#>
 */
- (NSArray<XKMsgData *> *)queryMsgsWithParamsFromCache:(XKMsgParams *)params;


/**
 读一条消息

 @param msgId <#msgId description#>
 */
- (void)readMsgWithMsgId:(NSString *)msgId;

/*一个类型的消息*/
- (void)readMsgs:(XKMsgTypeModel *)msgModel;


- (void)addWeakDelegate:(id<XKMessageServiceDelegate>)delegate;

- (void)removeWeakDelegate:(id<XKMessageServiceDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
