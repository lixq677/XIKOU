//
//  XKUserData.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKUserData.h"


@implementation XKCodeResponse
@synthesize data = _data;

//+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
//    return @{@"data":[XKCodeData class]};
//}
@end

@implementation XKUserInfoData
+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}

- (id)copyWithZone:(NSZone *)zone{
    XKUserInfoData *copy = [XKUserInfoData yy_modelWithJSON:[self yy_modelToJSONObject]];
    return copy;
}

@end

@implementation XKUserInfoResponse
@synthesize data = _data;

@end

@implementation XKModifyUserVoParams


@end

@implementation XKRegisterParams


@end

@implementation XKVerifyParams


@end

@implementation XKVerifyInfoResponse
@synthesize data = _data;


@end

@implementation XKVerifyInfoData

@end

@implementation XKPayPasswordParams

- (instancetype)init{
    if (self = [super init]) {
        self.accountType = XKAccountTypeDefault;
    }
    return self;
}

@end

@implementation XKReferrerResponse
@synthesize data = _data;

@end

@implementation XKReferrerData


@end

