//
//  XKQRWhiteList.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const XKQRParameterURL;
extern NSString *const XKQRParameterPath;
extern NSString *const XKQRParameterUserInfo;

typedef  void(^XKQRWhiteHandler)( NSDictionary *_Nullable params);

@interface XKQRWhiteList : NSObject

+ (nonnull instancetype)sharedInstance;

- (void)registerURLPattern:(NSString *)URLPattern toHandler:(XKQRWhiteHandler)handler;

- (BOOL)handleIt:(NSString *)it;

@end

NS_ASSUME_NONNULL_END
