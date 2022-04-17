//
//  XKNetworkConfig.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kDomainKey  @"kDomainKey"

typedef NS_ENUM(int,XKDomainEnv) {
    XKDomainEnvProduct  =   0,
    XKDomainEnvTest     =   1,
    XKDomainEnvDevelop  =   2,
};

@interface XKNetworkConfig : NSObject

@property (nonatomic,strong,nullable)NSString *token;

@property (nonatomic,strong,nullable)NSString *userId;

@property (nonatomic,strong,readonly)NSDictionary *baseParams;

@property (nonatomic,assign)XKDomainEnv domainEnv;

+(id)shareInstance;

/**
 主域名

 @return <#return value description#>
 */
- (NSString *)mainDomain;


/**
 微信公众号域名

 @return <#return value description#>
 */
- (NSString *)wxDomain;

@end

NS_ASSUME_NONNULL_END
