//
//  NSError+XKNetwork.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int,CodeStatus) {
    CodeStatus_Success  =   0,//成功
    CodeStatus_NotRegister                   =      1001,//未注册
    CodeStatus_RegisterAndNotBinded          =      1002,//账号已注册，未绑定
    CodeStatus_Freeze                        =      1003,//账户被冻结
    CodeStatus_WeChatNotBind                 =      1006,//微信未绑定账号
    CodeStatus_MobileError                   =      1007,//
    CodeStatus_RegisterAndBinded             =      1008,//已注册，已绑定
    CodeStatus_InviteCode                    =      1009,//邀请码不匹配
    CodeStatus_VerifyCodeError               =      1010,//验证码错误
    CodeStatus_NotFound                      =      404,//接口不存在
    CodeStatus_TokenInvalid                  =      10002,//token 失效
    CodeStatus_TimeOut                       =      NSURLErrorTimedOut,//超时
};


@interface NSError (XKNetwork)

+ (NSError *)errorWithCode:(CodeStatus)codeStatus;

@end

NS_ASSUME_NONNULL_END
