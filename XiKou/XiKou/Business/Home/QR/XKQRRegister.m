//
//  XKQRRegister.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKQRRegister.h"
#import "XKQRWhiteList.h"
#import "XKAccountManager.h"

@implementation XKQRRegister

+(void)load{
    [[XKQRWhiteList sharedInstance] registerURLPattern:@"wx.luluxk.com" toHandler:^(NSDictionary * _Nonnull qrParams) {
        //NSString *path = [qrParams objectForKey:XKQRParameterPath];
        NSMutableDictionary *params = [qrParams objectForKey:XKQRParameterUserInfo];
        [params setObject:@(YES) forKey:@"forRegister"];
        [MGJRouter openURL:kRouterLogin withUserInfo:params completion:nil];
    }];
    [[XKQRWhiteList sharedInstance] registerURLPattern:@"wx-test.luluxk.com" toHandler:^(NSDictionary * _Nonnull qrParams) {
        //NSString *path = [qrParams objectForKey:XKQRParameterPath];
        NSMutableDictionary *params = [qrParams objectForKey:XKQRParameterUserInfo];
        [params setObject:@(YES) forKey:@"forRegister"];
        [MGJRouter openURL:kRouterLogin withUserInfo:params completion:nil];
    }];
    [[XKQRWhiteList sharedInstance] registerURLPattern:@"m.luluxk.com" toHandler:^(NSDictionary * _Nonnull qrParams) {
        //NSString *path = [qrParams objectForKey:XKQRParameterPath];
        NSMutableDictionary *params = [qrParams objectForKey:XKQRParameterUserInfo];
        [params setObject:@(YES) forKey:@"forRegister"];
        [MGJRouter openURL:kRouterLogin withUserInfo:params completion:nil];
    }];
    [[XKQRWhiteList sharedInstance] registerURLPattern:@"m-test.luluxk.com" toHandler:^(NSDictionary * _Nonnull qrParams) {
        //NSString *path = [qrParams objectForKey:XKQRParameterPath];
        NSMutableDictionary *params = [qrParams objectForKey:XKQRParameterUserInfo];
        [params setObject:@(YES) forKey:@"forRegister"];
        [MGJRouter openURL:kRouterLogin withUserInfo:params completion:nil];
    }];
}

@end
