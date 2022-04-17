//
//  NSError+XKNetwork.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NSError+XKNetwork.h"

@implementation NSError (XKNetwork)

+ (NSError *)errorWithCode:(CodeStatus)codeStatus{
    NSString *domain = nil;
    switch (codeStatus) {
        case CodeStatus_Success:
            domain = @"访问成功";
        case CodeStatus_NotRegister:
            domain = @"账户未注册";
        case CodeStatus_Freeze:
            domain = @"账户被冻结";
        case CodeStatus_RegisterAndNotBinded:
            domain = @"未绑定第三方账号";
        case CodeStatus_RegisterAndBinded:
            domain = @"已绑定第三方账号";
            break;
        case CodeStatus_VerifyCodeError:
            domain = @"验证码错误";
            break;
        case CodeStatus_TimeOut:
            domain = @"网络超时";
            break;
        case CodeStatus_NotFound:
            domain = @"接口不存在";
            break;
        case CodeStatus_TokenInvalid:
            domain = @"token失效";
            break;
        case CodeStatus_MobileError:
            domain = @"号码错误";
            break;
        default:
            domain = @"未知错误";
            break;
    }
    NSError *error = [NSError errorWithDomain:domain code:codeStatus userInfo:nil];
    return error;
}

@end
