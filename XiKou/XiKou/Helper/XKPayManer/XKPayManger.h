//
//  XKPayManger.h
//  XiKou
//
//  Created by L.O.U on 2019/7/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    RedPackgePay,
    WXPay,
    AliPay,
    BankCardPay,
} PayType;
@interface XKPayManger : NSObject

/**
 *  单例
 */
+ (XKPayManger *)sharedMange;

/**
 *  支付宝支付
 */
- (void)aliPay:(NSString *)authInfoStr
      complete:(void(^)(PayType type,BOOL isSuccess,NSError *error))complete;

/**
 *  支付宝支付回调,appdelegate里面使用
 */
- (void)applicationAlipayOpenURL:(NSURL *)url;

/**
 *  微信支付
 */
- (void)wxPay:(NSDictionary *)dic
     complete:(void(^)(PayType type,BOOL isSuccess,NSError *error))complete;;
@end

NS_ASSUME_NONNULL_END
