//
//  XKNetworkConfig.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKNetworkConfig.h"
#import "KeychainIDFA.h"

static NSString *kTestDomain = @"https://gateway-test.luluxk.com";//测试环境
static NSString *kProductDomain  = @"https://gateway.luluxk.com";//生产环境

static NSString *kDevelopDomain = @"http://gateway-dev.luluxk.com";//开发环境

static NSString *kTestWxDomain  = @"https://wx-test.luluxk.com";
static NSString *kProductWxDomain  = @"https://wx.luluxk.com";


@interface XKNetworkConfig ()

@property (nonatomic,strong,readonly)NSMutableDictionary *params;

@end

@implementation XKNetworkConfig
@synthesize params = _params;
@dynamic domainEnv;

+(id)shareInstance{
    static id shareInstance= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        NSString *ida = [KeychainIDFA IDFA];
        if (![NSString isNull:ida]) {//设备唯一标识
            [self.params setObject:ida forKey:@"deviceId"];
        }
        NSString *bundleId = [XKUnitls getBundleID];
        if (![NSString isNull:bundleId]) {//bundleId
            [self.params setObject:bundleId forKey:@"bundleId"];
        }
        /*设备类型*/
        XKDeviceType deviceType = [XKUnitls getCurDevice];
        [self.params setObject:@(deviceType) forKey:@"deviceType"];
        
        /*2表示iOS*/
        [self.params setObject:@(2) forKey:@"osType"];
        
        [self.params setObject:@"AppStore" forKey:@"releaseChannel"];
        
        NSString *platform = [XKUnitls getPlatformString];
        if (![NSString isNull:platform]) {
            [self.params setObject:platform forKey:@"deviceModel"];
        }
        
        NSString *systemVersion = [XKUnitls getSystemVersion];
        if (![NSString isNull:systemVersion]) {
            [self.params setObject:systemVersion forKey:@"osVersion"];
        }
        
        /*app版本号*/
        NSString *appVersion = [XKUnitls getAppVersion];
        if (![NSString isNull:appVersion]) {
            [self.params setObject:appVersion forKey:@"appVersion"];
        }
    }
    return self;
}

- (XKDomainEnv)domainEnv{
    NSNumber *domainEnv = [[NSUserDefaults standardUserDefaults] objectForKey:kDomainKey];
    if (domainEnv) {
         return domainEnv.intValue;
    }else{
         return XKDomainEnvTest;
    }
}

- (NSString *)mainDomain{
#if APPSTORE == 0
    XKDomainEnv env = [[XKNetworkConfig shareInstance] domainEnv];
    if (env == XKDomainEnvTest) {
        return kTestDomain;
    }else if (env == XKDomainEnvDevelop){
        return kDevelopDomain;
    }else{
        return kProductDomain;
    }
#else
    return kProductDomain;
#endif
}

- (NSString *)wxDomain{
#if APPSTORE == 0
    XKDomainEnv env = [[XKNetworkConfig shareInstance] domainEnv];
    if (env == XKDomainEnvTest) {
        return kTestWxDomain;
    }else{
        return kProductWxDomain;
    }
#else
    return kProductWxDomain;
#endif
}



- (void)setDomainEnv:(XKDomainEnv)env{
    [[NSUserDefaults standardUserDefaults] setInteger:env forKey:kDomainKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)baseParams{
    return self.params;
}

- (NSMutableDictionary *)params{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

@end
