//
//  XKNetworkManager.h
//  XiKou
//
//  Created by 李笑清 on 2019/5/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKBaseRequest.h"
#import "XKBaseResponse.h"
#import "XKNetworkConfig.h"


NS_ASSUME_NONNULL_BEGIN

@protocol XKNetworkManagerDelegate  <NSObject>

@optional
- (void)handleRequest:(XKBaseRequest *)request response:(XKBaseResponse *)response;

@end

/**网络状态Block*/
typedef void(^XKNetworkStatus)(AFNetworkReachabilityStatus status);
@interface XKNetworkManager : NSObject

+ (XKNetworkManager *)sharedInstance;

/**当前网络是否可用*/
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

- (void)addRequest:(XKBaseRequest *)request;

/**实时获取网络状态*/
+ (void)getNetworkStatusWithBlock:(XKNetworkStatus)networkStatus;

- (void)addWeakDelegate:(id<XKNetworkManagerDelegate>)delegate;

- (void)removeWeakDelegate:(id<XKNetworkManagerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
