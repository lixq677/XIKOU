//
//  XKQRWhiteList.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKQRWhiteList.h"

NSString *const XKQRParameterURL = @"XKQRParameterURL";
NSString *const XKQRParameterPath = @"XKQRParameterPath";
NSString *const XKQRParameterUserInfo = @"XKQRParameterUserInfo";

@interface XKQRWhiteList ()

@property (nonatomic,strong,readonly)NSMutableDictionary<NSString *,XKQRWhiteHandler> *handles;

@end

@implementation XKQRWhiteList
@synthesize handles = _handles;

+ (nonnull instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)registerURLPattern:(NSString *)URLPattern toHandler:(XKQRWhiteHandler)handler{
    if ([NSString isNull:URLPattern] || handler == nil) return;
    if (URLPattern.isUrl) {
        NSURL *URL = [NSURL URLWithString:URLPattern];
        [self.handles setObject:[handler copy] forKey:URL.host];
    }else{
        [self.handles setObject:[handler copy] forKey:URLPattern];
    }
}

- (BOOL)handleIt:(NSString *)it{
    if ([NSString isNull:it]) return NO;
    if (it.isUrl) {
        NSURL *URL = [NSURL URLWithString:it];
        XKQRWhiteHandler handler = [self.handles objectForKey:URL.host];
        if (handler == nil) return NO;
        NSDictionary *params = [URL params];
        NSString *path = [[URL path] stringByDeletingPathExtension];
        NSMutableDictionary *routerParams = [NSMutableDictionary dictionary];
        [routerParams setObject:it forKey:XKQRParameterURL];
        if ([NSString isNull:path] == NO) {
            [routerParams setObject:path forKey:XKQRParameterPath];
        }
        if (params) {
            [routerParams setObject:params forKey:XKQRParameterUserInfo];
        }
        handler(routerParams);
    }else{
        XKQRWhiteHandler handler = [self.handles objectForKey:it];
        if (handler == nil) return NO;
        NSMutableDictionary *routerParams = [NSMutableDictionary dictionary];
        handler(routerParams);
    }
    return YES;
}

- (NSMutableDictionary<NSString *,XKQRWhiteHandler> *)handles{
    if (!_handles) {
        _handles = [NSMutableDictionary dictionary];
    }
    return _handles;
}

@end
