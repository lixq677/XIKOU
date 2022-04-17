//
//  XKPayManger.m
//  XiKou
//
//  Created by L.O.U on 2019/7/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKPayManger.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

typedef void(^completeBlock)(PayType type,BOOL isSuccess,NSError *error);
@interface XKPayManger ()

@property (nonatomic, copy) completeBlock block;

@end
@implementation XKPayManger

+ (XKPayManger *)sharedMange
{
    static XKPayManger *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[XKPayManger alloc] init];
    });
    return handler;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //微信支付的回调通知在微信授权管理类里面发送
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayNotification:) name:KNotiWxPayResult object:nil];
    }
    return self;
}

//支付宝回调
- (void)aliPayhandle:(NSString *)status{

    //4000 支付失败 6001 取消支付 6002 网络错误 9000 成功
    if ([status isEqualToString:@"9000"]) {
        self.block(AliPay, YES, nil);
    }else if ([status isEqualToString:@"6002"]){
        NSError *error = [NSError errorWithDomain:@"网络错误" code:6002 userInfo:nil];
        self.block(AliPay, NO, error);
    }else if ([status isEqualToString:@"6001"]){
        NSError *error = [NSError errorWithDomain:@"取消支付" code:6001 userInfo:nil];
        self.block(AliPay, NO, error);
    }else{
        //其他未知错误
        NSError *error = [NSError errorWithDomain:@"支付失败" code:4000 userInfo:nil];
        self.block(AliPay, NO, error);
    }
}

//微信支付回调
- (void)wxPayNotification:(NSNotification *)noti{
    PayResp *response = noti.userInfo[@"result"];
    // 微信终端返回给第三方的关于支付结果的结构体
    //4000 支付失败 6001 取消支付 6002 网络错误 9000 成功
        switch (response.errCode) {
            case WXSuccess:
            {   //支付
                self.block(WXPay, YES, nil);
            }
                break;
            case WXErrCodeCommon:
            {
                NSError *error = [NSError errorWithDomain:@"支付失败" code:WXErrCodeCommon userInfo:nil];
                self.block(WXPay, NO, error);
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                NSError *error = [NSError errorWithDomain:@"取消支付" code:WXErrCodeUserCancel userInfo:nil];
                self.block(WXPay, NO, error);
            }
                break;
            default:
            {
                NSError *error = [NSError errorWithDomain:@"支付失败" code:response.errCode userInfo:nil];
                self.block(WXPay, NO, error);
            }
                break;
        }
}

- (void)aliPay:(NSString *)authInfoStr complete:(nonnull void (^)(PayType, BOOL, NSError * _Nonnull))complete{
    if (authInfoStr != nil) {
        //应用注册scheme
        NSString *appScheme = @"XKAliPay";
        
        //开始支付
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:^(NSDictionary *resultDic) {
                                               [self aliPayhandle:resultDic[@"resultStatus"]];
                                           }];
        self.block = ^(PayType type, BOOL isSuccess, NSError *error) {
            complete(type,isSuccess,error);
        };
    }
}

- (void)applicationAlipayOpenURL:(NSURL *)url {
    //支付跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [self aliPayhandle:resultDic[@"resultStatus"]];
    }];
    // 授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        [self aliPayhandle:resultDic[@"resultStatus"]];
    }];
}

- (void)wxPay:(NSDictionary *)dict complete:(nonnull void (^)(PayType, BOOL, NSError * _Nonnull))complete{
    if(![WXApi isWXAppInstalled]){
        NSError *error = [NSError errorWithDomain:@"尚未安装微信" code:-1 userInfo:nil];
        complete(WXPay,NO,error);
        return;
    }
    //调起微信支付
    PayReq* request             = [[PayReq alloc] init];
    request.partnerId           = [dict objectForKey:@"partnerid"];
    request.prepayId            = [dict objectForKey:@"prepayid"];
    request.nonceStr            = [dict objectForKey:@"noncestr"];
    request.package             = @"Sign=WXPay";
    
    NSNumber *time = [dict objectForKey:@"timestamp"];
    
    request.timeStamp           = [time intValue];
    request.sign                = [dict objectForKey:@"sign"];
    
    [WXApi sendReq:request completion:^(BOOL success) {
        NSLog(@"sfdsf");
    }];
    self.block = ^(PayType type, BOOL isSuccess, NSError *error) {
        complete(type,isSuccess,error);
    };
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
